#import "WeiboListViewController.h"
#import "AtMeViewCell.h"
#import "WeiboDetailViewController.h"
#import "ViewHelper.h"
#import "BSDKManager.h"
#import "ViewConstants.h"
#import "CommentViewCell.h"

@interface WeiboListViewController()

@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) NSDictionary * friendDictionary;
@property (assign, nonatomic) NSInteger controllerType;

@property (retain, nonatomic) NSArray * dataList;
@end

@implementation WeiboListViewController
@synthesize tableView = _tableView;
@synthesize controllerType = _controllerType;
@synthesize friendDictionary = _friendDictionary;
@synthesize dataList = _dataList;

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
    [ViewHelper showSimpleMessage:@"refresh button click" withTitle:nil withButtonText:@"ok"];
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
    
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center = CGPointMake(SCREEN_WIDTH/2, 20);
    [activityIndicator startAnimating];
    
    [self.view addSubview:activityIndicator];
    
    [self.tableView removeFromSuperview];
    
    NSString * userId = self.friendDictionary ? [self.friendDictionary valueForKey:KEY_ACCOUNT_ID] : [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:KEY_ACCOUNT_ID];
    
    if (self.controllerType == WeiboListViewControllerType_COMMENT_ME) {
        [[BSDKManager sharedManager] getCommentListOfUser:userId
                                                   pageSize:20
                                                  pageIndex:1
                                            andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                                [activityIndicator stopAnimating];
                                                [activityIndicator removeFromSuperview];
                                                [activityIndicator release];
                                                
                                                [self.view addSubview:self.tableView];
                                                [self.tableView reloadData];
                                            }];
    }
    else
    {
        [[BSDKManager sharedManager] getWeiboListByUsername:userId
                                                   pageSize:20
                                                  pageIndex:1
                                            andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                                [activityIndicator stopAnimating];
                                                [activityIndicator release];
                                                
                                                [self.view addSubview:self.tableView];
                                                [self.tableView reloadData];
                                            }];
    }

}

-(void)dealloc
{
    [super dealloc];
    [_tableView release];
    [_friendDictionary release];
    [_dataList release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.friendDictionary = nil;
    self.dataList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDelegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger index = [indexPath row] % 2;
//    return  (index == 0) ? 130 : 200;
    return 130;
}

#pragma mark UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    if  (self.controllerType == WeiboListViewControllerType_COMMENT_ME)
    {
        static NSString * commentViewCellIdentifier = @"CommentViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:commentViewCellIdentifier];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:commentViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
//        CommentViewCell * atMeCell = (CommentViewCell*)cell;
    }
    else
    {
        static NSString * atMeViewCellIdentifier = @"AtMeViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:atMeViewCellIdentifier];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:atMeViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        AtMeViewCell * atMeCell = (AtMeViewCell*)cell;
        atMeCell.friendNameLabel.text = @"仁和春天光华店";
        atMeCell.shopNameLabel.text = @"仁和春天";
        atMeCell.brandLabel.text = @"好莱坞明星";
    }

    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboDetailViewController *weiboDetailController = 
    [[WeiboDetailViewController alloc] init];
    [self.navigationController pushViewController:weiboDetailController animated:YES];
    [weiboDetailController release];
}
@end
