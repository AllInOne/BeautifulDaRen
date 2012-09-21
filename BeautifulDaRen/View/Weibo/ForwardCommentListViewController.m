//
//  ForwardCommentListViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForwardCommentListViewController.h"
#import "ViewHelper.h"
#import "ViewConstants.h"
#import "ForwardCommentTableViewCell.h"
#import "BSDKManager.h"
#import "BSDKDefines.h"
#import "WeiboForwardCommentViewController.h"
#import "FriendDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "iToast.h"

#define FONT_SIZE           (14.0f)
#define CELL_CONTENT_WIDTH  (240.0f)
#define CELL_CONTENT_Y_OFFSET  (40.0f)
#define CELL_MIN_HEIGHT     (60.0f)

#define INITIAL_SIZE        (100)

#define COMMENT_PAGE_SIZE   (20)

@interface ForwardCommentListViewController ()

@property (nonatomic, retain) NSMutableArray * forwardOrCommentList;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isAllRetrieved;
@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, assign) NSInteger currentCommentIndex;
@property (nonatomic, retain) NSString * relatedCommentId;
@property (nonatomic, retain) NSString * relatedCommentUserName;

-(void)refreshData;
-(void)startCommentListAction;
@end

@implementation ForwardCommentListViewController

@synthesize forwardOrCommentListTableView = _forwardOrCommentListTableView;
@synthesize forwardOrCommentList = _forwardOrCommentList;
@synthesize relatedBlogId = _relatedBlogId;
@synthesize relatedCommentId = _relatedCommentId;
@synthesize relatedCommentUserName = _relatedCommentUserName;
@synthesize isRefreshing = _isRefreshing;
@synthesize footView = _footView;
@synthesize footViewButton = _footViewButton;
@synthesize footViewActivityIndicator = _footViewActivityIndicator;
@synthesize currentPageIndex = _currentPageIndex;
@synthesize isAllRetrieved = _isAllRetrieved;
@synthesize currentCommentIndex = _currentCommentIndex;

- (void)dealloc
{
    [_forwardOrCommentList release];
    [_relatedBlogId release];
    [_relatedCommentId release];
    [_relatedCommentUserName release];
    [_footView release];
    [_footViewActivityIndicator release];
    [_footViewButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        if ( [[BSDKManager sharedManager] isLogin]) {
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onPostCommentButtonClicked) title:NSLocalizedString(@"post_comment", @"post_comment")]];
        }

        [self.navigationItem setTitle:NSLocalizedString(@"comment_list", @"comment_list")];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

-(void)onConfirmed:(WeiboForwardCommentViewController*)view
{
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_SHOWWAITOVERLAY object:self];

    __block NSInteger doneCount = 0;
    __block NSInteger doneCountExpected = 1;
    __block NSString * errorMsg = nil;

    processDoneWithDictBlock doneBlock = ^(AIO_STATUS status, NSDictionary * data){

        doneCount++;
        if (doneCount == doneCountExpected) {
            [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_HIDEWAITOVERLAY object:self];
            if ([data objectForKey:K_BSDK_RESPONSE_STATUS] && !K_BSDK_IS_RESPONSE_OK(data)) {
                errorMsg = K_BSDK_GET_RESPONSE_MESSAGE(data);
            }

            if (errorMsg == nil)
            {
                [ViewHelper showSimpleMessage:NSLocalizedString(@"send_succeed", @"send_succeed") withTitle:nil withButtonText:NSLocalizedString(@"ok", @"ok")];
                self.currentPageIndex = 1;
                [self.forwardOrCommentList removeAllObjects];
                [self refreshData];
            }
            else
            {
                [ViewHelper showSimpleMessage:errorMsg withTitle:nil withButtonText:NSLocalizedString(@"ok", @"ok")];
            }
        }

    };

    if (view.forwardMode || (!view.forwardMode && view.isCheckBoxChecked))
    {
        [[BSDKManager sharedManager] rePostWeiboById:self.relatedBlogId WithText:view.weiboContentTextView.text andDoneCallback:doneBlock];

        doneCountExpected++;
    };

    if (!view.forwardMode || (view.forwardMode && view.isCheckBoxChecked))
    {
        NSMutableString * commentText = [view.weiboContentTextView.text mutableCopy];
        if(self.relatedCommentId)
        {
            commentText = [NSMutableString stringWithFormat:@"回复 @%@ : %@",self.relatedCommentUserName, commentText];
        }
        [[BSDKManager sharedManager] sendComment:commentText toWeibo:self.relatedBlogId toComment:self.relatedCommentId andDoneCallback:doneBlock];
    }
}

- (void)onPostCommentButtonClicked {
    WeiboForwardCommentViewController *forwardViewContoller =
    [[WeiboForwardCommentViewController alloc] initWithNibName:nil bundle:nil];
    forwardViewContoller.forwardMode = NO;
    [forwardViewContoller setDelegate:self];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: forwardViewContoller];

    [self.navigationController presentModalViewController:navController animated:YES];

    [navController release];
    [forwardViewContoller release];
}

