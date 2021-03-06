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

@property (retain, nonatomic) id observerForNewInfoToMe;

-(void)refreshUserInfo;

-(UILabel *)getBadgeLabel:(NSString *)badge;
- (void)refreshBadges:(NSString *)string;

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
@synthesize observerForNewInfoToMe = _observerForNewInfoToMe;

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

    _observerForNewInfoToMe = [[NSNotificationCenter defaultCenter]
                               addObserverForName:K_NOTIFICATION_MINE_NEW_INFO
                               object:nil
                               queue:nil
                               usingBlock:^(NSNotification *notification) {
                                   [self.tableView reloadData];
                               }];

}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:_observerForNewInfoToMe];
    self.tableView = nil;
    self.followButton = nil;
    self.fansButton = nil;
    self.collectionButton = nil;
    self.blackListButton = nil;
    self.buyedButton = nil;
    self.topicButton = nil;
    self.editButton = nil;
    self.mypublishButton = nil;
    [super viewDidUnload];
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
        UIImageView * imageView = [[UIImageView alloc] init];
        NSString * avatarImageUrl = [userDict valueForKey:K_BSDK_PICTURE_65];
        if (avatarImageUrl && [avatarImageUrl length] > 0 ) {
            [imageView setImageWithURL:[NSURL URLWithString:avatarImageUrl]];
        }
        else
        {
            [imageView setImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:userDict]]];
        }

        CGRect borderImageViewFrame = CGRectMake(0,0,
                                                 ((MyInfoTopViewCell*)cell).avatarImageView.frame.size.width,
                                                 ((MyInfoTopViewCell*)cell).avatarImageView.frame.size.height);
        BorderImageView * borderView = [[BorderImageView alloc]
                                            initWithFrame:borderImageViewFrame
                                            andView:imageView];
        [((MyInfoTopViewCell*)cell).avatarImageView addSubview:borderView];
        [imageView release];
        [borderView release];
        NSString * isVerify = [userDict objectForKey:K_BSDK_ISVERIFY];
        if (isVerify && [isVerify isEqual:K_BSDK_ISVERIFY_YES]) {
            [((MyInfoTopViewCell*)cell).vMarkImageView setImage:[UIImage imageNamed:@"v_mark_big"]];
            [((MyInfoTopViewCell*)cell).vMarkImageView setHidden:NO];
        }
        else
        {
            [((MyInfoTopViewCell*)cell).vMarkImageView setHidden:YES];
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

        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"follow", @"") detail:[NSString stringWithFormat:@" (%d)", [[userDict valueForKey:KEY_ACCOUNT_FOLLOW_COUNT] intValue]]];
        ((GridViewCell*)cell).firstLabel.attributedText = attrStr;
        ((GridViewCell*)cell).firstLabel.textAlignment = UITextAlignmentCenter;

        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"fans", @"") detail:[NSString stringWithFormat:@" (%d)", [[userDict valueForKey:KEY_ACCOUNT_FANS_COUNT] intValue]]];
        ((GridViewCell*)cell).secondLabel.attributedText = attrStr;
        ((GridViewCell*)cell).secondLabel.textAlignment = UITextAlignmentCenter;

        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"collection", @"") detail:[NSString stringWithFormat:@" (%d)", [[userDict valueForKey:KEY_ACCOUNT_FAVORITE_COUNT] intValue]]];
        ((GridViewCell*)cell).thirdLabel.attributedText = attrStr;
        ((GridViewCell*)cell).thirdLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"ordered", @"")
                                                                    detail:[NSString stringWithFormat:@" (%d)", [[userDict valueForKey:KEY_ACCOUNT_ORDERED_COUNT] intValue]]];
        ((GridViewCell*)cell).fourthLabel.attributedText = attrStr;
        ((GridViewCell*)cell).fourthLabel.textAlignment = UITextAlignmentCenter;

        _followButton = ((GridViewCell*)cell).firstButton;
        _fansButton = ((GridViewCell*)cell).secondButton;
        _collectionButton = ((GridViewCell*)cell).thirdButton;
        _buyedButton = ((GridViewCell*)cell).fourthButton;
        NSNumber * followNumber = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_FOLLOW_ME_NOTIFICATION_COUNT];
        if (followNumber.intValue > 0) {
            ((GridViewCell*)cell).secondBadgeView.image = [UIImage imageNamed:@"badge"];
            NSString * badge = followNumber.intValue < 10 ? [followNumber stringValue] : @"N";
            [((GridViewCell*)cell).secondBadgeView addSubview:[self getBadgeLabel:badge]];
        }
    }
    else if (section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
        ButtonViewCell * buttonViewCell = (ButtonViewCell*)cell;
        switch ([indexPath row]) {
            case 0:
            {
                buttonViewCell.buttonText.text = NSLocalizedString(@"at_me", @"");
                CGFloat textWidth = [ViewHelper getWidthOfText:buttonViewCell.buttonText.text ByFontSize:buttonViewCell.buttonText.font.pointSize];
                UILabel * numberLabel = [[UILabel alloc] initWithFrame:
                                         CGRectMake(buttonViewCell.buttonText.frame.origin.x + textWidth + 10,
                                                    buttonViewCell.buttonText.frame.origin.y,
                                                    50,
                                                    buttonViewCell.buttonText.frame.size.height)];
                [numberLabel setTextAlignment:UITextAlignmentLeft];
                [numberLabel setTextColor:[UIColor colorWithRed:(204.0f/255.0f) green:(88.0f/255.0f) blue:(151.0f/255.0f) alpha:1.0f]];
                numberLabel.text = [NSString stringWithFormat:@" (%d)",[[userDict valueForKey:KEY_ACCOUNT_AT_COUNT] intValue]];
                [buttonViewCell addSubview:numberLabel];
                [numberLabel release];
                buttonViewCell.buttonLeftIcon.image = [UIImage imageNamed:@"my_at"];
                NSNumber * atMeNumber = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_AT_ME_NOTIFICATION_COUNT];
                if (atMeNumber.intValue > 0) {
                    buttonViewCell.badgeView.image = [UIImage imageNamed:@"badge"];
                    NSString * badge = atMeNumber.intValue < 10 ? [atMeNumber stringValue] : @"N";
                    [buttonViewCell.badgeView addSubview:[self getBadgeLabel:badge]];
                }
                break;
            }
            case 1:
            {
                buttonViewCell.buttonText.text = NSLocalizedString(@"comment_me", @"");
                CGFloat textWidth = [ViewHelper getWidthOfText:buttonViewCell.buttonText.text ByFontSize:buttonViewCell.buttonText.font.pointSize];
                UILabel * numberLabel = [[UILabel alloc] initWithFrame:
                                         CGRectMake(buttonViewCell.buttonText.frame.origin.x + textWidth + 10,
                                                    buttonViewCell.buttonText.frame.origin.y,
                                                    50,
                                                    buttonViewCell.buttonText.frame.size.height)];
                [numberLabel setTextAlignment:UITextAlignmentLeft];
                [numberLabel setTextColor:[UIColor colorWithRed:(204.0f/255.0f) green:(88.0f/255.0f) blue:(151.0f/255.0f) alpha:1.0f]];
                numberLabel.text = [NSString stringWithFormat:@" (%d)",[[userDict valueForKey:KEY_ACCOUNT_COMMENT_COUNT] intValue]];
                [buttonViewCell addSubview:numberLabel];
                [numberLabel release];
                buttonViewCell.buttonLeftIcon.image = [UIImage imageNamed:@"comment_icon"];
                NSNumber * commentMeNumber = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_COMMENT_ME_NOTIFICATION_COUNT];
                if (commentMeNumber.intValue > 0) {
                    buttonViewCell.badgeView.image = [UIImage imageNamed:@"badge"];
                    NSString * badge = commentMeNumber.intValue < 10 ? [commentMeNumber stringValue] : @"N";
                    [buttonViewCell.badgeView addSubview:[self getBadgeLabel:badge]];
                }
                break;
            }
            case 2:
            {
                buttonViewCell.buttonText.text = NSLocalizedString(@"private_letter", @"");
                CGFloat textWidth = [ViewHelper getWidthOfText:buttonViewCell.buttonText.text ByFontSize:buttonViewCell.buttonText.font.pointSize];
                UILabel * numberLabel = [[UILabel alloc] initWithFrame:
                                         CGRectMake(buttonViewCell.buttonText.frame.origin.x + textWidth + 10,
                                                    buttonViewCell.buttonText.frame.origin.y,
                                                    50,
                                                    buttonViewCell.buttonText.frame.size.height)];
                [numberLabel setTextAlignment:UITextAlignmentLeft];
                [numberLabel setTextColor:[UIColor colorWithRed:(204.0f/255.0f) green:(88.0f/255.0f) blue:(151.0f/255.0f) alpha:1.0f]];
                numberLabel.text = [NSString stringWithFormat:@" (%d)",[[userDict valueForKey:KEY_ACCOUNT_PRIVATE_MSG_COUNT] intValue]];
                [buttonViewCell addSubview:numberLabel];
                [numberLabel release];
                buttonViewCell.buttonLeftIcon.image = [UIImage imageNamed:@"my_private_letter"];

                NSNumber * privateMessageNumber = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_PRIVATE_MESSAGE_NOTIFICATION_COUNT];
                if (privateMessageNumber.intValue > 0) {
                    buttonViewCell.badgeView.image = [UIImage imageNamed:@"badge"];
                    NSString * badge = privateMessageNumber.intValue < 10 ? [privateMessageNumber stringValue] : @"N";
                    [buttonViewCell.badgeView addSubview:[self getBadgeLabel:badge]];
                }
                break;
            }
            case 3:
            {
                buttonViewCell.buttonText.text = NSLocalizedString(@"my_publish", @"");
                CGFloat textWidth = [ViewHelper getWidthOfText:buttonViewCell.buttonText.text ByFontSize:buttonViewCell.buttonText.font.pointSize];
                UILabel * numberLabel = [[UILabel alloc] initWithFrame:
                                         CGRectMake(buttonViewCell.buttonText.frame.origin.x + textWidth + 10,
                                                    buttonViewCell.buttonText.frame.origin.y,
                                                    50,
                                                    buttonViewCell.buttonText.frame.size.height)];
                [numberLabel setTextAlignment:UITextAlignmentLeft];
                [numberLabel setTextColor:[UIColor colorWithRed:(204.0f/255.0f) green:(88.0f/255.0f) blue:(151.0f/255.0f) alpha:1.0f]];
                numberLabel.text = [NSString stringWithFormat:@" (%d)",[[userDict valueForKey:KEY_ACCOUNT_BLOG_COUNT] intValue]];
                [buttonViewCell addSubview:numberLabel];
                [numberLabel release];
                buttonViewCell.buttonLeftIcon.image = [UIImage imageNamed:@"my_composed"];
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
            numberOfRows = 4;
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

                [self refreshBadges:USERDEFAULT_AT_ME_NOTIFICATION_COUNT];
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

                [self refreshBadges:USERDEFAULT_COMMENT_ME_NOTIFICATION_COUNT];
                break;
            }
            case 2:
            {
                PrivateLetterViewController * privateLetterViewController = [[PrivateLetterViewController alloc]
                                                                    initWithNibName:nil
                                                                    bundle:nil];

                UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: privateLetterViewController];

                [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];

                [navController release];
                [privateLetterViewController release];

                [self refreshBadges:USERDEFAULT_PRIVATE_MESSAGE_NOTIFICATION_COUNT];
                break;
            }
            case 3:
            {
                WeiboListViewController * myPublishViewController = [[WeiboListViewController alloc]
                                                                     initWithNibName:@"WeiboListViewController"
                                                                     bundle:nil
                                                                     type:WeiboListViewControllerType_MY_PUBLISH
                                                                     dictionary:nil];
                UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: myPublishViewController];
                
                [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
                
                [navController release];
                [myPublishViewController release];
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
                self.navigationController.tabBarItem.badgeValue = nil;
                [[NSUserDefaults standardUserDefaults] setObject:nil
                                                          forKey:USERDEFAULT_MY_NEW_NOTIFICATION_COUNT];
                [[NSUserDefaults standardUserDefaults] setObject:nil
                                                          forKey:USERDEFAULT_AT_ME_NOTIFICATION_COUNT];
                [[NSUserDefaults standardUserDefaults] setObject:nil
                                                          forKey:USERDEFAULT_PRIVATE_MESSAGE_NOTIFICATION_COUNT];
                [[NSUserDefaults standardUserDefaults] setObject:nil
                                                          forKey:USERDEFAULT_FOLLOW_ME_NOTIFICATION_COUNT];
                [[NSUserDefaults standardUserDefaults] setObject:nil
                                                          forKey:USERDEFAULT_COMMENT_ME_NOTIFICATION_COUNT];

                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:USERDEFAULT_IS_AUTO_LOGIN];
                [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_LOGINOUT_SUCCESS object:self userInfo:data];

