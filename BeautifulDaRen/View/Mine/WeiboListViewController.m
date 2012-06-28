#import "WeiboListViewController.h"
#import "AtMeViewCell.h"
#import "WeiboDetailViewController.h"
#import "ViewHelper.h"
#import "BSDKManager.h"
#import "BSDKDefines.h"
#import "ViewConstants.h"
#import "CommentViewCell.h"

#define AUTOLOAD_PAGE_SIZE (3)

@interface WeiboListViewController()

@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) NSDictionary * friendDictionary;
@property (assign, nonatomic) NSInteger controllerType;

@property (assign, nonatomic) NSInteger currentPageIndex;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isAllRetrieved;

@property (retain, nonatomic) NSMutableArray * dataList;

-(NSString*)getCurrentBlogIdByData:(NSDictionary*)data;
-(UITableViewCell*)getCellofTableView:(UITableView*)tableView ByWeiboData:(NSDictionary*)data;
-(UITableViewCell*)getInitializedCellofTableView:(UITableView*)tableView ByWeiboData:(NSDictionary*)data;
-(CGFloat)getCellHeightofTableView:(UITableView*)tableView ByWeiboData:(NSDictionary*)data;

- (void)refreshData;
- (void)onDataLoadDone;
@end

@implementation WeiboListViewController
@synthesize tableView = _tableView;
@synthesize controllerType = _controllerType;
@synthesize friendDictionary = _friendDictionary;
@synthesize dataList = _dataList;

@synthesize footerView = _footerView;
@synthesize footerButton = _footerButton;
@synthesize loadingActivityIndicator = _loadingActivityIndicator;
@synthesize currentPageIndex = _currentPageIndex;
@synthesize isRefreshing = _isRefreshing;
@synthesize isAllRetrieved = _isAllRetrieved;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                 type:(NSInteger)type
           dictionary:(NSDictionary*)dictionary
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];
        _controllerType = type;
        if(_controllerType == WeiboListViewControllerType_FORWARD_ME)
        {
            [self.navigationItem setTitle:NSLocalizedString(@"@me", @"@me")];
        }
        else if(_controllerType == WeiboListViewControllerType_COMMENT_ME)
        {
            [self.navigationItem setTitle:NSLocalizedString(@"comment_me", @"comment_me")];
        }
        else if(_controllerType == WeiboListViewControllerType_MY_PUBLISH)
        {
            [self.navigationItem setTitle:NSLocalizedString(@"my_publish", @"my_publish")];
        }
        else if(_controllerType == WeiboListViewControllerType_MY_COLLECTION)
        {
            [self.navigationItem setTitle:NSLocalizedString(@"my_collection", @"my_collection")];
        }
        else if(_controllerType == WeiboListViewControllerType_MY_BUYED)
        {
            [self.navigationItem setTitle:NSLocalizedString(@"my_buyed", @"my_buyed")];
        }
        else if(_controllerType == WeiboListViewControllerType_FRIEND_WEIBO)
        {
            [self.navigationItem setTitle:NSLocalizedString(@"her_weibo", @"her_weibo")];
        }
        else if(_controllerType == WeiboListViewControllerType_FRIEND_COLLECTION)
        {
            [self.navigationItem setTitle:NSLocalizedString(@"her_collection", @"her_collection")];
        }
        else if (_controllerType == WeiboListViewControllerType_CATEGORY)
        {
            [self.navigationItem setTitle:[dictionary objectForKey:K_BSDK_CLASSNAME]];
        }
        self.friendDictionary = dictionary;
    }
    return self;
}

- (void) onBackButtonClicked
{
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) onRefreshButtonClicked
{
    self.currentPageIndex = 1;
    self.isAllRetrieved = NO;
    [self.dataList removeAllObjects];
    [self.tableView reloadData];
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataList = [NSMutableArray arrayWithCapacity:50];
    self.tableView.tableFooterView = self.footerView;
    _currentPageIndex = 1;

    [self refreshData];
}

