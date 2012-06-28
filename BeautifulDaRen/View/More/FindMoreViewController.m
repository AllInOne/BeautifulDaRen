//
//  FindMoreViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/8/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FindMoreViewController.h"
#import "FriendItemCell.h"
#import "ViewConstants.h"
#import "ViewHelper.h"
#import "FindFriendViewCell.h"
#import "FindWeiboViewCell.h"
#import "FriendDetailViewController.h"
#import "FindWeiboViewController.h"
#import "BorderImageView.h"
#import "BSDKManager.h"
#import "iToast.h"
#import "WaterFlowView.h"
#import "BSDKDefines.h"
#import "WeiboDetailViewController.h"
#import "UIImageView+WebCache.h"

#define X_OFFSET 7
#define CONTENT_VIEW_HEIGHT_OFFSET 50
@interface FindMoreViewController()

@property (retain, nonatomic) IBOutlet UIScrollView * contentScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView * sameCityDaRenView;
@property (retain, nonatomic) IBOutlet UIScrollView * youMayInterestinView;
@property (retain, nonatomic) IBOutlet UIScrollView * hotDaRenView;
@property (retain, nonatomic) IBOutlet WaterFlowView * searchWeiboView;
@property (retain, nonatomic) IBOutlet UITableView * searchUserView;
@property (retain, nonatomic) IBOutlet UISearchBar * searchBar;
@property (assign, nonatomic) NSInteger searchUserPageIndex;
@property (assign, nonatomic) NSInteger searchWeiboPageIndex;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) NSMutableArray *searchWeiboResults;
@property (retain, nonatomic) NSMutableArray * weiboHeights;
@property (nonatomic, assign) BOOL isFindWeibo;
@property (assign , atomic) BOOL isSearchMore;

- (void) refreshSameCityDaRenView;
- (void) refreshYouMayInterestinView;
- (void) refreshHotDaRenView;
- (void) doSearch;
- (void) loadWeiboHeights;

@end

@implementation FindMoreViewController
@synthesize sameCityDaRenView = _sameCityDaRenView;
@synthesize youMayInterestinView = _youMayInterestinView;
@synthesize hotDaRenView = _hotDaRenView;
@synthesize contentScrollView = _contentScrollView;
@synthesize searchUserView = _searchUserView;
@synthesize searchBar = _searchBar;
@synthesize isFindWeibo = _isFindWeibo;
@synthesize searchResults = _searchResults;
@synthesize searchUserPageIndex = _searchUserPageIndex;
@synthesize searchWeiboPageIndex = _searchWeiboPageIndex;
@synthesize isSearchMore = _isSearchMore;
@synthesize searchWeiboView = _searchWeiboView;
@synthesize searchWeiboResults = _searchWeiboResults;
@synthesize weiboHeights = _weiboHeights;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)onRefreshButtonClicked
{
    [[iToast makeText:NSLocalizedString(@"refresh", @"refresh")] show];
}
#pragma mark - View lifecycle

