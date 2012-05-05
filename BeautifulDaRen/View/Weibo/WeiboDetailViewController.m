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

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface WeiboDetailViewController ()

@property (nonatomic, retain) NSString * weiboContent;
@end

@implementation WeiboDetailViewController

@synthesize userInforCellView = _userInforCellView;
@synthesize userId = _userId;
@synthesize detailScrollView = _detailScrollView;
@synthesize weiboContent = _weiboContent;
@synthesize forwardedButton, commentButton, favourateButton;
@synthesize contentLabel = _contentLabel;

- (void)dealloc
{
    [_userInforCellView release];
    [_detailScrollView release];
    [_userId release];
    [_weiboContent release];
    
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setBackgroundImage:[UIImage imageNamed:@"顶部按钮50x29.png"] forState:UIControlStateNormal];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(onBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        backButton.frame = CGRectMake(0, 0, 50, 30);
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        
        self.navigationItem.title = @"微博详情";
        
        //Content for test
        _weiboContent = [[NSString alloc] initWithString:@"start我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！我最近买了一双鞋子，很漂亮，你看看吧！"];
        
        UIToolbar *tempToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,372, 320,44)];
        //空格
        
        // TODO: use custom pictures
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        
        UIBarButtonItem *buyButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onBuy)];
        UIBarButtonItem *forwardButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onForward)];
        UIBarButtonItem *commentButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(onComment)];      
        UIBarButtonItem *favourateButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onFavourate)];
        UIBarButtonItem *moreButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onMore)]; 
        
        NSArray *barItems = [[NSArray alloc]initWithObjects:forwardButtonItem,flexible,commentButtonItem,flexible,favourateButtonItem,flexible,moreButtonItem, flexible, buyButtonItem, nil];
        
        tempToolbar.items= barItems;
        tempToolbar.tintColor = [UIColor blackColor];
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
    // TODO:
}

- (void)onMore
{
    // TODO:
}

-(IBAction)onCommentListButtonPressed:(id)sender
{
    ForwardCommentListViewController *commentListViewContoller = 
    [[[ForwardCommentListViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: commentListViewContoller];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentLabel.text = self.weiboContent;
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, [ViewHelper getHeightOfText:self.weiboContent ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH]);
    
    self.favourateButton.frame = CGRectMake(self.favourateButton.frame.origin.x, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height, self.favourateButton.frame.size.width, self.favourateButton.frame.size.height);

    self.forwardedButton.frame = CGRectMake(self.forwardedButton.frame.origin.x, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height, self.forwardedButton.frame.size.width, self.forwardedButton.frame.size.height);

    self.commentButton.frame = CGRectMake(self.commentButton.frame.origin.x, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height, self.commentButton.frame.size.width, self.commentButton.frame.size.height);
    
    // Custom initialization
    [_detailScrollView setContentSize:CGSizeMake(320, self.commentButton.frame.origin.y + 180)];

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

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

@end