- (void)onDataLoadDone
{
    [self.loadingActivityIndicator stopAnimating];
    
    self.isRefreshing = NO;
    self.currentPageIndex++;
    
    if ((self.dataList == nil) || ([self.dataList count] == 0)) {
        [self.footerButton setTitle:NSLocalizedString(@"no_message", @"no_message") forState:UIControlStateNormal];
        [self.loadingActivityIndicator setHidden:YES];
    }
    else
    {
        [self.footerView setHidden:YES];
        [self.tableView reloadData];
    }
}

- (void)refreshData
{
    [self.footerView setHidden:NO];
    [self.loadingActivityIndicator startAnimating];
    [self.footerButton setTitle:NSLocalizedString(@"loading_more", @"loading_more") forState:UIControlStateNormal];
    
    self.isRefreshing = YES;
    
    NSString * userId = self.friendDictionary ? [self.friendDictionary valueForKey:KEY_ACCOUNT_ID] : [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:KEY_ACCOUNT_ID];
    
    if (self.controllerType == WeiboListViewControllerType_COMMENT_ME) {
        [[BSDKManager sharedManager] getCommentListOfUser:userId
                                                 pageSize:AUTOLOAD_PAGE_SIZE
                                                pageIndex:_currentPageIndex
                                          andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                              if ([[data objectForKey:K_BSDK_COMMENTLIST] count] < AUTOLOAD_PAGE_SIZE) {
                                                  self.isAllRetrieved = YES;
                                              }
                                              [self.dataList addObjectsFromArray:[data objectForKey:K_BSDK_COMMENTLIST]];

                                              [self onDataLoadDone];
                                          }];
    }
    else if (self.controllerType == WeiboListViewControllerType_FORWARD_ME)
    {
        [[BSDKManager sharedManager] getAtWeiboListByUserId:userId
                                                   pageSize:AUTOLOAD_PAGE_SIZE
                                                  pageIndex:_currentPageIndex
                                            andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                                if ([[data objectForKey:K_BSDK_BLOGLIST] count] < AUTOLOAD_PAGE_SIZE) {
                                                    self.isAllRetrieved = YES;
                                                }
                                                [self.dataList addObjectsFromArray:[data objectForKey:K_BSDK_BLOGLIST]];

                                                [self onDataLoadDone];
                                            }];
    }
    else if (self.controllerType == WeiboListViewControllerType_MY_COLLECTION)
    {
        [[BSDKManager sharedManager] getFavWeiboListByUserId:userId
                                                   pageSize:AUTOLOAD_PAGE_SIZE
                                                  pageIndex:_currentPageIndex
                                            andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                                if ([[data objectForKey:K_BSDK_BLOGLIST] count] < AUTOLOAD_PAGE_SIZE) {
                                                    self.isAllRetrieved = YES;
                                                }
                                                [self.dataList addObjectsFromArray:[data objectForKey:K_BSDK_BLOGLIST]];
                                                
                                                [self onDataLoadDone];
                                            }];
    }
    else if (_controllerType == WeiboListViewControllerType_CATEGORY)
    {
        
        [[BSDKManager sharedManager] getWeiboListByClassId:[self.friendDictionary objectForKey:K_BSDK_UID]
                                                 pageSize:AUTOLOAD_PAGE_SIZE
                                                pageIndex:_currentPageIndex
                                          andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                              if ([[data objectForKey:K_BSDK_BLOGLIST] count] < AUTOLOAD_PAGE_SIZE) {
                                                  self.isAllRetrieved = YES;
                                              }
                                              [self.dataList addObjectsFromArray:[data objectForKey:K_BSDK_BLOGLIST]];
                                              
                                              [self onDataLoadDone];
                                          }];
    }
    else
    {
        [[BSDKManager sharedManager] getWeiboListByUserId:userId
                                                 pageSize:AUTOLOAD_PAGE_SIZE
                                                pageIndex:_currentPageIndex
                                          andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                              if ([[data objectForKey:K_BSDK_BLOGLIST] count] < AUTOLOAD_PAGE_SIZE) {
                                                  self.isAllRetrieved = YES;
                                              }
                                              [self.dataList addObjectsFromArray:[data objectForKey:K_BSDK_BLOGLIST]];

                                              [self onDataLoadDone];
                                          }];
    }
}

