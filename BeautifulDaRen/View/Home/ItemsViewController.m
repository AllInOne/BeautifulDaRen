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

#define INDICATOR_HEIGHT 30
@interface ItemsViewController()

@property (retain, nonatomic) NSMutableArray * itemsHeight;
@property (assign, nonatomic) NSInteger pageIndex;
@property (retain, nonatomic) id observerForLoginStatus;
@property (assign, atomic) BOOL isSyncSccuessed;
@property (assign, nonatomic) BOOL isFetchMore;

-(void)loadItemsHeight;
-(NSDictionary*) getValidItemDictionaryAtIndex:(NSUInteger)index;
@end

@implementation ItemsViewController
@synthesize waterFlowView = _waterFlowView;
@synthesize isSyncSccuessed = _isSyncSccuessed;
@synthesize pageIndex = _pageIndex;
@synthesize itemDatas = _itemDatas;
@synthesize itemsHeight = _itemsHeight;
@synthesize isFetchMore = _isFetchMore;
@synthesize observerForLoginStatus = _observerForLoginStatus;

-(id)initWithArray:(NSArray*)array
{
    self = [super initWithNibName:@"ItemsViewController" bundle:nil];
    if (self) {
        _itemDatas = [[NSMutableArray alloc] initWithArray:array];
    }
    return self;
}

#pragma mark View

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
    [_waterFlowView release];
    [_itemsHeight release];
    [_itemDatas release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageIndex = 1;
    self.isSyncSccuessed = YES;
    self.isFetchMore = YES;
    
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
    [self refresh];
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

-(void)refresh
{
    if (self.isSyncSccuessed && self.isFetchMore)
    {
        self.isSyncSccuessed = NO;     
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
        
        CGFloat yPointOfActivityIndicator = self.waterFlowView.contentSize.height;
        if (self.waterFlowView.contentSize.height == 0) {
            yPointOfActivityIndicator = 20;
        }
        callBackBlock callback = [ViewHelper getIndicatorViewBlockWithFrame:CGRectMake(120, yPointOfActivityIndicator, 200,INDICATOR_HEIGHT) inView:self.waterFlowView];   
        processDoneWithDictBlock block = ^(AIO_STATUS status, NSDictionary *data)
        {
            callback();
            Block_release(callback);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            
            if (AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
            {
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
                [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
            }
            self.isSyncSccuessed = YES;
        };
        if ([[BSDKManager sharedManager] isLogin])
        {
            NSString * userId = [[[NSUserDefaults standardUserDefaults]
                                  valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO]
                                 valueForKey:KEY_ACCOUNT_ID];
            [[BSDKManager sharedManager] getFriendsWeiboListByUserId:userId
                                                            pageSize:20
                                                           pageIndex:self.pageIndex
                                                     andDoneCallback:block];
        }
        else {
            [[BSDKManager sharedManager] getWeiboListByUserId:nil
                                                     pageSize:20
                                                    pageIndex:self.pageIndex
                                              andDoneCallback:block];
        }
    }
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
    self.pageIndex = 1;
}
@end