-(void)refreshView
{
    [self refreshSameCityDaRenView];
    [self refreshHotDaRenView];
    [self refreshYouMayInterestinView];
}
-(void)dealloc
{
    [_sameCityDaRenView release];
    [_hotDaRenView release];
    [_youMayInterestinView release];
    [_contentScrollView release];
    [_searchUserView release];
    [_searchBar release];
    [_searchResults release];
    [_searchWeiboResults release];
    [_searchWeiboView release];
    [_weiboHeights release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sameCityDaRenView = nil;
    self.youMayInterestinView = nil;
    self.hotDaRenView = nil;
    self.contentScrollView = nil;
    self.searchUserView = nil;
    self.searchBar = nil;
    self.searchResults = nil;
    self.searchWeiboView = nil;
    self.searchWeiboResults = nil;
    self.weiboHeights = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResults = [[NSMutableArray alloc] init];
    self.searchWeiboResults = [[NSMutableArray alloc] init];
    self.weiboHeights = [[NSMutableArray alloc] init];
    self.searchUserPageIndex = 1;
    self.searchWeiboPageIndex = 1;
    self.isFindWeibo = NO;
    self.isSearchMore = YES;
    [self.navigationItem setTitle:NSLocalizedString(@"find_weibo_or_friend", @"find_weibo_or_friend")];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    {
        _searchBar.backgroundImage = [UIImage imageNamed:@"search_switcher_btn"];
        _searchBar.scopeBarBackgroundImage = [UIImage imageNamed:@"search_switcher_btn"];
        [_searchBar setScopeBarButtonBackgroundImage:[UIImage imageNamed:@"search_switcher_selected"] forState:UIControlStateSelected];
        [_searchBar setScopeBarButtonBackgroundImage:[UIImage imageNamed:@"search_switcher_unselected"] forState:UIControlStateNormal];
        [_searchBar setScopeBarButtonDividerImage:[UIImage imageNamed:@"searchScopeDividerRightSelected"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected];
        [_searchBar setScopeBarButtonDividerImage:[UIImage imageNamed:@"searchScopeDividerLeftSelected"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal];
    }
    else
    {
    }
    _searchBar.scopeButtonTitles = [NSArray arrayWithObjects:
                                    NSLocalizedString(@"weibo", @""),
                                    NSLocalizedString(@"user", @""), nil];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(waterFlowCellSelected:)
                                                 name:@"borderImageViewSelected"
                                               object:nil];
    
    [_contentScrollView setContentSize:CGSizeMake(0, 360)];
    [_contentScrollView setFrame:CGRectMake(0, CONTENT_VIEW_HEIGHT_OFFSET, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height)];
    
    [self.view addSubview:_contentScrollView];
    
    [self.searchUserView setFrame:CGRectMake(0, CONTENT_VIEW_HEIGHT_OFFSET + 44.0f, self.searchUserView.frame.size.width,270)];
    [self.view addSubview:self.searchUserView];
    [self.searchUserView setHidden:YES];
    
    self.searchWeiboView = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, CONTENT_VIEW_HEIGHT_OFFSET + 44.0f, 320,270)];
    self.searchWeiboView.flowdelegate = self;
    self.searchWeiboView.flowdatasource = self;
    [self.view addSubview:self.searchWeiboView];
    [self.searchWeiboView setHidden:YES];
    [self refreshView];
}

-(void)viewWillDisappear:(BOOL)animated
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
    BorderImageView * weiboView = (BorderImageView*)notification.object;
    WeiboDetailViewController *weiboDetailController = 
    [[WeiboDetailViewController alloc] initWithDictionary:[self.searchWeiboResults objectAtIndex:weiboView.index]];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
    [weiboDetailController release];
}

- (void)refreshSameCityDaRenView
{
    static NSString * cellViewIdentifier = @"FriendItemCell";
    NSInteger scrollWidth = 0;
    NSArray * nameArray = [NSArray arrayWithObjects:
                           @"我是谁知道",
                           @"飞越板凳", 
                           @"优乐美",
                           @"东东",
                           @"你是我唯一", 
                           @"天府广场",
                           @"奥斯卡", 
                           @"天之骄子",
                           @"醉在黄鹤楼", 
                           @"半个火枪手",
                           @"影子爱人", 
                           nil];
    NSArray * avatars = [NSArray arrayWithObjects:
                         @"search_avatar_sample1",
                         @"search_avatar_sample2",
                         @"search_avatar_sample3",
                         @"search_avatar_sample4",
                         @"search_avatar_sample5",
                         @"search_avatar_sample6",
                         @"search_avatar_sample7",
                         @"search_avatar_sample8",
                         @"search_avatar_sample9",
                         @"search_avatar_sample10",
                         @"search_avatar_sample11",
                         nil];
    for (int i = 0; i < [avatars count]; i++) {
        FriendItemCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellViewIdentifier owner:self options:nil] objectAtIndex:0];
        
        cell.frame = CGRectMake(i * (cell.frame.size.width + X_OFFSET), 0,
                                cell.frame.size.width,
                                cell.frame.size.height);
        scrollWidth += (cell.frame.size.width + X_OFFSET);
        
        [_sameCityDaRenView addSubview:cell];
    
        BorderImageView * tempBorderView = [[BorderImageView alloc] initWithFrame:cell.friendImageView.frame andImage:[UIImage imageNamed:[avatars objectAtIndex:i]]];
        [cell.friendImageView addSubview:tempBorderView];
        cell.friendNameLabel.text = [nameArray objectAtIndex:i];
        
        [tempBorderView release];
    }
    _sameCityDaRenView.delegate = self;
    [_sameCityDaRenView setContentSize:CGSizeMake(scrollWidth, 0)];
}