-(void)dealloc
{
    [super dealloc];
    [_tableView release];
    [_friendDictionary release];
    [_dataList release];
    [_footerButton release];
    [_footerView release];
    [_loadingActivityIndicator release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.friendDictionary = nil;
    self.dataList = nil;
    self.footerButton = nil;
    self.footerView = nil;
    self.loadingActivityIndicator = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDelegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeightofTableView:tableView ByWeiboData:[self.dataList objectAtIndex:[indexPath row]]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([indexPath row] == ([self.dataList count] - 1)) && !self.isAllRetrieved) {
        if (!self.isRefreshing) {
            [self refreshData];
        }
    }
}

#pragma mark UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    
    cell = [self getInitializedCellofTableView:tableView ByWeiboData:[self.dataList objectAtIndex:[indexPath row]]];
//    if  (self.controllerType == WeiboListViewControllerType_COMMENT_ME)
//    {
//        cell = [self getCellofTableView:tableView ByWeiboData:[self.dataList objectAtIndex:[indexPath row]]];
//    }
//    else
//    {
//        static NSString * atMeViewCellIdentifier = @"AtMeViewCell";
//        cell = [tableView dequeueReusableCellWithIdentifier:atMeViewCellIdentifier];
//        if(cell == nil)
//        {
//            cell = [[[NSBundle mainBundle] loadNibNamed:atMeViewCellIdentifier owner:self options:nil] objectAtIndex:0];
//        }
//        AtMeViewCell * atMeCell = (AtMeViewCell*)cell;
//        atMeCell.friendNameLabel.text = @"仁和春天光华店";
//        atMeCell.shopNameLabel.text = @"仁和春天";
//        atMeCell.brandLabel.text = @"好莱坞明星";
//    }

    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboDetailViewController *weiboDetailController = 
    [[WeiboDetailViewController alloc] init];

    weiboDetailController.weiboId = [self getCurrentBlogIdByData:[self.dataList objectAtIndex:[indexPath row]]];

    [self.navigationController pushViewController:weiboDetailController animated:YES];
    [weiboDetailController release];
}

-(NSString*)getCurrentBlogIdByData:(NSDictionary*)data
{
    NSString * blogId = [data objectForKey:K_BSDK_BLOGUID];
    if (blogId == nil) {
        blogId = [data objectForKey:K_BSDK_UID];
    }
    return blogId;
}

-(UITableViewCell*)getCellofTableView:(UITableView*)tableView ByWeiboData:(NSDictionary*)data
{
    UITableViewCell * cell = nil;
    NSString * viewCellIdentifier = nil;
    if  ([data objectForKey:K_BSDK_COMMENT_USER_ID] || ([data objectForKey:K_BSDK_RETWEET_STATUS] && ([[data objectForKey:K_BSDK_RETWEET_STATUS] count])))
    {
        viewCellIdentifier = @"CommentViewCell";
    }
    else
    {
        viewCellIdentifier = @"AtMeViewCell";
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:viewCellIdentifier];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:viewCellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    return cell;
}

-(UITableViewCell*)getInitializedCellofTableView:(UITableView*)tableView ByWeiboData:(NSDictionary*)data
{
    UITableViewCell * cell = [self getCellofTableView:tableView ByWeiboData:data];
    
    if ([cell isKindOfClass:[CommentViewCell class]]) {
        CommentViewCell * commentCell = (CommentViewCell*)cell;
        [commentCell setData:data];
    }
    else
    {
        AtMeViewCell * atMeCell = (AtMeViewCell*)cell;
        [atMeCell setData:data];
    }
    
    return cell;
}


-(CGFloat)getCellHeightofTableView:(UITableView*)tableView ByWeiboData:(NSDictionary*)data
{
    UITableViewCell * cell = [self getCellofTableView:tableView ByWeiboData:data];
    if ([cell isKindOfClass:[CommentViewCell class]]) {
        CommentViewCell * commentCell = (CommentViewCell*)cell;
        return [commentCell getCellHeightByData:data];
    }
    else
    {
        AtMeViewCell * atMeCell = (AtMeViewCell*)cell;
        return [atMeCell getCellHeight];
    }
}
@end
