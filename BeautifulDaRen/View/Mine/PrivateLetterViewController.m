//
//  PrivateLetterViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/17/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "PrivateLetterViewController.h"
#import "PrivateLetterViewCell.h"
#import "ViewHelper.h"
#import "ViewConstants.h"

@interface PrivateLetterViewController()

@property (retain, nonatomic) NSMutableDictionary * fakeLetters;
- (void) loadFakeLetters;
@end

@implementation PrivateLetterViewController
@synthesize fakeLetters = _fakeLetters;

- (void) loadFakeLetters
{
    if(_fakeLetters)
    {
        _fakeLetters = nil;
    }
    NSDictionary * letter1 = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    _fakeLetters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                    letter1, nil];
    [_fakeLetters autorelease];
}

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

- (void) onBackButtonClicked
{
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) onRefreshButtonClicked
{
    [ViewHelper showSimpleMessage:@"refresh button click" withTitle:nil withButtonText:@"ok"];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"private_letter", @"private_letter")];
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];
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

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *privateLetterViewCellIdentifier = @"PrivateLetterViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:privateLetterViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:privateLetterViewCellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    PrivateLetterViewCell * privateLetterCell = ((PrivateLetterViewCell*)cell);
    privateLetterCell.avatarImage.image = [UIImage imageNamed:@"avatar_big"];
    privateLetterCell.nameLabel.text = @"Adam Lambert";
    privateLetterCell.timeLabel.text = @"22分钟前";
    privateLetterCell.detailView.text = @"this is a long long long longa long long long longa long long long longa long long long long long long long  view";
    CGFloat textViewHeight = [ViewHelper getHeightOfText:privateLetterCell.detailView.text ByFontSize:privateLetterCell.detailView.font.pointSize contentWidth:privateLetterCell.detailView.frame.size.width] + TEXT_VIEW_MARGE_HEIGHT;
    privateLetterCell.detailView.frame = CGRectMake(privateLetterCell.detailView.frame.origin.x, privateLetterCell.detailView.frame.origin.y, privateLetterCell.detailView.frame.size.width, textViewHeight);
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
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  200;
}

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

@end
