//
//  ForwardCommentListViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForwardCommentListViewController.h"
#import "comment.h"
#import "ViewHelper.h"
#import "DataConstants.h"
#import "ForwardCommentTableViewCell.h"
#import "DataManager.h"
#import "BSDKManager.h"
#import "BSDKDefines.h"

#define FONT_SIZE           (14.0f)
#define CELL_CONTENT_WIDTH  (240.0f)
#define CELL_CONTENT_Y_OFFSET  (40.0f)
#define CELL_MIN_HEIGHT     (60.0f)

#define INITIAL_SIZE        (100)


@interface ForwardCommentListViewController ()

@property (nonatomic, retain) NSMutableArray * forwardOrCommentList;

-(void)refreshData;
@end

@implementation ForwardCommentListViewController

@synthesize forwardOrCommentListTableView = _forwardOrCommentListTableView;
@synthesize forwardOrCommentList = _forwardOrCommentList;
@synthesize relatedBlogId = _relatedBlogId;

- (void)dealloc
{
    [_forwardOrCommentList release];
    [_relatedBlogId release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
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
}

-(void)refreshData
{
    [[BSDKManager sharedManager] getCommentListOfWeibo:self.relatedBlogId pageSize:20 pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        [self.forwardOrCommentList addObjectsFromArray:[data objectForKey:K_BSDK_RESPONSE_COMMENTLIST]];
        [self.forwardOrCommentListTableView reloadData];
    }];    
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.forwardOrCommentListTableView setDelegate:self];
    [self.forwardOrCommentListTableView setDataSource:self];
    // Do any additional setup after loading the view from its nib.
    self.forwardOrCommentList = [NSMutableArray arrayWithCapacity:INITIAL_SIZE];
    [self refreshData];
}

-(void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.relatedBlogId = nil;
    self.forwardOrCommentList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Scroll view
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self refreshData];
}

/* UITableViewDelegate/UITableViewDataSource delegate methods */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * forwardCommentCellIdentifier = @"ForwardCommentTableViewCell";

    ForwardCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:forwardCommentCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:forwardCommentCellIdentifier owner:self options:nil] objectAtIndex:0];
    }

    NSDictionary * comment = [self.forwardOrCommentList objectAtIndex:[indexPath row]];
    NSDictionary * userInfoDict = [comment objectForKey:K_BSDK_USER_INFO];
    if (userInfoDict) {
        cell.username.text = [userInfoDict objectForKey:K_BSDK_USERNAME];
    }

    [cell.userAvatar setImage:[UIImage imageNamed:@"avatar_icon"]];
    cell.timestamp.text = @"1分钟";
    cell.content.text = [comment objectForKey:K_BSDK_CONTENT];
    
    CGFloat contentHeight = [ViewHelper getHeightOfText:[comment objectForKey:K_BSDK_CONTENT] ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH];
    
    cell.content.frame = CGRectMake(cell.content.frame.origin.x, CELL_CONTENT_Y_OFFSET, cell.content.frame.size.width, contentHeight);
    
    [cell.content setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_forwardOrCommentList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * comment = [self.forwardOrCommentList objectAtIndex:[indexPath row]];
    CGFloat contentHeight = [ViewHelper getHeightOfText:[comment objectForKey:K_BSDK_CONTENT] ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH];
    
    contentHeight += CELL_CONTENT_Y_OFFSET;
    
    return MAX(contentHeight, CELL_MIN_HEIGHT);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO:
}
                                 
@end
