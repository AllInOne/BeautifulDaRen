//
//  ItemsViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ItemsViewController.h"
#import "ViewConstants.h"
#import "WeiboDetailViewController.h"
#import "ViewHelper.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "BorderImageView.h"
#import "BSDKDefines.h"
#import "BSDKManager.h"
#import "BSDKDefines.h"
#import "iToast.h"

#define COLUMNS_PER_ROW 4
#define GRID_X_OFFSET 3
#define GRID_Y_OFFSET 5

#define GRID_X_DELTA 80
#define GRID_Y_DELTA 80
#define REFRESHING_HEIGHT 65
#define INDICATOR_HEIGHT 30

#define REFRESH_PAGE_SIZE    15

@interface ItemsViewController() {
    BOOL _originYChanged;
}

@property (retain, nonatomic) NSMutableArray * itemsHeight;
@property (assign, nonatomic) NSInteger pageIndex;
@property (retain, nonatomic) id observerForLoginStatus;
@property (assign, atomic) BOOL isSyncSccuessed;
@property (assign, nonatomic) BOOL isFetchMore;
@property (assign, nonatomic) BOOL isPollTop;

- (void)loadItemsHeight;
- (void)didEndPollRefresh;
- (void)refreshDataIsClean:(BOOL)isClean;
- (void)refreshDataFromNetworkWithCallback:(processDoneWithDictBlock)doneCallback;
- (NSDictionary*) getValidItemDictionaryAtIndex:(NSUInteger)index;

@end

@implementation ItemsViewController
@synthesize waterFlowView = _waterFlowView;
@synthesize isSyncSccuessed = _isSyncSccuessed;
@synthesize pageIndex = _pageIndex;
@synthesize itemDatas = _itemDatas;
@synthesize itemsHeight = _itemsHeight;
@synthesize isFetchMore = _isFetchMore;
@synthesize isPollTop = _isPollTop;
@synthesize observerForLoginStatus = _observerForLoginStatus;
@synthesize viewMode = _viewMode;
@synthesize hotClassId = _hotClassId;

-(id)initWithArray:(NSArray*)array
{
    self = [super initWithNibName:@"ItemsViewController" bundle:nil];
    if (self) {
        _itemDatas = [[NSMutableArray alloc] initWithArray:array];
    }
    return self;
}

#pragma mar. XAQAWUIOP[]\=-0923  View

- (void) loadItemsHeight
{
    [_itemsHeight removeAllObjects];
    NSInteger count = [self.itemDatas count];
    for (int i = 0; i < count; i++)
    {
        NSDictionary * dict = [self getValidItemDictionaryAtIndex:i];
        CGFloat picWidth = [[dict valueForKey:K_BSDK_PICTURE_WIDTH] floatValue];
        CGFloat picHeight = [[dict valueForKey:K_BSDK_PICTURE_HEIGHT] floatValue];
        CGFloat frameWidth = (self.view.frame.size.width - 14) / 3;
        CGFloat frameHeight = (frameWidth / picWidth) * picHeight;
        [_itemsHeight addObject:[NSNumber numberWithFloat:(frameHeight+4)]];
    }
}

#pragma mark - View lifecycle

-(void) dealloc
{
    [refreshHeaderView release]; 
    [_waterFlowView release];
    [_itemsHeight release];
    [_itemDatas release];
    [_hotClassId release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pageIndex = 1;
    self.isSyncSccuessed = YES;
    self.isFetchMore = YES;
    self.isPollTop = YES;
    _originYChanged = NO;
    _itemsHeight = [[NSMutableArray alloc] init];
    [self loadItemsHeight];

    self.observerForLoginStatus = [[NSNotificationCenter defaultCenter]
                                   addObserverForName:K_NOTIFICATION_LOGIN_SUCCESS
                                   object:nil
                                   queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       self.isFetchMore = YES;
                                       self.pageIndex = 1;
                                   }];

    _waterFlowView = [[WaterFlowView alloc] initWithFrame:self.view.frame];
    _waterFlowView.flowdelegate = self;
    _waterFlowView.flowdatasource = self;
    [self.view addSubview:_waterFlowView];

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, INDICATOR_HEIGHT, 0.0);
    self.waterFlowView.contentInset = contentInsets;
    self.waterFlowView.scrollIndicatorInsets = contentInsets;


    if (refreshHeaderView == nil) {
        refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, REFRESHING_HEIGHT)];
        refreshHeaderView.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:1.0 alpha:0.3];
        refreshHeaderView.bottomBorderThickness = 1.0;
        [refreshHeaderView setState:EGOOPullRefreshNormal];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.waterFlowView = nil;
    [self.itemsHeight removeAllObjects];
    self.itemsHeight = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(waterFlowCellSelected:)
                                                 name:@"borderImageViewSelected"
                                               object:nil];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)waterFlowCellSelected:(NSNotification *)notification
{
    BorderImageView * borderImageView = (BorderImageView*)notification.object;
    WeiboDetailViewController *weiboDetailController =
    [[WeiboDetailViewController alloc] initWithDictionary:[self getValidItemDictionaryAtIndex:borderImageView.index]];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];

    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];

    [navController release];
    [weiboDetailController release];
}

