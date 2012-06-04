//
//  WeiboDetailViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboDetailViewController.h"
#import "ViewHelper.h"
#import "ViewConstants.h"
#import "WeiboForwardCommentViewController.h"
#import "WeiboComposerViewController.h"
#import "ForwardCommentListViewController.h"
#import "FullImageViewController.h"
#import "FriendDetailViewController.h"
#import "iToast.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 280.0f
#define CELL_CONTENT_MARGIN 5.0f

@interface WeiboDetailViewController ()

@property (nonatomic, retain) NSString * weiboContent;

@end

@implementation WeiboDetailViewController

@synthesize userId = _userId;
@synthesize detailScrollView = _detailScrollView;
@synthesize weiboContent = _weiboContent;
@synthesize forwardedButton, commentButton, favourateButton;
@synthesize contentLabel = _contentLabel;
@synthesize avatarImageView = _avatarImageView;
@synthesize weiboAttachedImageView = _weiboAttachedImageView;
@synthesize timestampLabel = _timestampLabel;
@synthesize weiboAttachedImageButton = _weiboAttachedImageButton;

- (void)dealloc
{
    [_detailScrollView release];
    [_userId release];
    [_weiboContent release];
    [_avatarImageView release];
    [_weiboAttachedImageView release];
    [_timestampLabel release];
    [_weiboAttachedImageButton release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:@"返回"]];
        
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:@"刷新"]];       
        self.navigationItem.title = @"微博详情";
        
        //Content for test
        _weiboContent = [[NSString alloc] initWithString:@"我最近买了一双鞋子，很漂亮，你看看吧!"];
        
        UIToolbar *tempToolbar = [[[UIToolbar alloc]initWithFrame:CGRectMake(0,372, 320,44)] autorelease];
  
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

//        UIBarButtonItem *buyButtonItem = [ViewHelper getToolBarItemOfImageName:@"toolbar购买22x22" target:self action:@selector(onBuy)];

        UIBarButtonItem *refreshButtonItem = [ViewHelper getToolBarItemOfImageName:@"toolbar_refresh_icon" target:self action:@selector(onRefresh)];
        

        UIBarButtonItem *forwardButtonItem = [ViewHelper getToolBarItemOfImageName:@"toolbar_forward_icon" target:self action:@selector(onForward)];

        UIBarButtonItem *commentButtonItem = [ViewHelper getToolBarItemOfImageName:@"toolbar_comment_icon" target:self action:@selector(onComment)];

        UIBarButtonItem *favourateButtonItem = [ViewHelper getToolBarItemOfImageName:@"toolbar_favourate_icon" target:self action:@selector(onFavourate)];
        
        NSArray *barItems = [[NSArray alloc]initWithObjects:flexible, 
                                                            refreshButtonItem, 
                                                            flexible,
                                                            forwardButtonItem,
                                                            flexible,
                                                            commentButtonItem, 
                                                            flexible, 
                                                            favourateButtonItem,
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

- (void)onBuy
{
    // TODO:
}

- (void)onForward
{
    WeiboForwardCommentViewController *forwardViewContoller = 
    [[[WeiboForwardCommentViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    forwardViewContoller.forwardMode = YES;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: forwardViewContoller];
 
    [self.navigationController presentModalViewController:navController animated:YES];

    [navController release];
}

- (void)onComment
{
    WeiboForwardCommentViewController *forwardViewContoller = 
    [[[WeiboForwardCommentViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    forwardViewContoller.forwardMode = NO;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: forwardViewContoller];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
}

- (void)onFavourate
{
    [[iToast makeText:@"收藏成功！"] show];
}

- (void)onRefresh
{
    [[iToast makeText:@"刷新成功！"] show];
}

-(IBAction)onCommentListButtonPressed:(id)sender
{
    ForwardCommentListViewController *commentListViewContoller = 
    [[[ForwardCommentListViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: commentListViewContoller];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
}

-(IBAction)onForwardButtonPressed:(id)sender
{
    [self onForward];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.favourateButton.frame = CGRectMake(self.favourateButton.frame.origin.x, self.weiboAttachedImageView.frame.origin.y + CGRectGetHeight(self.weiboAttachedImageView.frame) + CELL_CONTENT_MARGIN, self.favourateButton.frame.size.width, self.favourateButton.frame.size.height);

    self.forwardedButton.frame = CGRectMake(self.forwardedButton.frame.origin.x, self.favourateButton.frame.origin.y, self.forwardedButton.frame.size.width, self.forwardedButton.frame.size.height);

    self.commentButton.frame = CGRectMake(self.commentButton.frame.origin.x, self.favourateButton.frame.origin.y, self.commentButton.frame.size.width, self.commentButton.frame.size.height);
    
    self.contentLabel.text = self.weiboContent;
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.favourateButton.frame.origin.y + CGRectGetHeight(self.favourateButton.frame) + CELL_CONTENT_MARGIN, self.contentLabel.frame.size.width, [ViewHelper getHeightOfText:self.weiboContent ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH]);
    
    // Custom initialization
    [_detailScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.contentLabel.frame.origin.y + CGRectGetHeight(self.contentLabel.frame) + 150)];
    
    [self.avatarImageView setImage:[UIImage imageNamed:@"weibo_sample3"]];
    [self.weiboAttachedImageView setImage:[UIImage imageNamed:@"weibo_sample2"]];
    
    self.weiboAttachedImageButton.frame = self.weiboAttachedImageView.frame;
    
    self.timestampLabel.text = @"一小时前";
    [self.timestampLabel setTextColor:[UIColor purpleColor]];

}

- (void)viewDidUnload
{
    self.weiboAttachedImageView = nil;
    self.avatarImageView = nil;
    self.weiboContent = nil;
    self.contentLabel = nil;
    self.detailScrollView = nil;
    self.userId = nil;
    self.forwardedButton = nil;
    self.commentButton = nil;
    self.favourateButton = nil;
    self.timestampLabel = nil;
    self.weiboAttachedImageButton = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)onBackButtonClicked {
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)onRefreshButtonClicked {
    [[iToast makeText:@"刷新成功！"] show];
}

-(IBAction)onImageButtonPressed:(id)sender
{
    [FullImageViewController showImage:[UIImage imageNamed:@"weibo_sample2"]inNavigationController:self.navigationController];
}

-(IBAction)onBrandButtonPressed:(id)sender
{
    FriendDetailViewController * friendDetailViewController = [[[FriendDetailViewController alloc] initWithNibName:@"FriendDetailViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:friendDetailViewController animated:YES];
}

-(IBAction)onBusinessButtonPressed:(id)sender
{
    FriendDetailViewController * friendDetailViewController = [[[FriendDetailViewController alloc] initWithNibName:@"FriendDetailViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:friendDetailViewController animated:YES];
}
@end