-(void) refreshYouMayInterestinView
{
    static NSString * cellViewIdentifier = @"FriendItemCell";
    NSInteger scrollWidth = 0;
    NSArray * nameArray = [NSArray arrayWithObjects:
                           @"天之骄子",
                           @"醉在黄鹤楼", 
                           @"半个火枪手",
                           @"影子爱人", 
                           @"我是谁知道",
                           @"飞越板凳", 
                           @"我的优乐美",
                           @"东东",
                           @"你是我唯一", 
                           @"天府广场",
                           @"奥斯卡", 
                           nil];
    NSArray * avatars = [NSArray arrayWithObjects:
                         @"search_avatar_sample5",
                         @"search_avatar_sample6",
                         @"search_avatar_sample7",
                         @"search_avatar_sample8",
                         @"search_avatar_sample9",
                         @"search_avatar_sample10",
                         @"search_avatar_sample11",
                         @"search_avatar_sample1",
                         @"search_avatar_sample2",
                         @"search_avatar_sample3",
                         @"search_avatar_sample4",
                         nil];
    for (int i = 0; i < [avatars count]; i++) {
        FriendItemCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellViewIdentifier owner:self options:nil] objectAtIndex:0];
        cell.frame = CGRectMake(i * (cell.frame.size.width + X_OFFSET), 0,
                                cell.frame.size.width,
                                cell.frame.size.height);
        scrollWidth += (cell.frame.size.width + X_OFFSET);
        
        [_youMayInterestinView addSubview:cell];
        
        BorderImageView * tempBorderView = [[BorderImageView alloc] initWithFrame:cell.friendImageView.frame andImage:[UIImage imageNamed:[avatars objectAtIndex:i]]];
        [cell.friendImageView addSubview:tempBorderView];
        cell.friendNameLabel.text = [nameArray objectAtIndex:i];
        
        [tempBorderView release];
    }
    _youMayInterestinView.delegate = self;
    [_youMayInterestinView setContentSize:CGSizeMake(scrollWidth, 0)];
}

