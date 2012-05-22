//
//  FriendDetailViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/21/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "ButtonViewCell.h"
#import "FourGridViewCell.h"
#import "ViewHelper.h"

@interface FriendDetailViewController()
@property (retain, nonatomic) IBOutlet UIButton * followButton;
@property (retain, nonatomic) IBOutlet UIButton * fansButton;
@property (retain, nonatomic) IBOutlet UIButton * collectionButton;
@property (retain, nonatomic) IBOutlet UIButton * blackListButton;
@property (retain, nonatomic) IBOutlet UIButton * buyedButton;
@property (retain, nonatomic) IBOutlet UIButton * topicButton;

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
@synthesize blackListButton = _blackListButton;
@synthesize buyedButton = _buyedButton;
@synthesize topicButton = _topicButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"her_home_page", @"her_home_page")];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onHelpButtonClicked) title:NSLocalizedString(@"home_page", @"home_page")]];
        
        _isIdentification = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    static NSString * fourGridViewCellIdentifier = @"FourGridViewCell";
    
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
        cell = [tableView dequeueReusableCellWithIdentifier:fourGridViewCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:fourGridViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        
        ((FourGridViewCell*)cell).delegate = self;
        ((FourGridViewCell*)cell).leftTopLabelName.text = NSLocalizedString(@"weibo", @"");
        ((FourGridViewCell*)cell).leftTopLabelNumber.text = @"12";
        ((FourGridViewCell*)cell).rightTopLabelName.text = NSLocalizedString(@"topic", @"");
        ((FourGridViewCell*)cell).rightTopLabelNumber.text = @"12";
        ((FourGridViewCell*)cell).leftBottomLabelName.text = NSLocalizedString(@"follow", @"");
        ((FourGridViewCell*)cell).leftBottomLabelNumber.text = @"32";
        ((FourGridViewCell*)cell).rightBottomLabelName.text = NSLocalizedString(@"fans", @"");
        ((FourGridViewCell*)cell).rightBottomLabelNumber.text = @"0";
        
        ((FourGridViewCell*)cell).thirdLeftLabelName.text = NSLocalizedString(@"collection", @"");
        ((FourGridViewCell*)cell).thirdLeftLabelNumber.text = @"1";  
        
        ((FourGridViewCell*)cell).thirdRightLabelName.text = NSLocalizedString(@"published", @"");
        ((FourGridViewCell*)cell).thirdRIghtLabelNumber.text = @"11";
        
        _followButton = ((FourGridViewCell*)cell).leftTopButton;
        _fansButton = ((FourGridViewCell*)cell).rightTopButton;
        _collectionButton = ((FourGridViewCell*)cell).leftButtomButton;
        _buyedButton = ((FourGridViewCell*)cell).rightButtomButton;
        _topicButton = ((FourGridViewCell*)cell).thirdLeftButton;
        _blackListButton = ((FourGridViewCell*)cell).thirdRightButton;
    }
    
    return cell;
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
    [self onActionButtonClicked:button];
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

@end
