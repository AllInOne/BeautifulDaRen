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
#import "PrivateLetterDetailViewController.h"
#import "BSDKManager.h"
#import "UIImageView+WebCache.h"
#import "iToast.h"

#define PRIVATE_LETTER_PAGE_SIZE    (20)

@interface PrivateLetterViewController()

@property (nonatomic, retain) NSMutableArray * relatedUsers;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isAllRetrieved;

- (void)refreshData;

@end

@implementation PrivateLetterViewController
@synthesize relatedUsers = _relatedUsers;
@synthesize privateLetterTableView = _privateLetterTableView;
@synthesize currentIndex = _currentIndex;
@synthesize footerView = _footerView;
@synthesize footerButton = _footerButton;
@synthesize loadingActivityIndicator = _loadingActivityIndicator;
@synthesize isRefreshing = _isRefreshing;
@synthesize isAllRetrieved = _isAllRetrieved;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];       
        self.navigationItem.title = NSLocalizedString(@"private_letter", @"private_letter");
        [self.view setHidden:NO];
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
    
    _currentIndex = 1;
    
    [_privateLetterTableView setDelegate:self];
    [_privateLetterTableView setDataSource:self];
    
    self.relatedUsers = [NSMutableArray arrayWithCapacity:2 * PRIVATE_LETTER_PAGE_SIZE];
    
    [self refreshData];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.relatedUsers = nil;
    self.privateLetterTableView = nil;
    self.footerButton = nil;
    self.footerView = nil;
    self.loadingActivityIndicator = nil;
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

- (void)refreshData
{
    [self.footerView setHidden:NO];
    [self.loadingActivityIndicator startAnimating];
    [self.footerButton setTitle:NSLocalizedString(@"loading_more", @"loading_more") forState:UIControlStateNormal];
    
    self.isRefreshing = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];

    [[BSDKManager sharedManager] getPrivateMsgUserListByType:1
                                                    pageSize:PRIVATE_LETTER_PAGE_SIZE
                                                   pageIndex:_currentIndex andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                                       if (K_BSDK_IS_RESPONSE_OK(data)) {
                                                           NSArray * users = [data objectForKey:K_BSDK_USERLIST];
                                                           [_relatedUsers addObjectsFromArray:users];                                                       
                                                           
                                                           if ([users count] < PRIVATE_LETTER_PAGE_SIZE) {
                                                               self.isAllRetrieved = YES;
                                                           }

                                                           [self.loadingActivityIndicator stopAnimating];
                                                           
                                                           
                                                           self.isRefreshing = NO;
                                                           self.currentIndex++;
                                                           
                                                           if ((self.relatedUsers == nil) || ([self.relatedUsers count] == 0)) {
                                                               [self.footerButton setTitle:NSLocalizedString(@"no_message", @"no_message") forState:UIControlStateNormal];
                                                               [self.loadingActivityIndicator setHidden:YES];
                                                           }
                                                           else
                                                           {
                                                               [self.footerView setHidden:YES];
                                                               [self.privateLetterTableView reloadData];
                                                           }
                                                       }
                                                       else
                                                       {
                                                           self.isAllRetrieved = YES;
                                                           [[iToast makeText:NSLocalizedString(@"server_request_error", @"server_request_error")] show];
                                                       }
                                                       
                                                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                       [self.navigationItem.rightBarButtonItem setEnabled:YES];
                                                   }];

}

#pragma mark - Table view data source

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_relatedUsers count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([indexPath row] == ([self.relatedUsers count] - 1)) && !self.isAllRetrieved) {
        if (!self.isRefreshing) {
            [self refreshData];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *privateLetterViewCellIdentifier = @"PrivateLetterViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:privateLetterViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:privateLetterViewCellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    NSDictionary * userDict = [_relatedUsers objectAtIndex:[indexPath row]];
    PrivateLetterViewCell * privateLetterCell = ((PrivateLetterViewCell*)cell);
    
    NSString * avatarImageUrl = [userDict objectForKey:K_BSDK_PICTURE_65];
    if (avatarImageUrl && [avatarImageUrl length]) {
        [privateLetterCell.avatarImage setImageWithURL:[NSURL URLWithString:avatarImageUrl] placeholderImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:userDict]]];
    }
    else
    {
        [privateLetterCell.avatarImage setImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:userDict]]];
    }

    privateLetterCell.nameLabel.text = [userDict objectForKey:K_BSDK_USERNAME];
    privateLetterCell.timeLabel.text = [ViewHelper intervalSinceNow:[userDict objectForKey:K_BSDK_CREATETIME]];
    privateLetterCell.detailView.text = @"this is a long long long longa long long long longa long long long longa long long long long long long long  view";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    CGFloat textViewHeight = [ViewHelper getHeightOfText:privateLetterCell.detailView.text ByFontSize:privateLetterCell.detailView.font.pointSize contentWidth:privateLetterCell.detailView.frame.size.width] + TEXT_VIEW_MARGE_HEIGHT;
////    privateLetterCell.detailView.frame = CGRectMake(privateLetterCell.detailView.frame.origin.x, privateLetterCell.detailView.frame.origin.y, privateLetterCell.detailView.frame.size.width, textViewHeight);
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
    return  60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * userDict = [_relatedUsers objectAtIndex:[indexPath row]];
    PrivateLetterDetailViewController * privateLetterDetailViewController = [[PrivateLetterDetailViewController alloc]
                                                         initWithNibName:@"PrivateLetterDetailViewController"
                                                         bundle:nil];
    privateLetterDetailViewController.userId = [userDict objectForKey:K_BSDK_UID];
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: privateLetterDetailViewController];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    [navController release];
    [privateLetterDetailViewController release];
}

@end