#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterFlowView *)flowView
{
    return 3;
}

- (NSInteger)numberOfDataInFlowView:(WaterFlowView *)flowView
{
    return [self.itemDatas count];
}

- (WaterFlowCell *)flowView:(WaterFlowView *)flowView cellForRowAtIndex:(NSInteger)index
{
    static NSString *cellIdentifier = @"WaterFlowCell";
	WaterFlowCell *cell = nil;
    cell = [flowView dequeueReusableCellWithIdentifier:cellIdentifier withIndex:index];
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];

        NSDictionary * dict = [self getValidItemDictionaryAtIndex:index];
        CGFloat picWidth = [[dict valueForKey:K_BSDK_PICTURE_WIDTH] floatValue];
        CGFloat picHeight = [[dict valueForKey:K_BSDK_PICTURE_HEIGHT] floatValue];
        CGFloat frameWidth = (self.view.frame.size.width - 14) / 3;
        CGFloat frameHeight = (frameWidth / picWidth) * picHeight;

        UIImageView * imageView = [[UIImageView alloc] init];
        NSString * url = [dict valueForKey:K_BSDK_PICTURE_102];
        [imageView setImageWithURL:[NSURL URLWithString:url]];

        BorderImageView * borderImageView = [[BorderImageView alloc] initWithFrame:CGRectMake(2, 2, frameWidth + 2, frameHeight + 2) andView:imageView];
        borderImageView.index = index;
        [cell addSubview:borderImageView];
        [borderImageView release];
        [imageView release];
	}
	return cell;
}

#pragma mark-
#pragma mark- WaterflowDelegate

- (CGFloat)flowView:(WaterFlowView *)flowView heightForCellAtIndex:(NSInteger)index
{
    return [[_itemsHeight objectAtIndex:index] floatValue];
}

- (void)flowView:(WaterFlowView *)flowView didSelectAtCell:(WaterFlowCell *)cell ForIndex:(int)index
{
    //TODO maybe it not need.
}

- (void)flowView:(WaterFlowView *)flowView willLoadData:(int)page
{
    [_waterFlowView reloadData];
}

- (void)didScrollToBottom
{
    self.isPollTop = NO;
    [self refreshDataIsClean:NO];
}

-(void)setItemDatas:(NSMutableArray *)itemDatas
{
    [_itemDatas release];
    _itemDatas = [itemDatas mutableCopy];

    [self loadItemsHeight];
    [_waterFlowView reloadData];
}

-(NSDictionary*) getValidItemDictionaryAtIndex:(NSUInteger)index
{
    NSDictionary * dict = [self.itemDatas objectAtIndex:index];
    if ([dict valueForKey:K_BSDK_PICTURE_102] == nil)
    {
        dict = [dict valueForKey:K_BSDK_RETWEET_STATUS];
    }
    return dict;
}

