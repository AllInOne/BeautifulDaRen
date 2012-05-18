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

@interface MineEditingViewController()

@property (retain, nonatomic) IBOutlet UIButton * updateAvatarButton;

@end

@implementation MineEditingViewController
@synthesize updateAvatarButton = _updateAvatarButton;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:@"返回"]];
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
    switch (section) {
        case 0:
        case 1:
        {
            number = 1;
            break;
        }
        case 2:
        {
            number = 4;
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
            ((MyInfoTopViewCell*)cell).avatarImageView.image = [UIImage imageNamed:@"item_fake"];
            ((MyInfoTopViewCell*)cell).rightImageView.image = [UIImage imageNamed:@"next_flag"];
            _updateAvatarButton =  ((MyInfoTopViewCell*)cell).updateAvatarButton;
            ((MyInfoTopViewCell*)cell).delegate = self;
        }
    }
    else if(section == 1)
    {
        // TODO 
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.0f)] autorelease];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 40, 40)];
        label.text = @"性别";
        [cell addSubview:label];
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    else if(section == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:3];
        }
        switch ([indexPath row]) {
            case 0:
            {
                ((ButtonViewCell*)cell).leftLabel.text = NSLocalizedString(@"nickname", @"");
                break;
            }
            case 1:
            {
                ((ButtonViewCell*)cell).leftLabel.text = NSLocalizedString(@"brief", @"");
                break;
            }
            case 2:
            {
                ((ButtonViewCell*)cell).leftLabel.text = NSLocalizedString(@"city", @"");
                break;
            }
            case 3:
            {
                ((ButtonViewCell*)cell).leftLabel.text = NSLocalizedString(@"privacy", @"");
                break;
            }   
        }
        ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"next_flag"];
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
            height = 78.0f;
            break;
        }
        case 1:
        {
            height = 40.0f;
            break;
        }
        case 2:
        {
            height = 60.0f;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
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
