//
//  MineEditingViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/10/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "MineEditingViewController.h"
#import "MyInfoTopViewCell.h"
#import "ViewHelper.h"
#import "ButtonViewCell.h"
#import "EdittingViewController.h"
#import "SelectCityViewController.h"
#import "SegmentControl.h"
#import "iToast.h"
#import "ViewConstants.h"

@interface MineEditingViewController()

@property (retain, nonatomic) IBOutlet UIButton * updateAvatarButton;
@property (retain, nonatomic) NSMutableDictionary * tableViewDict;
@end

@implementation MineEditingViewController
@synthesize updateAvatarButton = _updateAvatarButton;
@synthesize tableViewDict = _tableViewDict;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)onBackButtonClicked
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)onSaveButtonClicked
{
    [[iToast makeText:@"保存"] show];
}

#pragma mark - View lifecycle
-(void)dealloc
{
    [super dealloc];
    [_updateAvatarButton release];
    [_tableViewDict release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:NSLocalizedString(@"edit_profile", @"edit_profile")];
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onSaveButtonClicked) title:NSLocalizedString(@"save", @"save")]];
    _tableViewDict = [[NSMutableDictionary alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.updateAvatarButton = nil;
    self.tableViewDict = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableViewDict removeAllObjects];
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
    _tableViewDict = [dict mutableCopy];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section) {
        case 0:
        case 1:
        {
            number = 1;
            break;
        }
        case 2:
        {
            number = 6;
            break;
        }
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * infoTopViewIdentifier = @"MyInfoTopViewCell";
    static NSString * buttonViewCellIdentifier = @"ButtonViewCell";
    
    UITableViewCell * cell;
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:infoTopViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:infoTopViewIdentifier owner:self options:nil] objectAtIndex:1];
            ((MyInfoTopViewCell*)cell).avatarImageView.image = [UIImage imageNamed:@"avatar_big"];
            _updateAvatarButton =  ((MyInfoTopViewCell*)cell).updateAvatarButton;
            ((MyInfoTopViewCell*)cell).delegate = self;
        }
    }
    else if(section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:5];
        }
        ButtonViewCell * buttonViewCell = (ButtonViewCell*)cell;
        buttonViewCell.leftLabel.text = NSLocalizedString(@"gender", @"gender");

        SegmentControl * seg = [[SegmentControl alloc]
                                initWithFrame:CGRectMake(65, 8, 112, 29)
                                leftText:NSLocalizedString(@"female", @"gender")
                                rightText:NSLocalizedString(@"male", @"gender")];
        [buttonViewCell addSubview:seg];
        [seg release];
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:3];
        }
        ButtonViewCell * buttonViewCell = (ButtonViewCell*)cell;
        switch ([indexPath row]) {
            case 0:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"nickname", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:USERDEFAULT_ACCOUNT_USERNAME];
                break;
            }
            case 1:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"city", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:USERDEFAULT_ACCOUNT_CITY];
                break;
            }
            case 2:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"address", @"");
                buttonViewCell.buttonText.text = @"锦江区";
                break;
            }
            case 3:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"phone", @"");
                buttonViewCell.buttonText.text = @"+8612345678901";
                break;
            }
            case 4:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"senior", @"");
                buttonViewCell.buttonText.text = @"高级内容";
                break;
            } 
            case 5:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"brief", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:USERDEFAULT_ACCOUNT_INTRO];
                break;
            } 
        }
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    NSInteger section = [indexPath section];
    switch (section) {
        case 0:
        {
            height = 72.0f;
            break;
        }
        case 1:
        {
            height = 40.0f;
            break;
        }
        case 2:
        {
            height = 40.0f;
            break;
        }    }
    return height;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    if(section == 2)
    {
        NSInteger type = 0;
        NSInteger row = [indexPath row];
        if(row == 1)
        {
            SelectCityViewController *citySelectionController = 
            [[SelectCityViewController alloc] initWithNibName:nil bundle:nil];
            
            UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: citySelectionController];
            
            [self.navigationController presentModalViewController:navController animated:YES];
            
            [navController release];
            [citySelectionController release];
        }
        else {
            EditDoneBlock block = nil;
            if(row == 4)
            {
                type = EdittingViewController_type1;
                
            }
            else
            {
                type = EdittingViewController_type0;
                switch (row) {
                    case 0:
                    {
                        block = ^(NSString * text)
                        {
                            [_tableViewDict setValue:text
                                              forKey:USERDEFAULT_ACCOUNT_USERNAME];
                            [self.tableView reloadData];
                        };
                        break;
                    }
                    case 1:
                    {
                        block = ^(NSString * text)
                        {
                            
                        };
                        break;
                    }
                    case 2:
                        
                        break;
                    case 3:
                        break;
                }
            }
            EdittingViewController * edittingViewController = [[EdittingViewController alloc]
                                                               initWithNibName:@"EdittingViewController" 
                                                               bundle:nil
                                                               type:type
                                                               block:^(NSString *text) {
                                                                   
                                                               }];
            [self.navigationController pushViewController:edittingViewController animated:YES];
            [edittingViewController release];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (void) genderSelected:(UISegmentedControl*)segmentedControl
{
    [ViewHelper showSimpleMessage:@"你修改了性别" withTitle:nil withButtonText:@"好"];
}

#pragma mark ButtonPressDelegate
- (void) didButtonPressed:(UIButton *)button inView:(UIView *)view
{
    if(button == _updateAvatarButton)
    {
        NSLog(@"_updateAvatarButton pressed");
    }
}

@end
