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
#import "BSDKManager.h"
#import "ViewConstants.h"
#import "ViewHelper.h"

@interface FriendListViewController ()
@property (assign, nonatomic) NSInteger type;
@property (retain, nonatomic) NSDictionary * friendDictionary;
@property (retain, nonatomic) IBOutlet UITableView * commonTableView;
@property (retain, nonatomic) NSMutableArray * friendsList;

@end

@implementation FriendListViewController
@synthesize type = _type;
@synthesize commonTableView = _commonTableView;
@synthesize friendsList = _friendsList;
@synthesize friendDictionary = _friendDictionary;

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
                title = @"我的关注";
                self.friendDictionary = nil;
                break;
            case FriendListViewController_TYPE_MY_FANS:
                title = @"我的粉丝";
                self.friendDictionary = nil;
                break;
            case FriendListViewController_TYPE_MY_BLACKLIST:
                title = @"黑名单";
                self.friendDictionary = nil;
                break;
            case FriendListViewController_TYPE_FRIEND_FOLLOW:
                title = @"她的关注";
                self.friendDictionary = dictionary;
                break;
            case FriendListViewController_TYPE_FRIEND_FANS:
                title = @"她的粉丝";
                self.friendDictionary = dictionary;
                break;
        }
        [self.navigationItem setTitle:title];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    switch (_type) {
        case FriendListViewController_TYPE_MY_FOLLOW:
        {
            NSString* userId = [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:KEY_ACCOUNT_ID];
            [[BSDKManager sharedManager] getFollowList:userId
                                              pageSize:20
                                             pageIndex:1
                                       andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                           self.friendsList = [NSMutableArray arrayWithArray:[data valueForKey:@"UserList"]];
                                           [self.commonTableView reloadData];
                                       }];
            break;
        }
        case FriendListViewController_TYPE_FRIEND_FOLLOW:
        {
            NSString* userId = [self.friendDictionary valueForKey:KEY_ACCOUNT_USER_ID];
            [[BSDKManager sharedManager] getFollowList:userId
                                              pageSize:20
                                             pageIndex:1
                                       andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                           self.friendsList = [NSMutableArray arrayWithArray:[data valueForKey:@"UserList"]];
                                           [self.commonTableView reloadData];
                                       }];
            break;
        }
        case FriendListViewController_TYPE_MY_FANS:
        {
            NSInteger userId = [[[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:KEY_ACCOUNT_USER_ID] intValue];
            [[BSDKManager sharedManager] getFollowerList:userId
                                                pageSize:20
                                               pageIndex:1
                                         andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                             self.friendsList = [NSMutableArray arrayWithArray:[data valueForKey:@"UserList"]];
                                             [self.commonTableView reloadData];
                                         }];
            break;
        }
        case FriendListViewController_TYPE_FRIEND_FANS:
        {
            NSInteger userId = [[self.friendDictionary valueForKey:KEY_ACCOUNT_USER_ID] intValue];
            [[BSDKManager sharedManager] getFollowerList:userId
                                                pageSize:20
                                               pageIndex:1
                                         andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                                   self.friendsList = [NSMutableArray arrayWithArray:[data valueForKey:@"UserList"]];
                                                   [self.commonTableView reloadData];
                                               }];
            break;
        }
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.friendDictionary = nil;
}

- (void)dealloc
{
    [_friendDictionary release];
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


#pragma mark UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * friendListViewCellIdentifier = @"FriendListViewCell";
    UITableViewCell * cell = nil;
    NSInteger section = [indexPath section];
    cell = [tableView dequeueReusableCellWithIdentifier:friendListViewCellIdentifier];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:friendListViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        FriendListViewCell * friendListViewCell = (FriendListViewCell*)cell;
        BorderImageView * borderImageView = [[BorderImageView alloc] initWithFrame:friendListViewCell.avatarImageView.frame andImage:[UIImage imageNamed:[NSString  stringWithFormat:@"search_avatar_sample%d",section+1]]];
        [friendListViewCell.avatarImageView addSubview:borderImageView];
        [borderImageView release];
        NSDictionary * userDict = [self.friendsList objectAtIndex:section];
        friendListViewCell.friendNameLabel.text = [userDict valueForKey:KEY_ACCOUNT_USER_NAME];
        friendListViewCell.friendWeiboLabel.text = @"";
        NSString * buttonTitle = nil;
        NSInteger relation = [[[self.friendsList objectAtIndex:[indexPath section]] valueForKey:KEY_ACCOUNT_RELATION] intValue];
        switch (self.type) {
            case FriendListViewController_TYPE_MY_FOLLOW:
                buttonTitle = @"取消关注";
                break;
            case FriendListViewController_TYPE_MY_FANS:
                if(relation == FRIEND_RELATIONSHIP_INTER_FOLLOW)
                {
                    buttonTitle = @"取消关注";
                }
                else {
                    buttonTitle = @"关注";
                }
                break;
            case FriendListViewController_TYPE_MY_BLACKLIST:
                break;
            case FriendListViewController_TYPE_FRIEND_FOLLOW:
                break;
            case FriendListViewController_TYPE_FRIEND_FANS:
                break;
        }

        [friendListViewCell.actionButton setTitle:buttonTitle forState:UIControlStateNormal];
        friendListViewCell.actionButton.tag = [indexPath section];
        friendListViewCell.delegate = self;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.friendsList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendDetailViewController * friendDetailController = 
    [[FriendDetailViewController alloc] initWithDictionary:[self.friendsList objectAtIndex:[indexPath section]]];
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
