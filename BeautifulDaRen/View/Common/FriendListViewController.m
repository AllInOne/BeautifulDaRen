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

@property (retain, nonatomic) IBOutlet UITableView * commonTableView;
@property (retain, nonatomic) NSMutableArray * friendsList;

@end

@implementation FriendListViewController
@synthesize type = _type;
@synthesize commonTableView = _commonTableView;
@synthesize friendsList = _friendsList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger)type{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString* title = nil;
        _type = type;
        switch (_type) {
            case FriendListViewController_TYPE_MY_FOLLOW:
                title = @"我的关注";
                break;
            case FriendListViewController_TYPE_MY_FANS:
                title = @"我的粉丝";
                break;
            case FriendListViewController_TYPE_MY_BLACKLIST:
                title = @"黑名单";
                break;
            case FriendListViewController_TYPE_FRIEND_FOLLOW:
                title = @"她的关注";
                break;
            case FriendListViewController_TYPE_FRIEND_FANS:
                title = @"她的粉丝";
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
    NSString * userName = [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:USERDEFAULT_ACCOUNT_USERNAME];
    switch (_type) {
        case FriendListViewController_TYPE_MY_FOLLOW:
        {
            [[BSDKManager sharedManager] getFollowList:userName
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
            [[BSDKManager sharedManager] getFollowerList:userName
                                                pageSize:20
                                               pageIndex:1
                                         andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                                   self.friendsList = [NSMutableArray arrayWithArray:[data valueForKey:@"UserList"]];
                                                   [self.commonTableView reloadData];
                                               }];
            break;
        }
        case FriendListViewController_TYPE_MY_BLACKLIST:
            break;
        case FriendListViewController_TYPE_FRIEND_FOLLOW:
            break;
        case FriendListViewController_TYPE_FRIEND_FANS:
            break;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
        friendListViewCell.friendWeiboLabel.text = @"我今天在天府广场附近买了一款很好看的衣服。";
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
    [[FriendDetailViewController alloc] init];
    [self.navigationController pushViewController:friendDetailController animated:YES];
    [friendDetailController release];
}

#pragma mark ButtonPressDelegate
-(void)didButtonPressed:(UIButton *)button inView:(UIView *)view
{
    NSString * userName = [[self.friendsList objectAtIndex:button.tag] valueForKey:KEY_ACCOUNT_USER_NAME];
    [[BSDKManager sharedManager] unFollowUser:userName
                              andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                  if(status == AIO_STATUS_SUCCESS)
                                  {
                                      [self.friendsList removeObjectAtIndex:button.tag];
                                      [self.commonTableView reloadData];
                                  }
                              }];
}

@end
