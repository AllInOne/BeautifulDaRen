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

#define FONT_SIZE           (14.0f)
#define CELL_CONTENT_WIDTH  (240.0f)
#define CELL_CONTENT_Y_OFFSET  (40.0f)
#define CELL_MIN_HEIGHT     (60.0f)


@interface ForwardCommentListViewController ()

@property (nonatomic, retain) NSArray * forwardOrCommentList;

-(void)refreshData;
@end

@implementation ForwardCommentListViewController

@synthesize forwardOrCommentListTableView = _forwardOrCommentListTableView;
@synthesize forwardOrCommentList = _forwardOrCommentList;

- (void)dealloc
{
    [_forwardOrCommentList release];
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
    if(_forwardOrCommentList)
    {
        [_forwardOrCommentList release];
    }
    
    _forwardOrCommentList = [[[DataManager sharedManager] getCommentOfLocalIdentityWithLimit:9 finishBlock:^(NSError *error) {
        NSLog(@"get comment from DB with error:%@",error);
    }] copy];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.forwardOrCommentListTableView setDelegate:self];
    [self.forwardOrCommentListTableView setDataSource:self];
    // Do any additional setup after loading the view from its nib.
    
    [self refreshData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self refreshData];
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

    Comment * comment = [self.forwardOrCommentList objectAtIndex:[indexPath row]];
    cell.username.text = comment.personName;
    [cell.userAvatar setImage:[UIImage imageNamed:@"avatar_icon"]];
    cell.timestamp.text = @"1分钟";
    cell.content.text = comment.detail;
    
    CGFloat contentHeight = [ViewHelper getHeightOfText:comment.detail ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH];
    
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
    Comment * comment = [self.forwardOrCommentList objectAtIndex:[indexPath row]];
    CGFloat contentHeight = [ViewHelper getHeightOfText:comment.detail ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH];
    
    contentHeight += CELL_CONTENT_Y_OFFSET;
    
    return MAX(contentHeight, CELL_MIN_HEIGHT);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO:
}
                                 
@end
