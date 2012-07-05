//
//  SecondViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MineViewController.h"
#import "MineEditingViewController.h"
#import "MyInfoTopViewCell.h"
#import "GridViewCell.h"
#import "ButtonViewCell.h"
#import "ViewConstants.h"
#import "DataManager.h"
#import "SinaSDKManager.h"
#import "WeiboListViewController.h"
#import "ViewHelper.h"
#import "PrivateLetterViewController.h"
#import "FriendListViewController.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"
#import "BSDKManager.h"
#import "iToast.h"
#import "BSDKDefines.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"

@interface MineViewController()

@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) IBOutlet UIButton * followButton;
@property (retain, nonatomic) IBOutlet UIButton * fansButton;
@property (retain, nonatomic) IBOutlet UIButton * collectionButton;
@property (retain, nonatomic) IBOutlet UIButton * blackListButton;
@property (retain, nonatomic) IBOutlet UIButton * buyedButton;
@property (retain, nonatomic) IBOutlet UIButton * mypublishButton;
@property (retain, nonatomic) IBOutlet UIButton * topicButton;
@property (retain, nonatomic) IBOutlet UIButton * editButton;

-(void)refreshUserInfo;

@end

@implementation MineViewController
@synthesize tableView = _tableView;
@synthesize followButton = _followButton;
@synthesize fansButton = _fansButton;
@synthesize collectionButton = _collectionButton;
@synthesize blackListButton = _blackListButton;
@synthesize buyedButton = _buyedButton;
@synthesize topicButton = _topicButton;
@synthesize editButton = _editButton;
@synthesize mypublishButton = _mypublishButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)dealloc
{
    [_tableView release];
    [_followButton release];
    [_fansButton release];
    [_collectionButton release];
    [_blackListButton release];
    [_buyedButton release];
    [_topicButton release];
    [_editButton release];
    [_mypublishButton release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"title_mine", @"title_mine")];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClick) title:NSLocalizedString(@"refresh", @"refresh")]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.followButton = nil;
    self.fansButton = nil;
    self.collectionButton = nil;
    self.blackListButton = nil;
    self.buyedButton = nil;
    self.topicButton = nil;
    self.editButton = nil;
    self.mypublishButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshUserInfo];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) onRefreshButtonClick
{
    [self refreshUserInfo];
}

