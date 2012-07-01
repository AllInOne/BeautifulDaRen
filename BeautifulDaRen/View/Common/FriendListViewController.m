//
//  CommonViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 6/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendListViewCell.h"
#import "FriendDetailViewController.h"
#import "BorderImageView.h"
#import "BSDKDefines.h"
#import "BSDKManager.h"
#import "ViewConstants.h"
#import "ViewHelper.h"

#define FRIEND_PAGE_SIZE    (5)

@interface FriendListViewController ()
@property (assign, nonatomic) NSInteger type;
@property (retain, nonatomic) NSDictionary * userDataDictionary;
@property (retain, nonatomic) IBOutlet UITableView * commonTableView;
@property (retain, nonatomic) NSMutableArray * friendsList;

@property (assign, nonatomic) NSInteger currentPageIndex;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isAllRetrieved;

-(void)refreshData;
-(void)onDataLoadDone;
-(NSString*)getRelationButtonTitleOfUser:(NSDictionary*)userInfo;
-(NSDictionary*)extractFriendDictionary:(NSDictionary*)FriendRawDict;
@end

@implementation FriendListViewController
@synthesize type = _type;
@synthesize commonTableView = _commonTableView;
@synthesize friendsList = _friendsList;
@synthesize userDataDictionary = _userDataDictionary;

@synthesize currentPageIndex = _currentPageIndex;
@synthesize isRefreshing = _isRefreshing;
@synthesize isAllRetrieved = _isAllRetrieved;

@synthesize footerView = _footerView;
@synthesize footerButton = _footerButton;
@synthesize loadingActivityIndicator = _loadingActivityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                 type:(NSInteger)type
           dictionary:(NSDictionary*)dictionary
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString* title = nil;
        _type = type;
        switch (_type) {
            case FriendListViewController_TYPE_MY_FOLLOW:
                title = NSLocalizedString(@"my_follows", @"my_follows");
                self.userDataDictionary = nil;
                break;
            case FriendListViewController_TYPE_MY_FANS:
                title = NSLocalizedString(@"my_fans", @"my_fans");
                self.userDataDictionary = nil;
                break;
            case FriendListViewController_TYPE_MY_BLACKLIST:
                title = NSLocalizedString(@"black_list", @"black_list");
                self.userDataDictionary = nil;
                break;
            case FriendListViewController_TYPE_FRIEND_FOLLOW:
                title = NSLocalizedString(@"her_follows", @"her_follows");
                self.userDataDictionary = dictionary;
                break;
            case FriendListViewController_TYPE_FRIEND_FANS:
                title = NSLocalizedString(@"her_fans", @"her_fans");
                self.userDataDictionary = dictionary;
                break;
            case FriendListViewController_TYPE_FAV_ONE_BLOG:
                title = NSLocalizedString(@"fav_list", @"fav_list");
                self.userDataDictionary = dictionary;
                break;
        }
        [self.navigationItem setTitle:title];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentPageIndex = 1;
    self.commonTableView.tableFooterView = self.footerView;
    self.friendsList = [NSMutableArray arrayWithCapacity:50];
    
    [self refreshData];
}

- (void)onDataLoadDone
{
    [self.loadingActivityIndicator stopAnimating];
    
    self.isRefreshing = NO;
    self.currentPageIndex++;
    
    if ((self.friendsList == nil) || ([self.friendsList count] == 0)) {
        [self.footerButton setTitle:NSLocalizedString(@"no_message", @"no_message") forState:UIControlStateNormal];
        [self.loadingActivityIndicator setHidden:YES];
    }
    else
    {
        [self.footerView setHidden:YES];
        [self.commonTableView reloadData];
    }
}

