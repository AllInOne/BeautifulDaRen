//
//  MyInfoViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/2/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTopViewCell.h"
#import "FourGridViewCell.h"
#import "ButtonViewCell.h"
#import "MyInfoDetailViewCell.h"

#import "UserAccount.h"

@interface MyInfoViewController()
@property (retain, nonatomic) IBOutlet UIButton * followButton;
@property (retain, nonatomic) IBOutlet UIButton * fansButton;
@property (retain, nonatomic) IBOutlet UIButton * collectionButton;
@property (retain, nonatomic) IBOutlet UIButton * blackListButton;
@property (retain, nonatomic) IBOutlet UIButton * buyedButton;
@property (retain, nonatomic) IBOutlet UIButton * topicButton;
@property (retain, nonatomic) IBOutlet UIButton * editButton;

// TODO use core data.
@property (retain, nonatomic) UserAccount * userAccount;

@end

@implementation MyInfoViewController
@synthesize followButton = _followButton;
@synthesize fansButton = _fansButton;
@synthesize collectionButton = _collectionButton;
@synthesize blackListButton = _blackListButton;
@synthesize buyedButton = _buyedButton;
@synthesize topicButton = _topicButton;
@synthesize editButton = _editButton;

@synthesize userAccount;

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
    self.userAccount = [[[UserAccount alloc] init] autorelease];
    self.userAccount.uniqueneId = @"UID1234567890";
    self.userAccount.userDisplayId = @"我是美丽达人";
    self.userAccount.level = 12;
    self.userAccount.levelDescription = @"资深美丽达人";
    self.userAccount.localCity = @"成都";
    self.userAccount.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"item_fake"]);
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadFakeData];
    // Do any additional setup after loading the view from its nib.
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
        // TODO to use the real data.
        ((MyInfoTopViewCell*)cell).avatarImageView.image = [UIImage imageWithData:self.userAccount.imageData];
        ((MyInfoTopViewCell*)cell).levelLabel.text = [NSString stringWithFormat:@"LV%d", self.userAccount.level];
        ((MyInfoTopViewCell*)cell).levelLabelTitle.text = self.userAccount.levelDescription;
        ((MyInfoTopViewCell*)cell).beautifulIdLabel.text = self.userAccount.userDisplayId;
        ((MyInfoTopViewCell*)cell).leftImageView.image = [UIImage imageNamed:@"location"];
        ((MyInfoTopViewCell*)cell).editImageView.image = [UIImage imageNamed:@"location"];
        ((MyInfoTopViewCell*)cell).cityLabel.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"local_city", @""),self.userAccount.localCity];
        _editButton = ((MyInfoTopViewCell*)cell).editButton;
        ((MyInfoTopViewCell*)cell).delegate = self;
    }
    else if(section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:fourGridViewIndentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:fourGridViewIndentifier owner:self options:nil] objectAtIndex:0];
        }
        ((FourGridViewCell*)cell).delegate = self;
        ((FourGridViewCell*)cell).leftTopLabelName.text = NSLocalizedString(@"follow", @"");
        ((FourGridViewCell*)cell).leftTopLabelNumber.text = @"(10)";
        ((FourGridViewCell*)cell).rightTopLabelName.text = NSLocalizedString(@"fans", @"");
        ((FourGridViewCell*)cell).rightTopLabelNumber.text = @"(20)";
        ((FourGridViewCell*)cell).leftBottomLabelName.text = NSLocalizedString(@"collection", @"");
        ((FourGridViewCell*)cell).leftBottomLabelNumber.text = @"(12)";
        ((FourGridViewCell*)cell).rightBottomLabelName.text = NSLocalizedString(@"buyed", @"");
        ((FourGridViewCell*)cell).rightBottomLabelNumber.text = @"(32)";

        ((FourGridViewCell*)cell).thirdLeftLabelName.text = NSLocalizedString(@"topic", @"");
        ((FourGridViewCell*)cell).thirdLeftLabelNumber.text = @"(32)";  

        ((FourGridViewCell*)cell).thirdRightLabelName.text = NSLocalizedString(@"black_list", @"");
        ((FourGridViewCell*)cell).thirdRIghtLabelNumber.text = @"(1)";
        
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
        NSLog(@"edit button pressed");
    }
    else
    {
        NSAssert(NO, @"There is not any other button should be pressed!");
    }
}

@end