//                LoginViewController * loginContorller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//                [self.navigationController pushViewController:loginContorller animated:YES];
//                [loginContorller release];
//                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
                [self.view removeFromSuperview];
                self.view = nil;
                [self.tabBarController setSelectedIndex:0];
            }
            else {
                [[iToast makeText:@"亲, 账户退出失败!"] show];
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
        [self refreshBadges:USERDEFAULT_FOLLOW_ME_NOTIFICATION_COUNT];
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
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: TRUE];

        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [[BSDKManager sharedManager] getUserInforByUserId:accountId
                                          andDoneCallback:^(AIO_STATUS status, NSDictionary *data)
        {
            if (K_BSDK_IS_RESPONSE_OK(data)) {

                NSAssert(data && [data count] > 0, @"data should not be nil");
               [[NSUserDefaults standardUserDefaults] setObject:data forKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
                [self.tableView reloadData];
            }
            else
            {
                [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: FALSE];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
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

-(UILabel *)getBadgeLabel:(NSString *)badge {
    UILabel * badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    badgeLabel.backgroundColor = [UIColor clearColor];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.textAlignment = UITextAlignmentCenter;
    badgeLabel.text = badge;
    return [badgeLabel autorelease];
}

- (void)refreshBadges:(NSString *)string {
    NSNumber *count = [[NSUserDefaults standardUserDefaults] valueForKey:string];
    NSNumber *allCount = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_MY_NEW_NOTIFICATION_COUNT];
    NSNumber *newAllCount = [NSNumber numberWithInteger:allCount.intValue - count.intValue];
    [[NSUserDefaults standardUserDefaults] setObject:newAllCount
                                              forKey:USERDEFAULT_MY_NEW_NOTIFICATION_COUNT];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0]
                                              forKey:string];

    if ( newAllCount.intValue <= 0) {
        self.navigationController.tabBarItem.badgeValue = nil;
    } else {
        self.navigationController.tabBarItem.badgeValue = newAllCount.stringValue;
    }

    [self.tableView reloadData];
}
@end