- (void)onBackButtonClicked {
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)refreshData
{
    self.isRefreshing = YES;
    [self.footViewActivityIndicator setHidden:NO];
    [self.footViewActivityIndicator startAnimating];
    [self.footViewButton setTitle:NSLocalizedString(@"more_comment", @"more_comment") forState:UIControlStateNormal];

    [[BSDKManager sharedManager] getCommentListOfWeibo:self.relatedBlogId pageSize:COMMENT_PAGE_SIZE pageIndex:self.currentPageIndex andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        if (K_BSDK_IS_RESPONSE_OK(data)) {
            NSArray * commentList = [data objectForKey:K_BSDK_COMMENTLIST];
            [self.forwardOrCommentList addObjectsFromArray:commentList];
            [self.forwardOrCommentListTableView reloadData];
            self.isRefreshing = NO;
            [self.footViewActivityIndicator stopAnimating];
            [self.footViewActivityIndicator setHidden:YES];

            if ([self.forwardOrCommentList count] == 0) {
                [self.footViewButton setTitle:NSLocalizedString(@"no_comment", @"no_comment") forState:UIControlStateNormal];
            }
            else if ([commentList count] < COMMENT_PAGE_SIZE)
            {
                self.isAllRetrieved = YES;
                [self.footView setHidden:YES];
            }

            self.currentPageIndex++;
        }
        else
        {
            [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
        }

    }];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.forwardOrCommentListTableView setDelegate:self];
    [self.forwardOrCommentListTableView setDataSource:self];
    self.forwardOrCommentListTableView.tableFooterView = self.footView;
    self.relatedCommentId = nil;
    self.relatedCommentUserName = nil;
    self.currentPageIndex = 1;
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
    self.forwardOrCommentList = nil;
    self.footView = nil;
    self.footViewActivityIndicator = nil;
    self.footViewButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)startCommentListAction
{
    UIActionSheet * commentListActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                         delegate:self
                                                                cancelButtonTitle:nil
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:nil];

    commentListActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    commentListActionSheet.tag = ACTIONSHEET_COMMENT_LIST;

    [commentListActionSheet addButtonWithTitle:COMMENT_LIST_VIEW_PROFILE];

    if ( [[BSDKManager sharedManager] isLogin]) {
        [commentListActionSheet addButtonWithTitle:COMMENT_LIST_REPLY_COMMNET];
    }

    [commentListActionSheet setDestructiveButtonIndex:[commentListActionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"cancel")]];
    [commentListActionSheet showInView:self.view];

    [commentListActionSheet release];
}

#pragma mark Scroll view
/* UITableViewDelegate/UITableViewDataSource delegate methods */

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([indexPath row] == ([self.forwardOrCommentList count] - 1)) && !self.isAllRetrieved) {
        if (!self.isRefreshing) {
            [self refreshData];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * forwardCommentCellIdentifier = @"ForwardCommentTableViewCell";

    ForwardCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:forwardCommentCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:forwardCommentCellIdentifier owner:self options:nil] objectAtIndex:0];
    }

    NSDictionary * comment = [self.forwardOrCommentList objectAtIndex:[indexPath row]];
    NSDictionary * userInfoDict = [comment objectForKey:K_BSDK_USERINFO];
    if (userInfoDict) {
        cell.username.text = [userInfoDict objectForKey:K_BSDK_USERNAME];
    }

    NSString * avatarUrlString = [userInfoDict objectForKey:K_BSDK_PICTURE_65];
    if (avatarUrlString && [avatarUrlString length]) {
        [cell.userAvatar setImageWithURL:[NSURL URLWithString:avatarUrlString]];

    }
    else
    {
        [cell.userAvatar setImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:userInfoDict]]];
    }

    cell.timestamp.text = [ViewHelper intervalSinceNow:[comment objectForKey:K_BSDK_CREATETIME]];
    cell.content.text = [comment objectForKey:K_BSDK_CONTENT];

    CGFloat contentHeight = [ViewHelper getHeightOfText:[comment objectForKey:K_BSDK_CONTENT] ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH];

    cell.content.frame = CGRectMake(cell.content.frame.origin.x, CELL_CONTENT_Y_OFFSET, cell.content.frame.size.width, contentHeight);

    [cell.content setFont:[UIFont systemFontOfSize:FONT_SIZE]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

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
    self.currentCommentIndex = [indexPath row];
    self.relatedCommentId = [[self.forwardOrCommentList objectAtIndex:self.currentCommentIndex] valueForKey:K_BSDK_UID];
    self.relatedCommentUserName = [[[self.forwardOrCommentList objectAtIndex:self.currentCommentIndex] valueForKey:K_BSDK_USERINFO] objectForKey:K_BSDK_USERNAME];
    [self startCommentListAction];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet destructiveButtonIndex])
    {
        switch (actionSheet.tag)
        {
            case ACTIONSHEET_COMMENT_LIST:
            {
                NSString *pressed = [actionSheet buttonTitleAtIndex:buttonIndex];

                if ([pressed isEqualToString:COMMENT_LIST_VIEW_PROFILE])
                {
                    FriendDetailViewController * friendDetailController =
                    [[FriendDetailViewController alloc] initWithDictionary:[[self.forwardOrCommentList objectAtIndex:self.currentCommentIndex] objectForKey:K_BSDK_USERINFO]];
                    [self.navigationController pushViewController:friendDetailController animated:YES];
                    [friendDetailController release];
                }
                else if ([pressed isEqualToString:COMMENT_LIST_REPLY_COMMNET])
                {
                    [self onPostCommentButtonClicked];
                }
            }
            default:
                break;
        }
    }
}

@end