-(void)refreshData
{
    [self.footerView setHidden:NO];
    [self.loadingActivityIndicator startAnimating];
    [self.footerButton setTitle:NSLocalizedString(@"loading_more", @"loading_more") forState:UIControlStateNormal];
    
    self.isRefreshing = YES;

    processDoneWithDictBlock doneBlock = ^(AIO_STATUS status, NSDictionary * data){
        NSArray * userList = [NSMutableArray arrayWithArray:[data valueForKey:K_BSDK_USERLIST]];
        [self.friendsList addObjectsFromArray:userList];
        if ([userList count] < FRIEND_PAGE_SIZE) {
            self.isAllRetrieved = YES;
        }
        [self onDataLoadDone];
    };
    
    switch (_type) {
        case FriendListViewController_TYPE_MY_FOLLOW:
        {
            NSString* userId = [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:KEY_ACCOUNT_ID];
            [[BSDKManager sharedManager] getFollowList:userId
                                              pageSize:FRIEND_PAGE_SIZE
                                             pageIndex:self.currentPageIndex
                                       andDoneCallback:doneBlock];
            break;
        }
        case FriendListViewController_TYPE_FRIEND_FOLLOW:
        {
            NSString* userId = [self.userDataDictionary valueForKey:K_BSDK_UID];
            [[BSDKManager sharedManager] getFollowList:userId
                                              pageSize:FRIEND_PAGE_SIZE
                                             pageIndex:self.currentPageIndex
                                       andDoneCallback:doneBlock];
            break;
        }
        case FriendListViewController_TYPE_MY_FANS:
        {
            NSInteger userId = [[[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:KEY_ACCOUNT_USER_ID] intValue];
            [[BSDKManager sharedManager] getFollowerList:userId
                                                pageSize:FRIEND_PAGE_SIZE
                                               pageIndex:self.currentPageIndex
                                         andDoneCallback:doneBlock];
            break;
        }
        case FriendListViewController_TYPE_FRIEND_FANS:
        {
            NSInteger userId = [[self.userDataDictionary valueForKey:K_BSDK_UID] intValue];
            [[BSDKManager sharedManager] getFollowerList:userId
                                                pageSize:FRIEND_PAGE_SIZE
                                               pageIndex:self.currentPageIndex
                                         andDoneCallback:doneBlock];
            break;
        }
        case FriendListViewController_TYPE_FAV_ONE_BLOG:
        {
            NSString * blogId = [self.userDataDictionary valueForKey:K_BSDK_UID];
            [[BSDKManager sharedManager] getFavUsersByBlogId:blogId
                                                pageSize:FRIEND_PAGE_SIZE
                                               pageIndex:self.currentPageIndex
                                         andDoneCallback:doneBlock];
            break;
        }
    }
}

- (void) onRefreshButtonClicked
{
    self.currentPageIndex = 1;
    self.isAllRetrieved = NO;
    [self.friendsList removeAllObjects];
    [self.commonTableView reloadData];
    [self refreshData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.footerButton = nil;
    self.loadingActivityIndicator = nil;
    self.footerView = nil;
}

- (void)dealloc
{
    [_userDataDictionary release];
    [_footerButton release];
    [_footerView release];
    [_loadingActivityIndicator release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)onBackButtonClicked {
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(NSString*)getRelationButtonTitleOfUser:(NSDictionary*)userInfo
{
    NSInteger relation = [[userInfo valueForKey:KEY_ACCOUNT_RELATION] intValue];
    NSString * title = nil;
    
    if (![ViewHelper isSelf:[userInfo objectForKey:K_BSDK_USERID]]) 
    {
        switch (relation) {
            case FRIEND_RELATIONSHIP_INTER_FOLLOW:
                title = NSLocalizedString(@"unfollow", @"unfollow");
                break;
            case FRIEND_RELATIONSHIP_MY_FOLLOW:
                title = NSLocalizedString(@"unfollow", @"unfollow");
                break;
            case FRIEND_RELATIONSHIP_MY_FANS:
                title = NSLocalizedString(@"remove_fan", @"remove_fan");
                break;
            case FRIEND_RELATIONSHIP_BALCK_LIST:
            default:
                title = NSLocalizedString(@"follow", @"follow");
                break;
        }
    }
    return title;
}

-(NSDictionary*)extractFriendDictionary:(NSDictionary*)FriendRawDict
{
    switch (_type) {
        case FriendListViewController_TYPE_MY_FANS:
        case FriendListViewController_TYPE_FRIEND_FANS:
        {
            return [FriendRawDict objectForKey:K_BSDK_FANSUSERINFO];
            break;
        }
        case FriendListViewController_TYPE_MY_FOLLOW:
        {
            return [FriendRawDict objectForKey:K_BSDK_ATTENTIONUSERINFO];
            break;
        }            
        case FriendListViewController_TYPE_FRIEND_FOLLOW:
        case FriendListViewController_TYPE_FAV_ONE_BLOG:
        default:
        {
            return FriendRawDict;
            break;
        }
    }
}
#pragma mark UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * friendListViewCellIdentifier = @"FriendListViewCell";
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:friendListViewCellIdentifier];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:friendListViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        FriendListViewCell * friendListViewCell = (FriendListViewCell*)cell;
        BorderImageView * borderImageView = [[BorderImageView alloc] initWithFrame:friendListViewCell.avatarImageView.frame andImage:[UIImage imageNamed:[NSString  stringWithFormat:@"search_avatar_sample%d",[indexPath row]+1]]];
        [friendListViewCell.avatarImageView addSubview:borderImageView];
        [borderImageView release];
        
        NSDictionary * userDict = [self extractFriendDictionary:[self.friendsList objectAtIndex:[indexPath row]]];
        friendListViewCell.friendNameLabel.text = [userDict valueForKey:KEY_ACCOUNT_USER_NAME];
        friendListViewCell.friendWeiboLabel.text = @"";
        
        NSString * buttonTitle = [self getRelationButtonTitleOfUser:userDict];
        if (buttonTitle) {
            [friendListViewCell.actionButton setTitle:buttonTitle forState:UIControlStateNormal];
            friendListViewCell.actionButton.tag = [indexPath row];
        }
        else
        {
            [friendListViewCell.actionButton setHidden:YES];
        }

        friendListViewCell.delegate = self;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([indexPath row] == ([self.friendsList count] - 1)) && !self.isAllRetrieved) {
        if (!self.isRefreshing) {
            [self refreshData];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendsList count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendDetailViewController * friendDetailController = 
    [[FriendDetailViewController alloc] initWithDictionary:[self extractFriendDictionary:[self.friendsList objectAtIndex:[indexPath row]]]];
    [self.navigationController pushViewController:friendDetailController animated:YES];
    [friendDetailController release];
}

#pragma mark ButtonPressDelegate
-(void)didButtonPressed:(UIButton *)button inView:(UIView *)view
{
    BOOL isShouldFollow = YES;
    NSDictionary * dict = [self.friendsList objectAtIndex:button.tag];
    NSInteger relation = [[dict valueForKey:KEY_ACCOUNT_RELATION] intValue];
    switch (self.type) {
        case FriendListViewController_TYPE_MY_FOLLOW:
        {
            isShouldFollow = NO;
            break;
        }
        case FriendListViewController_TYPE_MY_FANS:
        {
            isShouldFollow = (relation == FRIEND_RELATIONSHIP_INTER_FOLLOW) ? NO : YES;
            break;
        }
        case FriendListViewController_TYPE_MY_BLACKLIST:
            break;
        case FriendListViewController_TYPE_FRIEND_FOLLOW:
            break;
        case FriendListViewController_TYPE_FRIEND_FANS:
            break;
    }
    
    NSInteger userId = [[dict valueForKey:KEY_ACCOUNT_USER_ID] intValue];
    if (!isShouldFollow)
    {
        [[BSDKManager sharedManager] unFollowUser:userId
                                  andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                      if(status == AIO_STATUS_SUCCESS)
                                      {
                                          [self.friendsList removeObjectAtIndex:button.tag];
                                          [self.commonTableView reloadData];
                                      }
                                  }];
    }
    else
    {
        [[BSDKManager sharedManager] followUser:userId
                                andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                    
                                }];
    }
}

@end
