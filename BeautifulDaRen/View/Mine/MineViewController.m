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
#import "CommentOrForwardViewController.h"
#import "ViewHelper.h"
#import "PrivateLetterViewController.h"
#import "CommonViewController.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"
#import "iToast.h"

@interface MineViewController()

@property (retain, nonatomic) IBOutlet UIButton * followButton;
@property (retain, nonatomic) IBOutlet UIButton * fansButton;
@property (retain, nonatomic) IBOutlet UIButton * collectionButton;
@property (retain, nonatomic) IBOutlet UIButton * blackListButton;
@property (retain, nonatomic) IBOutlet UIButton * buyedButton;
@property (retain, nonatomic) IBOutlet UIButton * topicButton;
@property (retain, nonatomic) IBOutlet UIButton * editButton;

@end

@implementation MineViewController
@synthesize followButton = _followButton;
@synthesize fansButton = _fansButton;
@synthesize collectionButton = _collectionButton;
@synthesize blackListButton = _blackListButton;
@synthesize buyedButton = _buyedButton;
@synthesize topicButton = _topicButton;
@synthesize editButton = _editButton;

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

#pragma mark FAKE
- (void) loadFakeData
{
    NSDictionary * userIdentityDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"LOCAL_IDENTITY_001", USERIDENTITY_UNIQUE_ID,
                                       @"user name", USERIDENTITY_DISPLAY_NAME,
                                       @"12", USERIDENTITY_LEVEL,
                                       @"成都", USERIDENTITY_LOCAL_CITY,
                                       @"9", USERIDENTITY_FOLLOW_COUNT,
                                       @"10", USERIDENTITY_FANS_COUNT,
                                       @"11", USERIDENTITY_BUYED_COUNT,
                                       @"12", USERIDENTITY_COLLECTION_COUNT,
                                       @"13", USERIDENTITY_TOPIC_COUNT,
                                       @"14", USERIDENTITY_BLACK_LIST_COUNT,
                                       @"0", USERIDENTITY_IS_MALE,
                                       @"I am super.", USERIDENTITY_PERSONAL_BRIEF,
                                       @"成都，天府软件园", USERIDENTITY_DETAILED_ADDRESS,
                                       nil];
    [[DataManager sharedManager] saveLocalIdentityWithDictionary:userIdentityDict finishBlock:^(NSError *error) {
        NSLog(@"Save local identity successful");
    }];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"title_mine", @"title_mine")];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClick) title:NSLocalizedString(@"refresh", @"refresh")]];

    [self loadFakeData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) onRefreshButtonClick
{
    [[iToast makeText:@"刷新"] show];
}