#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * myInfoTopViewIdentifier = @"MyInfoTopViewCell";
    static NSString * gridViewIndentifier = @"GridViewCell";
    static NSString * buttonViewCellIdentifier = @"ButtonViewCell";
    UITableViewCell * cell = nil;
    NSInteger section = [indexPath section];
    if (section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:myInfoTopViewIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:myInfoTopViewIdentifier owner:self options:nil] objectAtIndex:0];
        }
        
        NSDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
        NSString * avatarUrl = [userDict objectForKey:K_BSDK_PICTURE_65];
        if (avatarUrl && [avatarUrl length]) {
            [((MyInfoTopViewCell*)cell).avatarImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:userDict]]];
        }
        else
        {
            ((MyInfoTopViewCell*)cell).avatarImageView.image = [UIImage imageNamed:@"avatar_big"];
        }

        ((MyInfoTopViewCell*)cell).levelLabel.text = [NSString stringWithFormat:@"LV%d",
                                                      [[userDict valueForKey:KEY_ACCOUNT_LEVEL] intValue]];
        ((MyInfoTopViewCell*)cell).levelLabelTitle.text = [NSString stringWithFormat:@"%@%d",
                                                           NSLocalizedString(@"point", @"point"),
                                                           [[userDict valueForKey:KEY_ACCOUNT_POINT] intValue]];
        ((MyInfoTopViewCell*)cell).beautifulIdLabel.text = [userDict valueForKey:KEY_ACCOUNT_USER_NAME];
        if  ([[userDict valueForKey:KEY_ACCOUNT_GENDER] isEqual:K_BSDK_GENDER_MALE])
        {
            ((MyInfoTopViewCell*)cell).rightImageView.image = [UIImage imageNamed:@"gender_male"];
        }
        else
        {
            ((MyInfoTopViewCell*)cell).rightImageView.image = [UIImage imageNamed:@"gender_female"];
        }

        ((MyInfoTopViewCell*)cell).editImageView.image = [UIImage imageNamed:@"my_edit"];
        ((MyInfoTopViewCell*)cell).cityLabel.text = [NSString stringWithFormat:@"%@ %@", [userDict valueForKey:KEY_ACCOUNT_CITY], [userDict valueForKey:KEY_ACCOUNT_ADDRESS]];
        
        [((MyInfoTopViewCell*)cell).editButton addTarget:self action:@selector(onEditPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:gridViewIndentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:gridViewIndentifier owner:self options:nil] objectAtIndex:1];
        }
        ((GridViewCell*)cell).delegate = self;
        
        NSDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
        NSMutableAttributedString * attrStr = nil;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"follow", @"") detail:[NSString stringWithFormat:@"(%d)", [[userDict valueForKey:KEY_ACCOUNT_FOLLOW_COUNT] intValue]]];
        ((GridViewCell*)cell).firstLabel.attributedText = attrStr;
        ((GridViewCell*)cell).firstLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"fans", @"") detail:[NSString stringWithFormat:@"(%d)", [[userDict valueForKey:KEY_ACCOUNT_FANS_COUNT] intValue]]];
        ((GridViewCell*)cell).secondLabel.attributedText = attrStr;
        ((GridViewCell*)cell).secondLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"collection", @"") detail:[NSString stringWithFormat:@"(%d)", [[userDict valueForKey:KEY_ACCOUNT_FAVORITE_COUNT] intValue]]];
        ((GridViewCell*)cell).thirdLabel.attributedText = attrStr;
        ((GridViewCell*)cell).thirdLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"my_publish", @"") detail:[NSString stringWithFormat:@"(%d)", [[userDict valueForKey:KEY_ACCOUNT_BLOG_COUNT] intValue]]];
        ((GridViewCell*)cell).fourthLabel.attributedText = attrStr;
        ((GridViewCell*)cell).fourthLabel.textAlignment = UITextAlignmentCenter;

        _followButton = ((GridViewCell*)cell).firstButton;
        _fansButton = ((GridViewCell*)cell).secondButton;
        _collectionButton = ((GridViewCell*)cell).thirdButton;
        _mypublishButton = ((GridViewCell*)cell).fourthButton;
    }
    else if (section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        switch ([indexPath row]) {
            case 0:
            {
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"at_me", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"my_at"];
                break;
            }
            case 1:
            {
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"comment_me", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"comment_icon"];
                break;
            }
        }
    }
    else if (section == 3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"switch_account", @"");
        ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"logout"];
    }
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
            numberOfRows = 1;
            break;
        case 1:
            numberOfRows = 1;
            break;
        case 2:
            numberOfRows = 2;
            break;
        case 3:
            numberOfRows = 1;
            break;
    }
    return numberOfRows;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        height = 72.0f;
    }
    else if (section == 1)
    {
        height = 71.0f;
    }
    else if (section == 2)
    {
        height = 40.0f;
    }
    else if (section == 3)
    {
        height = 40.0f;
    }
    return height;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    // 我发表的 and 私信
    if(section == 2)
    {
        switch ([indexPath row]) {
            case 0:
            {
                WeiboListViewController * forwadMeViewController = [[WeiboListViewController alloc]
                                                                    initWithNibName:@"WeiboListViewController"
                                                                    bundle:nil
                                                                    type:WeiboListViewControllerType_FORWARD_ME
                                                                    dictionary:nil];
                
                UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: forwadMeViewController];
                
                [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
                
                [navController release];
                [forwadMeViewController release];
                break;
            }
            case 1:
            {
                WeiboListViewController * commentMeViewController = [[WeiboListViewController alloc]
                                                                     initWithNibName:@"WeiboListViewController"
                                                                     bundle:nil
                                                                     type:WeiboListViewControllerType_COMMENT_ME
                                                                     dictionary:nil];
                
                UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: commentMeViewController];
                
                [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
                [navController release];
                [commentMeViewController release];
                break;
            }
        }
    }
    else if(section == 3)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_SHOWWAITOVERLAY object:self];
        [[BSDKManager sharedManager] logoutWithDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
            [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_HIDEWAITOVERLAY object:self];
            if(status == AIO_STATUS_SUCCESS)
            {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:USERDEFAULT_IS_AUTO_LOGIN];
                [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_LOGIN_SUCCESS object:self userInfo:data];
                
                LoginViewController * loginContorller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                [self.navigationController pushViewController:loginContorller animated:YES];
                [loginContorller release];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
            }
            else {
                [[iToast makeText:@"账户退出失败!"] show];
            }
            if ([[SinaSDKManager sharedManager] isLogin]) {
                [[SinaSDKManager sharedManager] logout];
            }
        }];

    }
}