- (void)refreshDataFromNetworkWithCallback:(processDoneWithDictBlock)doneCallback
{
    switch (self.viewMode) {
        case ITEMSVIEW_MODE_HOME:
            if ([[BSDKManager sharedManager] isLogin])
            {
                NSString * userId = [[[NSUserDefaults standardUserDefaults]
                                      valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO]
                                     valueForKey:KEY_ACCOUNT_ID];
                [[BSDKManager sharedManager] getFriendsWeiboListByUserId:userId
                                                                pageSize:REFRESH_PAGE_SIZE
                                                               pageIndex:self.pageIndex
                                                         andDoneCallback:doneCallback];
            }
            else {
                [[BSDKManager sharedManager] getWeiboListByUserId:nil
                                                         pageSize:REFRESH_PAGE_SIZE
                                                        pageIndex:self.pageIndex
                                                  andDoneCallback:doneCallback];
            }
            break;
        case ITEMSVIEW_MODE_MINE:
            [[BSDKManager sharedManager] getWeiboListByUserId:[[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:KEY_ACCOUNT_ID]
                                                     pageSize:REFRESH_PAGE_SIZE
                                                    pageIndex:self.pageIndex
                                              andDoneCallback:doneCallback];
            break;
            
        case ITEMSVIEW_MODE_HOT:
            [[BSDKManager sharedManager] getWeiboListByClassId:self.hotClassId
                                                      pageSize:REFRESH_PAGE_SIZE
                                                     pageIndex:self.pageIndex
                                               andDoneCallback:doneCallback];
            
            break;
        default:
            break;
    }

}

- (void)refreshDataIsClean:(BOOL)isClean {
    NSLog(@"isSyncSccuessed :%d", _isSyncSccuessed);
    NSLog(@"isFetchMore :%d", _isFetchMore);
    NSLog(@"isPollTop :%d", _isPollTop);
    if (self.isSyncSccuessed && (self.isFetchMore || self.isPollTop))
    {
        self.isSyncSccuessed = NO;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];

        callBackBlock callback = nil;
        CGFloat yPointOfActivityIndicator = self.waterFlowView.contentSize.height;
        if (self.waterFlowView.contentSize.height == 0) {
            yPointOfActivityIndicator = 20;
        }

        callback = [ViewHelper getIndicatorViewBlockWithFrame:CGRectMake(120, yPointOfActivityIndicator, 200,INDICATOR_HEIGHT) inView:self.waterFlowView];
        processDoneWithDictBlock block = ^(AIO_STATUS status, NSDictionary *data)
        {
            callback();
            Block_release(callback);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];

            if (refreshHeaderView.superview == self.view) {
                [self didEndPollRefresh];
            }
            if (AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
            {
                if (isClean) {
                    [self.itemDatas removeAllObjects];
                }
                NSArray * array = [data valueForKey:K_BSDK_BLOGLIST];
                for (NSDictionary * dict in array)
                {
                    NSDictionary * weiboDict = [dict valueForKey:K_BSDK_PICTURE_102] == nil ? [dict valueForKey:K_BSDK_RETWEET_STATUS] : dict;
                    if ([[weiboDict valueForKey:K_BSDK_PICTURE_WIDTH] isEqualToString:@""]
                        || [[weiboDict valueForKey:K_BSDK_PICTURE_HEIGHT] isEqualToString:@""])
                    {
                        NSAssert(NO, @"Picture_width or Picture_height Can't be empty!");
                        continue;
                    }
                    [self.itemDatas addObject:dict];
                }
                [self loadItemsHeight];
                [_waterFlowView reloadData];

                if (([[data valueForKey:K_BSDK_PAGECOUNT] intValue] ==  self.pageIndex)
                    || ([[data valueForKey:K_BSDK_BLOGLIST] count] == 0))
                {
                    self.isFetchMore = NO;
                }
                else
                {
                    self.pageIndex ++;
                }
            }
            else
            {
//                Disable error notification
//                [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
            }
            self.isSyncSccuessed = YES;
            self.isPollTop = YES;
        };
        
        [self refreshDataFromNetworkWithCallback:block];
    }

}

-(void)refreshInNewAds:(BOOL)isNewAds
{
    self.pageIndex = 1;
    if (self.itemDatas.count > 0) {
        // Workaround, Close ads view, then client refresh button at the right top screen. then it can't show item view correctly.
        if (isNewAds) {
            [_waterFlowView setFrame:CGRectMake(_waterFlowView.frame.origin.x,
                                                _waterFlowView.frame.origin.y + 16,
                                                _waterFlowView.frame.size.width,
                                                _waterFlowView.frame.size.height)];
        }
        [self draggingToRefreshing];
        [self didRefresh];
    }
    [self refreshDataIsClean:YES];
}

-(void)reset
{
    self.isSyncSccuessed = YES;
    [self clearData];
}

-(void)clearData
{
    [self.itemDatas removeAllObjects];
    [self loadItemsHeight];
    [_waterFlowView reloadData];
    self.isFetchMore = YES;
    self.isPollTop = YES;
    self.pageIndex = 1;
}

- (void)didRefresh {
    if (self.isSyncSccuessed == YES && self.isPollTop
        && _originYChanged == NO) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];

        [refreshHeaderView setState:EGOOPullRefreshLoading];

        if (refreshHeaderView.superview != self.view) {
            [self.view addSubview:refreshHeaderView];
        }
                [_waterFlowView setFrame:CGRectMake(_waterFlowView.frame.origin.x,
                                            _waterFlowView.frame.origin.y + 68,
                                            _waterFlowView.frame.size.width,
                                            _waterFlowView.frame.size.height)];
        _originYChanged = YES;
        [UIView commitAnimations];
        self.pageIndex = 1;
        [self refreshDataIsClean:YES];
    }
}

- (void)cancelRefreshing {
    if (refreshHeaderView.state != EGOOPullRefreshLoading) {
        [self didEndPollRefresh];
    }
}

- (void)draggingToRefreshing {
    self.isPollTop = YES;
    if (self.isSyncSccuessed == YES && self.isPollTop) {
        [self.view addSubview:refreshHeaderView];
        [refreshHeaderView setState:EGOOPullRefreshNormal];
    }
}

- (void)releaseToRefreshing {
    if (self.isSyncSccuessed == YES && self.isPollTop) {
        [refreshHeaderView setState:EGOOPullRefreshPulling];
    }
}

- (void)didEndPollRefresh {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [refreshHeaderView removeFromSuperview];
    if (self.isSyncSccuessed == NO && _originYChanged == YES) {
        [_waterFlowView setFrame:CGRectMake(_waterFlowView.frame.origin.x,
                                            _waterFlowView.frame.origin.y - 68,
                                            _waterFlowView.frame.size.width,
                                            _waterFlowView.frame.size.height)];
        _originYChanged = NO;
    }
    [UIView commitAnimations];
}
@end