#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
        
        UserIdentity * userIdentity = [[DataManager sharedManager] getCurrentLocalIdentityInContext:nil];
        
        ((MyInfoTopViewCell*)cell).avatarImageView.image = [UIImage imageNamed:@"avatar_big"];
        ((MyInfoTopViewCell*)cell).levelLabel.text = [NSString stringWithFormat:@"LV%d", [userIdentity.level intValue]];
        ((MyInfoTopViewCell*)cell).levelLabelTitle.text = @"积分120";
        ((MyInfoTopViewCell*)cell).beautifulIdLabel.text = userIdentity.uniqueId;
        ((MyInfoTopViewCell*)cell).rightImageView.image = [UIImage imageNamed:@"gender_female"];
        ((MyInfoTopViewCell*)cell).editImageView.image = [UIImage imageNamed:@"my_edit"];
        ((MyInfoTopViewCell*)cell).cityLabel.text = [NSString stringWithFormat:@"%@ 锦江区南街",userIdentity.localCity];
        _editButton = ((MyInfoTopViewCell*)cell).editButton;
        ((MyInfoTopViewCell*)cell).delegate = self;
    }
    else if(section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:gridViewIndentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:gridViewIndentifier owner:self options:nil] objectAtIndex:0];
        }
        UserIdentity * userIdentity = [[DataManager sharedManager] getCurrentLocalIdentityInContext:nil];
        ((GridViewCell*)cell).delegate = self;

        NSMutableAttributedString * attrStr = nil;

        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"follow", @"") detail:[NSString stringWithFormat:@"(%d)",[userIdentity.followCount intValue]]];
        ((GridViewCell*)cell).firstLabel.attributedText = attrStr;
        ((GridViewCell*)cell).firstLabel.textAlignment = UITextAlignmentCenter;

        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"fans", @"") detail:[NSString stringWithFormat:@"(%d)",[userIdentity.fansCount intValue]]];
        ((GridViewCell*)cell).secondLabel.attributedText = attrStr;
        ((GridViewCell*)cell).secondLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"collection", @"") detail:[NSString stringWithFormat:@"(%d)",[userIdentity.collectionCount intValue]]];
        ((GridViewCell*)cell).thirdLabel.attributedText = attrStr;
        ((GridViewCell*)cell).thirdLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"buyed", @"") detail:[NSString stringWithFormat:@"(%d)",[userIdentity.buyedCount intValue]]];
        ((GridViewCell*)cell).fourthLabel.attributedText = attrStr;
        ((GridViewCell*)cell).fourthLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"topic", @"") detail:[NSString stringWithFormat:@"(%d)",[userIdentity.topicCount intValue]]];
        ((GridViewCell*)cell).fifthLabel.attributedText = attrStr;
        ((GridViewCell*)cell).fifthLabel.textAlignment = UITextAlignmentCenter;
        
         attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"black_list", @"") detail:[NSString stringWithFormat:@"(%d)",[userIdentity.blackListCount intValue]]];
        ((GridViewCell*)cell).sixthLabel.attributedText = attrStr;
        ((GridViewCell*)cell).sixthLabel.textAlignment = UITextAlignmentCenter;
        
        _followButton = ((GridViewCell*)cell).firstButton;
        _fansButton = ((GridViewCell*)cell).secondButton;
        _collectionButton = ((GridViewCell*)cell).thirdButton;
        _buyedButton = ((GridViewCell*)cell).fourthButton;
        _topicButton = ((GridViewCell*)cell).fifthButton;
        _blackListButton = ((GridViewCell*)cell).sixthButton;
    }
    else if (section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        switch ([indexPath row]) {
            case 0:
            {
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"my_publish", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"my_composed"];
                break;
            }
            case 1:
            {
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"at_me", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"my_at"];
                break;
            }
            case 2:
            {
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"comment_me", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"comment_icon"];
                break;
            }
        }
    }    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
            // my info top view
        case 0:
            numberOfRows = 1;
            break;
            // press button views.
        case 1:
            numberOfRows = 1;
            break;
        case 2:
            numberOfRows = 3;
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
        height = 35.0f;
    }
    else if (section == 2)
    {
        height = 40.0f;
    }
    return height;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 3;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
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
                // TODO
                NSLog(@"To handle press my publish");
                break;
            }
            case 1:
            {
                CommentOrForwardViewController * forwardViewController = [[[CommentOrForwardViewController alloc] initWithNibName:@"CommentOrForwardViewController" bundle:nil type:CommentOrForwardViewControllerType_FORWARD] autorelease];
                
                [self.navigationController pushViewController:forwardViewController animated:YES];
                break;
            }
            case 2:
            {
                CommentOrForwardViewController * forwardViewController = [[[CommentOrForwardViewController alloc] initWithNibName:@"CommentOrForwardViewController" bundle:nil type:CommentOrForwardViewControllerType_COMMENT] autorelease];
                
                [self.navigationController pushViewController:forwardViewController animated:YES];
                break;
            }
        }
    }
}

#pragma mark ButtonPressDelegate
- (void) didButtonPressed:(UIButton*)button inView:(UIView *)view
{
    if(button == _followButton)
    {
        CommonViewController * followViewController = [[[CommonViewController alloc] initWithNibName:@"CommonViewController" bundle:nil] autorelease];
        
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: followViewController];
        
        [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
        
        [navController release];
    }
    else if (button == _fansButton)
    {
        CommonViewController * followViewController = [[[CommonViewController alloc] initWithNibName:@"CommonViewController" bundle:nil] autorelease];
        
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: followViewController];
        
        [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
        
        [navController release];
    }
    else if (button == _collectionButton)
    {
        NSLog(@"collectionButton pressed");
    }
    else if (button == _blackListButton)
    {
        NSLog(@"blackListButton pressed");
    }
    else if(button == _buyedButton)
    {
        NSLog(@"buyed button pressed");
    }
    else if(button == _topicButton)
    {
        NSLog(@"topic button pressed");
    }
    else if(button == _editButton)
    {
        MineEditingViewController * editingViewController = [[[MineEditingViewController alloc] initWithNibName:@"MineEditingViewController" bundle:nil] autorelease];
        
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: editingViewController];
        
        [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
        
        [navController release];
    }
    else
    {
        NSAssert(NO, @"There is not any other button should be pressed!");
    }
}

@end
