//
//  MyInfoViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/2/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MineEditingViewController.h"
#import "MyInfoTopViewCell.h"
#import "FourGridViewCell.h"
#import "ButtonViewCell.h"
#import "ViewConstants.h"
#import "DataManager.h"

#import "UserIdentity.h"

@interface MyInfoViewController()
@property (retain, nonatomic) IBOutlet UIButton * followButton;
@property (retain, nonatomic) IBOutlet UIButton * fansButton;
@property (retain, nonatomic) IBOutlet UIButton * collectionButton;
@property (retain, nonatomic) IBOutlet UIButton * blackListButton;
@property (retain, nonatomic) IBOutlet UIButton * buyedButton;
@property (retain, nonatomic) IBOutlet UIButton * topicButton;
@property (retain, nonatomic) IBOutlet UIButton * editButton;

@end

@implementation MyInfoViewController
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

#pragma mark FAKE
- (void) loadFakeData
{
    NSDictionary * userIdentityDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"userId1001", USERIDENTITY_UNIQUE_ID,
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
    [[DataManager sharedManager] saveLocalIdentityWithDictionary:userIdentityDict FinishBlock:^(NSError *error) {
        NSLog(@"Save local identity successful");
    }];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * myInfoTopViewIdentifier = @"MyInfoTopViewCell";
    static NSString * fourGridViewIndentifier = @"FourGridViewCell";
    static NSString * buttonViewCellIdentifier = @"ButtonViewCell";
    UITableViewCell * cell = nil;
    NSInteger section = [indexPath section];
    if (section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:myInfoTopViewIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:myInfoTopViewIdentifier owner:self options:nil] objectAtIndex:0];
        }
        
        UserIdentity * userIdentity = [[DataManager sharedManager] getLocalIdentityWithFinishBlock:^(NSError *error) {
            NSLog(@"Get local identity successful");
        }];

        ((MyInfoTopViewCell*)cell).avatarImageView.image = [UIImage imageNamed:@"item_fake"];
        ((MyInfoTopViewCell*)cell).levelLabel.text = [NSString stringWithFormat:@"LV%d", [userIdentity.level intValue]];
        ((MyInfoTopViewCell*)cell).levelLabelTitle.text = @"xxxx";
        ((MyInfoTopViewCell*)cell).beautifulIdLabel.text = userIdentity.uniqueId;
        ((MyInfoTopViewCell*)cell).rightImageView.image = [UIImage imageNamed:@"location"];
        ((MyInfoTopViewCell*)cell).editImageView.image = [UIImage imageNamed:@"location"];
        ((MyInfoTopViewCell*)cell).cityLabel.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"local_city", @""),userIdentity.localCity];
        _editButton = ((MyInfoTopViewCell*)cell).editButton;
        ((MyInfoTopViewCell*)cell).delegate = self;
    }
    else if(section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:fourGridViewIndentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:fourGridViewIndentifier owner:self options:nil] objectAtIndex:0];
        }
        UserIdentity * userIdentity = [[DataManager sharedManager] getLocalIdentityWithFinishBlock:^(NSError *error) {
            NSLog(@"Get local identity successful");
        }];
        
        ((FourGridViewCell*)cell).delegate = self;
        ((FourGridViewCell*)cell).leftTopLabelName.text = NSLocalizedString(@"follow", @"");
        ((FourGridViewCell*)cell).leftTopLabelNumber.text = [NSString stringWithFormat:@"%d", [userIdentity.followCount intValue]];
        ((FourGridViewCell*)cell).rightTopLabelName.text = NSLocalizedString(@"fans", @"");
        ((FourGridViewCell*)cell).rightTopLabelNumber.text = [NSString stringWithFormat:@"%d", [userIdentity.fansCount intValue]];
        ((FourGridViewCell*)cell).leftBottomLabelName.text = NSLocalizedString(@"collection", @"");
        ((FourGridViewCell*)cell).leftBottomLabelNumber.text = [NSString stringWithFormat:@"%d", [userIdentity.collectionCount intValue]];
        ((FourGridViewCell*)cell).rightBottomLabelName.text = NSLocalizedString(@"buyed", @"");
        ((FourGridViewCell*)cell).rightBottomLabelNumber.text = [NSString stringWithFormat:@"%d", [userIdentity.buyedCount intValue]];

        ((FourGridViewCell*)cell).thirdLeftLabelName.text = NSLocalizedString(@"topic", @"");
        ((FourGridViewCell*)cell).thirdLeftLabelNumber.text = [NSString stringWithFormat:@"%d", [userIdentity.topicCount intValue]];  

        ((FourGridViewCell*)cell).thirdRightLabelName.text = NSLocalizedString(@"black_list", @"");
        ((FourGridViewCell*)cell).thirdRIghtLabelNumber.text = [NSString stringWithFormat:@"%d", [userIdentity.blackListCount intValue]];
        
        _followButton = ((FourGridViewCell*)cell).leftTopButton;
        _fansButton = ((FourGridViewCell*)cell).rightTopButton;
        _collectionButton = ((FourGridViewCell*)cell).leftButtomButton;
        _buyedButton = ((FourGridViewCell*)cell).rightButtomButton;
        _topicButton = ((FourGridViewCell*)cell).thirdLeftButton;
        _blackListButton = ((FourGridViewCell*)cell).thirdRightButton;
    }
    else if (section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        switch ([indexPath row]) {
            case 0:
            {
                ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"shop"];
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"my_publish", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"shop"];
                break;
            }
            case 1:
            {
                ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"shop"];
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"private_letter", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"shop"];
                break;
            }
            case 2:
            {
                ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"shop"];
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"at_me", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"shop"];
                break;
            }
            case 3:
            {
                ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"shop"];
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"comment_me", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"shop"];
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
            numberOfRows = 4;
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
        height = 75.0f;
    }
    else if (section == 1)
    {
        height = 107.0f;
    }
    else if (section == 2)
    {
        height = 40.0f;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}

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
                // TODO
                NSLog(@"To handle press private letter");
                break;
            }
            case 2:
            {
                // TODO
                NSLog(@"To handle press @me");
                break;
            }
            case 3:
            {
                // TODO
                NSLog(@"To handle press comment me");
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
        NSLog(@"followButton pressed");
    }
    else if (button == _fansButton)
    {
        NSLog(@"fansButton pressed");
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
