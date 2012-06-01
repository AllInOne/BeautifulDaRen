//
//  FriendDetailViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/21/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "ButtonViewCell.h"
#import "GridViewCell.h"
#import "ViewHelper.h"
#import "ViewConstants.h"
#import "CommonViewController.h"
#import "iToast.h"

@interface FriendDetailViewController()
@property (retain, nonatomic) IBOutlet UIButton * weiboButton;
@property (retain, nonatomic) IBOutlet UIButton * topicButton;
@property (retain, nonatomic) IBOutlet UIButton * followButton;
@property (retain, nonatomic) IBOutlet UIButton * fansButton;
@property (retain, nonatomic) IBOutlet UIButton * collectionButton;
@property (retain, nonatomic) IBOutlet UIButton * publishedButton;

@property (retain, nonatomic) IBOutlet UITableView * friendDetailView;
@property (assign, nonatomic) BOOL isIdentification;

- (void) onActionButtonClicked: (UIButton*)sender;
@end

@implementation FriendDetailViewController
@synthesize friendDetailView = _friendDetailView;
@synthesize isIdentification = _isIdentification;

@synthesize followButton = _followButton;
@synthesize fansButton = _fansButton;
@synthesize collectionButton = _collectionButton;
@synthesize weiboButton = _weiboButton;
@synthesize publishedButton = _publishedButton;
@synthesize topicButton = _topicButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"her_home_page", @"her_home_page")];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onHomePageButtonClicked) title:NSLocalizedString(@"home_page", @"home_page")]];
        _isIdentification = YES;
        
        UIToolbar *tempToolbar = [[[UIToolbar alloc]initWithFrame:CGRectMake(0,372, 320,44)] autorelease];
        
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *atButtonItem = [ViewHelper getToolBarItemOfImageName:@"toolbar_at_icon" target:self action:@selector(onAt)];
        
        UIBarButtonItem *removeButtonItem = [ViewHelper getToolBarItemOfImageName:@"toolbar_remove_fan_icon" target:self action:@selector(onRemove)];
        
        NSArray *barItems = [[NSArray alloc]initWithObjects:flexible, 
                             atButtonItem, 
                             flexible,
                             flexible,
                             removeButtonItem,
                             flexible,
                             nil];
        
        tempToolbar.items= barItems;
        UIImageView * tabBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_background"]];
        tabBarBg.frame = CGRectMake(0, 0, 320, 45);
        tabBarBg.contentMode = UIViewContentModeScaleToFill;
        if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
            [tempToolbar  insertSubview:tabBarBg atIndex:0];
        }
        else
        {
            [tempToolbar  insertSubview:tabBarBg atIndex:1];            
        }
        [self.view addSubview: tempToolbar];
        [flexible release]; 

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onHomePageButtonClicked
{
    [ViewHelper showSimpleMessage:@"主页" withTitle:nil withButtonText:@"好的"];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    if(section == 0)
    {
        number = 1;
    }
    else if(section == 1)
    {
        number = _isIdentification ? 2 : 1;
    }
    else if(section == 2)
    {
        number = 1;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * buttonViewCellIdentifier = @"ButtonViewCell";
    static NSString * gridViewCellIdentifier = @"GridViewCell";
    
    UITableViewCell *cell  = nil;

    NSInteger section = [indexPath section];
    if(section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:3];
        }
        ButtonViewCell * buttonViewCell = (ButtonViewCell*)cell;
        buttonViewCell.leftLabel.text = NSLocalizedString(@"notes", @"notes");
        buttonViewCell.buttonText.text = NSLocalizedString(@"set_notes", @"set_notes");
    }
    else if(section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:3];
        }
        if(_isIdentification && [indexPath row] == 0)
        {
            ButtonViewCell * buttonViewCell = (ButtonViewCell*)cell;
            buttonViewCell.leftLabel.text = NSLocalizedString(@"authentication", @"authentication");
            buttonViewCell.buttonText.text = @"仁和春天人东店官方账号";
            buttonViewCell.buttonRightIcon.hidden = YES;
        }
        else
        {
            ButtonViewCell * buttonViewCell = (ButtonViewCell*)cell;
            buttonViewCell.leftLabel.text = NSLocalizedString(@"brief", @"brief");
            buttonViewCell.buttonText.text = @"成都仁和春天百货店人东店！";
            buttonViewCell.buttonRightIcon.hidden = YES;
        }
    }
    else if(section == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:gridViewCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:gridViewCellIdentifier owner:self options:nil] objectAtIndex:1];
        }
        
        NSMutableAttributedString * attrStr = nil;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"weibo", @"") detail:@"(12)"];
        ((GridViewCell*)cell).firstLabel.attributedText = attrStr;
        ((GridViewCell*)cell).firstLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"topic", @"") detail:@"(1)"];
        ((GridViewCell*)cell).secondLabel.attributedText = attrStr;
        ((GridViewCell*)cell).secondLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"follow", @"") detail:@"(99)"];
        ((GridViewCell*)cell).thirdLabel.attributedText = attrStr;
        ((GridViewCell*)cell).thirdLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"fans", @"") detail:@"(100)"];
        ((GridViewCell*)cell).fourthLabel.attributedText = attrStr;
        ((GridViewCell*)cell).fourthLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"collection", @"") detail:@"(33)"];
        ((GridViewCell*)cell).fifthLabel.attributedText = attrStr;
        ((GridViewCell*)cell).fifthLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"published", @"") detail:@"(12)"];
        ((GridViewCell*)cell).sixthLabel.attributedText = attrStr;
        ((GridViewCell*)cell).sixthLabel.textAlignment = UITextAlignmentCenter;
        
        _weiboButton = ((GridViewCell*)cell).firstButton;
        _topicButton = ((GridViewCell*)cell).secondButton;

        _followButton = ((GridViewCell*)cell).thirdButton;
        _fansButton = ((GridViewCell*)cell).fourthButton;
        
        _collectionButton = ((GridViewCell*)cell).fifthButton;
        _publishedButton = ((GridViewCell*)cell).sixthButton;
        ((GridViewCell*)cell).delegate = self;
    }
    
    return cell;
}

