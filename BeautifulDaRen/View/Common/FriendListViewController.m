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
#import "UIImageView+WebCache.h"
#import "iToast.h"

#define FRIEND_PAGE_SIZE    (20)

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
-(NSString*)getFriendInforKey;
- (void)setRelation:(NSString*)relation ofFriendIndex:(NSInteger)index;
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
                if ([[dictionary objectForKey:K_BSDK_GENDER] isEqual:K_BSDK_GENDER_FEMALE]) {
                    title = NSLocalizedString(@"her_follows", @"her_follows");
                }
                else
                {
                    title = NSLocalizedString(@"his_follows", @"his_follows");
                }
                self.userDataDictionary = dictionary;
                break;
            case FriendListViewController_TYPE_FRIEND_FANS:
                if ([[dictionary objectForKey:K_BSDK_GENDER] isEqual:K_BSDK_GENDER_FEMALE]) {
                    title = NSLocalizedString(@"her_fans", @"her_fans");
                }
                else
                {
                    title = NSLocalizedString(@"his_fans", @"his_fans");
                }
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
        if (K_BSDK_IS_RESPONSE_OK(data)) {
            NSArray * userList = [NSMutableArray arrayWithArray:[data valueForKey:K_BSDK_USERLIST]];
            [self.friendsList addObjectsFromArray:userList];
            if ([userList count] < FRIEND_PAGE_SIZE) {
                self.isAllRetrieved = YES;
            }
        }
        else
        {
            self.isAllRetrieved = YES;
            [[iToast makeText:NSLocalizedString(@"server_request_error", @"server_request_error")] show];
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
            NSInteger userId = [[[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:K_BSDK_UID] intValue];
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
    NSString * relation = [userInfo valueForKey:K_BSDK_RELATIONSHIP];
    NSString * title = nil;
    
    if (![ViewHelper isSelf:[userInfo objectForKey:K_BSDK_USERID]]) 
    {
        if ([relation isEqualToString:K_BSDK_RELATIONSHIP_INTER_FOLLOW])
        {
            if (self.type == FriendListViewController_TYPE_MY_FANS) {
                title = NSLocalizedString(@"remove_fan", @"remove_fan");
            }
            else
            {
                title = NSLocalizedString(@"unfollow", @"unfollow");
            }
        }
        else if ([relation isEqualToString:K_BSDK_RELATIONSHIP_MY_FOLLOW])
        {
            title = NSLocalizedString(@"unfollow", @"unfollow");
        }
        else if ([relation isEqualToString:K_BSDK_RELATIONSHIP_MY_FANS])
        {
            title = NSLocalizedString(@"remove_fan", @"remove_fan");
        }
        else if ([relation isEqualToString:K_BSDK_RELATIONSHIP_BLACK_LIST] || [relation isEqualToString:K_BSDK_RELATIONSHIP_NONE])
        {
            title = NSLocalizedString(@"follow", @"follow");
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
        case FriendListViewController_TYPE_FRIEND_FOLLOW:
        case FriendListViewController_TYPE_MY_FOLLOW:
        {
            return [FriendRawDict objectForKey:K_BSDK_ATTENTIONUSERINFO];
            break;
        }            
        case FriendListViewController_TYPE_FAV_ONE_BLOG:
        default:
        {
            return FriendRawDict;
            break;
        }
    }
}

-(NSString*)getFriendInforKey
{
    switch (_type) {
        case FriendListViewController_TYPE_MY_FANS:
        case FriendListViewController_TYPE_FRIEND_FANS:
        {
            return K_BSDK_FANSUSERINFO;
            break;
        }
        case FriendListViewController_TYPE_FRIEND_FOLLOW:
        case FriendListViewController_TYPE_MY_FOLLOW:
        {
            return K_BSDK_ATTENTIONUSERINFO;
            break;
        }            
        case FriendListViewController_TYPE_FAV_ONE_BLOG:
        default:
        {
            return nil;
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
        
        NSDictionary * userDict = [self extractFriendDictionary:[self.friendsList objectAtIndex:[indexPath row]]];
        if (!userDict || ![userDict isKindOfClass:[NSDictionary class]] ||[userDict count] == 0) {
            [[iToast makeText:NSLocalizedString(@"server_data_error", @"server_data_error")] show];
            return cell;
        }
        
        NSString * avatarUrlString = [userDict objectForKey:K_BSDK_PICTURE_65];
        BorderImageView * borderImageView = nil;
        if (avatarUrlString && [avatarUrlString length]) {
            UIImageView * avatarImageView = [[UIImageView alloc] init];
            [avatarImageView setImageWithURL:[NSURL URLWithString:avatarUrlString]];
            borderImageView = [[BorderImageView alloc] initWithFrame:friendListViewCell.avatarImageView.frame andView:avatarImageView needNotification:NO];
            [avatarImageView release];
        }
        else
        {
            borderImageView = [[BorderImageView alloc] initWithFrame:friendListViewCell.avatarImageView.frame andImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:userDict]]];
        }
         
        [friendListViewCell.avatarImageView addSubview:borderImageView];
        [borderImageView release];
        
        NSString * isVerify = [userDict objectForKey:K_BSDK_ISVERIFY];
        if (isVerify && [isVerify isEqual:@"1"]) {
            [friendListViewCell.vMarkImageView setImage:[UIImage imageNamed:@"v_mark_big"]];
            [friendListViewCell.vMarkImageView setHidden:NO];
        }
        else
        {
            [friendListViewCell.vMarkImageView setHidden:YES];
        }

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

//        friendListViewCell.delegate = self;
        [friendListViewCell.actionButton addTarget:self action:@selector(didButtonPressed:inView:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    NSDictionary * dict = [self extractFriendDictionary:[self.friendsList objectAtIndex:button.tag]];
    NSInteger userId = [[dict valueForKey:K_BSDK_UID] intValue];
    NSString * relation = [dict valueForKey:K_BSDK_RELATIONSHIP];
    switch (self.type) {
        case FriendListViewController_TYPE_MY_FOLLOW:
        {
            isShouldFollow = NO;
            break;
        }
        case FriendListViewController_TYPE_MY_FANS:
        {
            [[BSDKManager sharedManager] removeFan:[dict valueForKey:K_BSDK_UID] andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                if(K_BSDK_IS_RESPONSE_OK(data))
                {
                    [_friendsList removeObjectAtIndex:button.tag];
                    
                    [self.commonTableView reloadData];
                }
                else
                {
                    [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
                }
            }];
            return;
        }
        case FriendListViewController_TYPE_MY_BLACKLIST:
        case FriendListViewController_TYPE_FRIEND_FOLLOW:
        case FriendListViewController_TYPE_FRIEND_FANS:
        case FriendListViewController_TYPE_FAV_ONE_BLOG:
            isShouldFollow = ([relation isEqualToString:K_BSDK_RELATIONSHIP_MY_FOLLOW] ||[relation isEqualToString:K_BSDK_RELATIONSHIP_INTER_FOLLOW]) ? NO : YES;
            break;
    }

    [button setEnabled:NO];
    
    if (NO == isShouldFollow)
    {
        [[BSDKManager sharedManager] unFollowUser:userId
                                  andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                      if(K_BSDK_IS_RESPONSE_OK(data))
                                      {
                                          [self setRelation:K_BSDK_RELATIONSHIP_NONE ofFriendIndex:button.tag];
                                          
                                          [self.commonTableView reloadData];
                                      }
                                      else
                                      {
                                          [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
                                      }
                                      
                                      [button setEnabled:YES];
                                  }];
    }
    else
    {
        [[BSDKManager sharedManager] followUser:userId
                                andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                    if (K_BSDK_IS_RESPONSE_OK(data)) {
                                        [self setRelation:K_BSDK_RELATIONSHIP_MY_FOLLOW ofFriendIndex:button.tag];
                                        [self.commonTableView reloadData];
                                    }
                                    else
                                    {
                                        [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
                                    }
                                    [button setEnabled:YES];
                                }];
    }
}

- (void)setRelation:(NSString*)relation ofFriendIndex:(NSInteger)index
{
    if (_type == FriendListViewController_TYPE_MY_FOLLOW) {
        [_friendsList removeObjectAtIndex:index];
    }
    else
    {
        NSString * friendInfoKey = [self getFriendInforKey];
        NSMutableDictionary * rawInfo = [_friendsList objectAtIndex:index];
        if (friendInfoKey) {
            NSMutableDictionary * info = [NSMutableDictionary dictionaryWithDictionary:[self extractFriendDictionary:rawInfo]];
            
            [info setObject:relation forKey:K_BSDK_RELATIONSHIP];
            
            [rawInfo setObject:info forKey:friendInfoKey];

        }
        else
        {
            [rawInfo setObject:relation forKey:K_BSDK_RELATIONSHIP];
        }
        [_friendsList replaceObjectAtIndex:index withObject:rawInfo];
    }
}
@end