- (void) refreshHotDaRenView
{
    static NSString * cellViewIdentifier = @"FriendItemCell";
    NSArray * nameArray = [NSArray arrayWithObjects:
                           @"东东",
                           @"你是我唯一", 
                           @"天府广场",
                           @"奥斯卡", 
                           @"天之骄子",
                           @"醉在黄鹤楼", 
                           @"半个火枪手",
                           @"影子爱人", 
                           @"我是谁知道",
                           @"飞越板凳", 
                           @"我的优乐美",
                           nil];
    NSInteger scrollWidth = 0;
    NSArray * avatars = [NSArray arrayWithObjects:
                         @"search_avatar_sample9",
                         @"search_avatar_sample10",
                         @"search_avatar_sample11",
                         @"search_avatar_sample1",
                         @"search_avatar_sample2",
                         @"search_avatar_sample3",
                         @"search_avatar_sample4",
                         @"search_avatar_sample5",
                         @"search_avatar_sample6",
                         @"search_avatar_sample7",
                         @"search_avatar_sample8",
                         nil];
    for (int i = 0; i < [avatars count]; i++) {
        FriendItemCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellViewIdentifier owner:self options:nil] objectAtIndex:0];
        cell.frame = CGRectMake(i * (cell.frame.size.width + X_OFFSET), 0,
                                cell.frame.size.width,
                                cell.frame.size.height);
        scrollWidth += (cell.frame.size.width + X_OFFSET);
        
        BorderImageView * tempBorderView = [[BorderImageView alloc] initWithFrame:cell.friendImageView.frame andImage:[UIImage imageNamed:[avatars objectAtIndex:i]]];
        [cell.friendImageView addSubview:tempBorderView];
        cell.friendNameLabel.text = [nameArray objectAtIndex:i];
        
        [_hotDaRenView addSubview:cell];
        [tempBorderView release];
    }
    _hotDaRenView.delegate = self;
    [_hotDaRenView setContentSize:CGSizeMake(scrollWidth, 0)];
}
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * viewController = [[FriendDetailViewController alloc] initWithDictionary:[self.searchResults objectAtIndex:[indexPath row]]];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: viewController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
    [viewController release];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

#pragma mark UITableViewDataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_searchResults count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *findFriendViewCell = @"FindFriendViewCell";
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:findFriendViewCell];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:findFriendViewCell owner:self options:nil] objectAtIndex:0];
    }
    FindFriendViewCell * friendCell = (FindFriendViewCell*)cell;
    NSDictionary * friendDict = [self.searchResults objectAtIndex:[indexPath row]];
    friendCell.nameLabel.text = [friendDict valueForKey:KEY_ACCOUNT_USER_NAME];
    friendCell.levelLabel.text = [NSString stringWithFormat:@"LV%d",[[friendDict valueForKey:KEY_ACCOUNT_LEVEL] intValue]];
    if ([[friendDict valueForKey:KEY_ACCOUNT_RELATION] intValue] == FRIEND_RELATIONSHIP_MY_FOLLOW
        || [[friendDict valueForKey:KEY_ACCOUNT_RELATION] intValue] == FRIEND_RELATIONSHIP_INTER_FOLLOW) {
        [friendCell.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    else 
    {
        [friendCell.followButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    friendCell.followButton.tag = [indexPath row];
    friendCell.delegate = self;
    return cell;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.searchUserView.contentOffset.y + self.searchUserView.frame.size.height >= self.searchUserView.contentSize.height && self.isSearchMore)
    {
        self.searchUserPageIndex ++;
        [self doSearch];
    }
}
#pragma mark - UISearchBarDelegate delegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    CGFloat height = 44.0f;
    self.searchUserPageIndex = 1;
    self.searchWeiboPageIndex = 1;
    [self.searchResults removeAllObjects];
    BOOL isShowsCancelButton = NO;
    BOOL isShowsScopeButton = NO;
    if([searchText length] > 0)
    {
        height = 88.0f;
        isShowsCancelButton = YES;
        isShowsScopeButton = YES;
        if(_contentScrollView.frame.origin.y == CONTENT_VIEW_HEIGHT_OFFSET)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            [_contentScrollView setFrame:CGRectMake(_contentScrollView.frame.origin.x, CONTENT_VIEW_HEIGHT_OFFSET + 44.0f, _contentScrollView.frame.size.width,_contentScrollView.frame.size.height)];
            
            [UIView commitAnimations];
        }
    }
    else
    {
        height = 44.0f;
        
        isShowsCancelButton = NO;
        isShowsScopeButton = NO;
        if(_contentScrollView.frame.origin.y == CONTENT_VIEW_HEIGHT_OFFSET + 44.0f)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            [_contentScrollView setFrame:CGRectMake(_contentScrollView.frame.origin.x, CONTENT_VIEW_HEIGHT_OFFSET, _contentScrollView.frame.size.width,_contentScrollView.frame.size.height)];
            
            [UIView commitAnimations];
        }
    }
    
    [searchBar setShowsCancelButton:isShowsCancelButton animated:YES];
    [searchBar setShowsScopeBar:isShowsScopeButton];
    [searchBar setSelectedScopeButtonIndex:1];
    [searchBar setFrame:CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, searchBar.frame.size.width, height)];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_contentScrollView setHidden:YES];
    [self.searchUserView setHidden:NO];
    [self.searchWeiboView setHidden:YES];
    [searchBar endEditing:YES];
    
    [self doSearch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.searchUserView setHidden:YES];
    [self.searchWeiboView setHidden:YES];
    [self.contentScrollView setHidden:NO];

    searchBar.text = @"";
    [searchBar endEditing:YES];
    [searchBar setShowsScopeBar:NO];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar setFrame:CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, searchBar.frame.size.width, 44.0f)];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [_contentScrollView setFrame:CGRectMake(_contentScrollView.frame.origin.x, CONTENT_VIEW_HEIGHT_OFFSET, _contentScrollView.frame.size.width,_contentScrollView.frame.size.height)];
    
    [UIView commitAnimations];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    self.isFindWeibo = (selectedScope ==0) ? YES : NO;
    if (self.isFindWeibo)
    {
        [self.searchUserView setHidden:YES];
        [self.searchWeiboView setHidden:NO];
    }
    else
    {
        [self.searchUserView setHidden:NO];
        [self.searchWeiboView setHidden:YES];
    }
    [self doSearch];
}