-(void)onWeiboButton
{
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        height = 40.0f;
    }
    else if (section == 1)
    {
        height = 40.0f;
    }
    else if (section == 2)
    {
        height = 107.0f;
    }
    return height;
}

- (void) didButtonPressed:(UIButton*)button inView:(UIView *)view
{
    if(button == _followButton)
    {
        CommonViewController * followViewController = [[[CommonViewController alloc] initWithNibName:@"CommonViewController" bundle:nil] autorelease];
        
        [self.navigationController pushViewController:followViewController animated:YES];
    }
    else if (button == _fansButton)
    {
        CommonViewController * followViewController = [[[CommonViewController alloc] initWithNibName:@"CommonViewController" bundle:nil] autorelease];
        
        [self.navigationController pushViewController:followViewController animated:YES];
    }
    else if (button == _collectionButton)
    {
        [[iToast makeText:@"收藏"] show];
    }
    else if (button == _weiboButton)
    {
        [[iToast makeText:@"微博"] show];
    }
    else if(button == _publishedButton)
    {
        [[iToast makeText:@"已发布"] show];
    }
    else if(button == _topicButton)
    {
        [[iToast makeText:@"话题"] show];
    }
    else
    {
        NSAssert(NO, @"There is not any other button should be pressed!");
    }
}

- (void) onActionButtonClicked: (UIButton*)sender
{
    UIActionSheet * actionSheet = [[[UIActionSheet alloc] initWithTitle:@""
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:nil, nil] autorelease];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"add_to_black_list", @"add_to_black_list")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"impeach", "impeach")];
    [actionSheet setDestructiveButtonIndex:[actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"cancel")]];
    
    [actionSheet showInView:sender.superview.superview];
}

- (void)onAt
{
    [[iToast makeText:@"at！"] show];
}

- (void)onRemove
{
    [[iToast makeText:@"remove！"] show];
}

@end
