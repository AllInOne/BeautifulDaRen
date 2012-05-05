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

// TODO use core data.
@property (retain, nonatomic) UserAccount * userAccount;

@end

@implementation MyInfoViewController
@synthesize followButton;
@synthesize fansButton;
@synthesize collectionButton;
@synthesize blackListButton;

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
    self.userAccount.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"avatar_icon"]);
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
    return 6;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * myInfoTopViewIdentifier = @"MyInfoTopViewCell";
    static NSString * fourGridViewIndentifier = @"FourGridViewCell";
    static NSString * buttonViewCellIdentifier = @"ButtonViewCell";
    static NSString * myInfoDetailCellIdentifier = @"MyInfoDetailViewCell";
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
        ((MyInfoTopViewCell*)cell).cityLabel.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"local_city", @""),self.userAccount.localCity];
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
        ((FourGridViewCell*)cell).rightBottomLabelName.text = NSLocalizedString(@"black_list", @"");
        ((FourGridViewCell*)cell).rightBottomLabelNumber.text = @"(32)";
        
        self.followButton = ((FourGridViewCell*)cell).leftTopButton;
        self.fansButton = ((FourGridViewCell*)cell).rightTopButton;
        self.collectionButton = ((FourGridViewCell*)cell).leftButtomButton;
        self.blackListButton = ((FourGridViewCell*)cell).rightButtomButton;
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
        }
    }
    else if (section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        switch ([indexPath row]) {
            case 0:
            {
                ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"shop"];
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"at_me", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"shop"];
                break;
            }
            case 1:
            {
                ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"shop"];
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"comment_me", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"shop"];
                break;
            }
        }
    }
    else if (section == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"shop"];
        ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"my_interesting", @"");
        ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"shop"];
    }
    else if (section == 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:myInfoDetailCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:myInfoDetailCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        ((MyInfoDetailViewCell*)cell).cellTextView.text = @"显示个人资料，详细信息，生日，其他的一些。尼古拉斯凯奇";
        ((MyInfoDetailViewCell*)cell).cellImageView.image = [UIImage imageNamed:@"shop"];
    }
    return cell;
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
            numberOfRows = 2;
            break;
        case 3:
            numberOfRows = 2;
            break;
        // my interesting 
        case 4:
            numberOfRows = 1;
            break;
        // personal info
        case 5:
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
        height = 75.0f;
    }
    else if (section == 1)
    {
        height = 80.0f;
    }
    else if (section == 2)
    {
        height = 40.0f;
    }
    else if (section == 3)
    {
        height = 40.0f;
    }
    else if (section == 4)
    {
        height = 40.0f;
    }
    else if (section == 5)
    {
        height = 120.0f;
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
        }
    }
    // @我 and 评论我的
    else if(section == 3)
    {
        switch ([indexPath row]) {
            case 0:
            {
                // TODO
                NSLog(@"To handle press @me");
                break;
            }
            case 1:
            {
                // TODO
                NSLog(@"To handle press comment me");
                break;
            }
        }
    }
    // 我的兴趣
    else if(section == 4)
    {
        // TODO
        NSLog(@"To handle press my interesting");
    }
}

#pragma mark ButtonPressDelegate
- (void) didButtonPressed:(UIButton*)button inView:(UIView *)view
{
    if(button == self.followButton)
    {
        NSLog(@"followButton pressed");
    }
    else if (button == self.fansButton)
    {
        NSLog(@"fansButton pressed");
    }
    else if (button == self.collectionButton)
    {
        NSLog(@"collectionButton pressed");
    }
    else if (button == self.blackListButton)
    {
        NSLog(@"blackListButton pressed");
    }
    else
    {
        NSAssert(NO, @"There is not any other button should be pressed!");
    }
}

@end