#pragma mark ButtonPressDelegate
- (void) didButtonPressed:(UIButton*)button inView:(UIView *)view
{
    UIViewController * viewController = nil;
    if(button == _followButton)
    {
        viewController = [[FriendListViewController alloc]
                          initWithNibName:@"FriendListViewController"
                          bundle:nil
                          type:FriendListViewController_TYPE_MY_FOLLOW
                          dictionary:nil];
    }
    else if (button == _fansButton)
    {
        viewController = [[FriendListViewController alloc]
                          initWithNibName:@"FriendListViewController"
                          bundle:nil
                          type:FriendListViewController_TYPE_MY_FANS
                          dictionary:nil];
    }
    else if (button == _collectionButton)
    {
        viewController = [[WeiboListViewController alloc]
                          initWithNibName:@"WeiboListViewController"
                          bundle:nil
                          type:WeiboListViewControllerType_MY_COLLECTION
                          dictionary:nil];
    }
    else if (button == _blackListButton)
    {
        viewController = [[FriendListViewController alloc]
                          initWithNibName:@"FriendListViewController"
                          bundle:nil
                          type:FriendListViewController_TYPE_MY_BLACKLIST
                          dictionary:nil];
    }
    else if(button == _buyedButton)
    {
        viewController = [[WeiboListViewController alloc]
                          initWithNibName:@"WeiboListViewController"
                          bundle:nil
                          type:WeiboListViewControllerType_MY_BUYED
                          dictionary:nil];
    }
    else if(button == _topicButton)
    {
        viewController = [[WeiboListViewController alloc]
                          initWithNibName:@"WeiboListViewController"
                          bundle:nil
                          type:WeiboListViewControllerType_MY_BUYED
                          dictionary:nil];
    }
//    else if(button == _editButton)
//    {
//        viewController = [[MineEditingViewController alloc]
//                          initWithNibName:@"MineEditingViewController"
//                          bundle:nil];
//        
//    }
    else if(button == _mypublishButton)
    {
        viewController = [[WeiboListViewController alloc]
                          initWithNibName:@"WeiboListViewController"
                          bundle:nil
                          type:WeiboListViewControllerType_MY_PUBLISH
                          dictionary:nil];
    }
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: viewController];
    
    [self.navigationController presentModalViewController:navController animated:YES];

    [viewController release];
    [navController release];
}
-(void)refreshUserInfo
{
    if([[BSDKManager sharedManager] isLogin])
    {
        NSString * accountId = [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:KEY_ACCOUNT_ID];
        [[BSDKManager sharedManager] getUserInforByUserId:accountId
                                          andDoneCallback:^(AIO_STATUS status, NSDictionary *data)
        {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
            [self.tableView reloadData];
        }];
    }
}


- (IBAction)onEditPressed:(UIButton*)sender
{
    UIViewController * viewController = [[MineEditingViewController alloc]
                                         initWithNibName:@"MineEditingViewController"
                                         bundle:nil];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: viewController];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [viewController release];
    [navController release];
}
@end