- (void)onItemSelected:(int)index
{
    FriendDetailViewController *weiboDetailController = [[FriendDetailViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
    [weiboDetailController release];
}

- (void) doSearch
{
    self.isSearchMore = NO;
    if ([self.searchBar.text length] <= 0) {
        return;
    }
    
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.frame = CGRectMake(SCREEN_WIDTH/2, 2*ADS_CELL_HEIGHT + CONTENT_MARGIN, CGRectGetWidth(activityIndicator.frame), CGRectGetHeight(activityIndicator.frame));
    
    [self.view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    if (self.isFindWeibo == NO) {
        [[BSDKManager sharedManager] searchUsersByUsername:self.searchBar.text
                                                  pageSize:10
                                                 pageIndex:self.searchUserPageIndex 
                                           andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                               [activityIndicator stopAnimating];
                                               [activityIndicator removeFromSuperview];
                                               [activityIndicator release];

                                               self.isSearchMore = YES;
                                               if (status == AIO_STATUS_SUCCESS) {
                                                   NSArray * tempArray = [[data valueForKey:@"UserList"] copy];
                                                   for (NSDictionary * dict in tempArray)
                                                   {
                                                       [self.searchResults addObject:[dict mutableCopy]];
                                                   }
                                               }
                                               else {
                                                   [[iToast makeText:[NSString stringWithFormat:@"search status error: %d", status]] show];
                                               }
                                               [self.searchUserView reloadData];

        }];
    }
    else
    {
        processDoneWithDictBlock block = ^(AIO_STATUS status, NSDictionary *data)
        {
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            [activityIndicator release];
            
            if (status == AIO_STATUS_SUCCESS)
            {
                NSArray * array = [data valueForKey:@"BlogList"];
                //TODO [felix] should to remove
                for (NSDictionary * dict in array) {
                    if ([[dict valueForKey:@"Picture_width"] floatValue] > 0)
                    {
                        [self.searchWeiboResults addObject:dict];
                    }
                }
                [self.weiboHeights removeAllObjects];
                [self loadWeiboHeights];
                [self.searchWeiboView reloadData];
            }
            else
            {
                [[iToast makeText:[NSString stringWithFormat:@"search status error: %d", status]] show];
            }
            self.isSearchMore = YES;
        };

        [[BSDKManager sharedManager] searchWeiboByKeyword:self.searchBar.text
                                                 pageSize:10
                                                pageIndex:self.searchWeiboPageIndex
                                          andDoneCallback:block];
    }}

#pragma mark ButtonPressDelegate
- (void) didButtonPressed:(UIButton*)button  inView:(UIView *) view
{
    NSInteger index = button.tag;
    NSMutableDictionary * friendDict = [self.searchResults objectAtIndex:index];
    if ([[friendDict valueForKey:KEY_ACCOUNT_RELATION] intValue] == FRIEND_RELATIONSHIP_MY_FOLLOW
        || [[friendDict valueForKey:KEY_ACCOUNT_RELATION] intValue] == FRIEND_RELATIONSHIP_INTER_FOLLOW)
    {
        [[BSDKManager sharedManager] unFollowUser:[[friendDict valueForKey:KEY_ACCOUNT_ID] intValue]
                                  andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                      if(AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
                                      {
                                          [friendDict setValue:[NSNumber numberWithInt:FRIEND_RELATIONSHIP_NONE] forKey:KEY_ACCOUNT_RELATION];
                                          [self.searchUserView reloadData];
                                      }
                                      else
                                      {
                                          [[iToast makeText:@"取消关注失败!"] show];
                                      }
                                  }];
    }
    else 
    {
        [[BSDKManager sharedManager] followUser:[[friendDict valueForKey:KEY_ACCOUNT_ID] intValue]
                                andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                    if(AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
                                    {
                                        [friendDict setValue:[NSNumber numberWithInt:FRIEND_RELATIONSHIP_MY_FOLLOW] forKey:KEY_ACCOUNT_RELATION];
                                        [self.searchUserView reloadData];
                                    }
                                    else
                                    {
                                        [[iToast makeText:@"关注失败!"] show];
                                    }
                                }];
    }
    
}

#pragma mark WaterFlowViewDelegate

- (CGFloat)flowView:(WaterFlowView *)flowView heightForCellAtIndex:(NSInteger)index
{
    return [[self.weiboHeights objectAtIndex:index] floatValue];
}

- (void)flowView:(WaterFlowView *)flowView didSelectAtCell:(WaterFlowCell*)cell ForIndex:(int)index
{

}

- (void)flowView:(WaterFlowView *)flowView willLoadData:(int)page
{
    [self.searchWeiboView reloadData];
}

- (void)didScrollToBottom
{
    if (self.isSearchMore)
    {
        self.searchWeiboPageIndex ++;
        [self doSearch];
    }
}

#pragma mark WaterFlowViewDatasource

- (NSInteger)numberOfColumnsInFlowView:(WaterFlowView*)flowView
{
    return 3;
}

- (NSInteger)flowView:(WaterFlowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    return [self.searchWeiboResults count] / 3;
}

- (WaterFlowCell *)flowView:(WaterFlowView *)flowView cellForRowAtIndex:(NSInteger)index
{
    static NSString *cellIdentifier = @"WaterFlowCell";
	WaterFlowCell *cell = nil;
    // TODO don't use reusedable cell, there is some issues.
    //    cell = [flowView dequeueReusableCellWithIdentifier:cellIdentifier withIndex:index];
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
        
        NSDictionary * dict = [self.searchWeiboResults objectAtIndex:index];
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

- (void) loadWeiboHeights
{
    NSInteger count = [self.searchWeiboResults count];
    for (int i = 0; i < count; i++)
    {
        CGFloat picWidth = [[[self.searchWeiboResults objectAtIndex:i] valueForKey:@"Picture_width"] floatValue];
        CGFloat picHeight = [[[self.searchWeiboResults objectAtIndex:i] valueForKey:@"Picture_height"] floatValue];
        CGFloat frameWidth = (self.view.frame.size.width - 14) / 3;
        CGFloat frameHeight = (frameWidth / picWidth) * picHeight;
        [self.weiboHeights addObject:[NSNumber numberWithFloat:(frameHeight+4)]];
    }
}
@end
