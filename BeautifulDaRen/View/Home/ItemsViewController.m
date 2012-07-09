//
//  ItemsViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ItemsViewController.h"
#import "ViewConstants.h"
#import "WaresItem.h"
#import "WeiboDetailViewController.h"
#import "ViewHelper.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "BorderImageView.h"
#import "BSDKManager.h"
#import "BSDKDefines.h"
#import "iToast.h"

#define COLUMNS_PER_ROW 4
#define GRID_X_OFFSET 3
#define GRID_Y_OFFSET 5

#define GRID_X_DELTA 80
#define GRID_Y_DELTA 80

@interface ItemsViewController()

@property (retain, nonatomic) NSMutableArray * itemsHeight;
@property (assign, nonatomic) NSInteger pageIndex;
@property (retain, nonatomic) id observerForLoginStatus;
@property (assign, atomic) BOOL isSyncSccuessed;
@property (assign, nonatomic) BOOL isFetchMore;
-(void)loadItemsHeight;

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
        self.itemDatas = [[NSMutableArray alloc] initWithArray:array];
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
        CGFloat picWidth = [[[self.itemDatas objectAtIndex:i] valueForKey:@"Picture_width"] floatValue];
        CGFloat picHeight = [[[self.itemDatas objectAtIndex:i] valueForKey:@"Picture_height"] floatValue];
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
    [[WeiboDetailViewController alloc] initWithDictionary:[self.itemDatas objectAtIndex:borderImageView.index]];
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

- (NSInteger)flowView:(WaterFlowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    return [self.itemDatas count] / 3;
}

- (WaterFlowCell *)flowView:(WaterFlowView *)flowView cellForRowAtIndex:(NSInteger)index
{
    static NSString *cellIdentifier = @"WaterFlowCell";
	WaterFlowCell *cell = nil;
    // TODO don't use reusedable cell, there is some issues.
    cell = [flowView dequeueReusableCellWithIdentifier:cellIdentifier withIndex:index];
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
        
        NSDictionary * dict = [self.itemDatas objectAtIndex:index];
        CGFloat picWidth = [[dict valueForKey:@"Picture_width"] floatValue];
        CGFloat picHeight = [[dict valueForKey:@"Picture_height"] floatValue];
        CGFloat frameWidth = (self.view.frame.size.width - 14) / 3;
        CGFloat frameHeight = (frameWidth / picWidth) * picHeight;
        
        UIImageView * imageView = [[UIImageView alloc] init];
        NSString * url = [dict valueForKey:@"pic_102"];
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
    if (self.isSyncSccuessed && self.isFetchMore) {
        self.isSyncSccuessed = NO;
        self.pageIndex ++;
        UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activityIndicator.frame = CGRectMake(SCREEN_WIDTH/2, 2*ADS_CELL_HEIGHT + CONTENT_MARGIN, CGRectGetWidth(activityIndicator.frame), CGRectGetHeight(activityIndicator.frame));
        
        [self.view addSubview:activityIndicator];
        
        [activityIndicator startAnimating];
        
        processDoneWithDictBlock block = ^(AIO_STATUS status, NSDictionary *data)
        {
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            [activityIndicator release];
            
            if (K_BSDK_IS_RESPONSE_OK(data)) {
                NSArray * array = [data valueForKey:@"BlogList"];
                if ([array count] == 0)
                {
                    self.isFetchMore = NO;
                }
                //TODO [felix] should to remove
                for (NSDictionary * dict in array) {
                    if ([[dict valueForKey:@"Picture_width"] floatValue] > 0)
                    {
                        [self.itemDatas addObject:dict];
                    }
                }
                [self loadItemsHeight];
                [_waterFlowView reloadData];
                self.isSyncSccuessed = YES;
            }
            else
            {
                [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
            }

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

-(void)setItemDatas:(NSMutableArray *)itemDatas
{
    [_itemDatas release];
    _itemDatas = [itemDatas mutableCopy];
    
    [self loadItemsHeight];
    [_waterFlowView reloadData];
}

@end
