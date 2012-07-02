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
#import "MapViewController.h"
#import "BSDKDefines.h"
#import "BSDKManager.h"
#import "UIImageView+WebCache.h"
#import "FriendListViewController.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 280.0f
#define CELL_CONTENT_MARGIN 5.0f

#define CELL_CONTENT_MARGIN_BIG 15.0f

#define IMAGE_WIDTH     (210.0f)

#define PRICE_BUTTON_Y_OFFSET     (50.0f)

#define MAP_VIEW_WIDTH      (280.0f)
#define MAP_VIEW_HEIGHT     (60.0f)
#define MAP_VIEW_X_OFFSET   ((SCREEN_WIDTH - MAP_VIEW_WIDTH)/2)


@interface WeiboDetailViewController ()

@property (nonatomic, retain) MapViewController * mapViewController;
@property (nonatomic, retain) NSString * weiboContent;
@property (nonatomic, retain) UIToolbar * toolbar;
- (void)refreshView;
- (void)addToolbar;
- (void)onRefreshButtonClicked;

- (void)getWeiboDataFromResponse;
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
@synthesize mapViewController = _mapViewController;
@synthesize weiboData = _weiboData;
@synthesize toolbar = _toolbar;
@synthesize merchantLable = _merchantLable;
@synthesize priceButton = _priceButton;
@synthesize brandLable = _brandLable;
@synthesize usernameLabel = _usernameLabel;
@synthesize weiboId = _weiboId;

- (void)dealloc
{
    [_detailScrollView release];
    [_userId release];
    [_weiboContent release];
    [_avatarImageView release];
    [_weiboAttachedImageView release];
    [_timestampLabel release];
    [_weiboAttachedImageButton release];
    [_mapViewController release];
    [_weiboData release];
    [_toolbar release];
    [favourateButton release];
    [commentButton release];
    [forwardedButton release];
    [_contentLabel release];
    [_brandLable release];
    [_merchantLable release];
    [_priceButton release];
    [_usernameLabel release];
    [_weiboId release];
    
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary*)weiboDict
{
    self = [self init];
    if (self)
    {
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];       
        self.navigationItem.title = NSLocalizedString(@"weibo_detail", @"weibo_detail");
        
        
        self.weiboData = weiboDict;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];       
        self.navigationItem.title = NSLocalizedString(@"weibo_detail", @"weibo_detail");
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
    [[WeiboForwardCommentViewController alloc] initWithNibName:nil bundle:nil];
    forwardViewContoller.forwardMode = YES;
    [forwardViewContoller setDelegate:self];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: forwardViewContoller];
 
    [self.navigationController presentModalViewController:navController animated:YES];

    [navController release];
    [forwardViewContoller release];
}

- (void)onComment
{
    WeiboForwardCommentViewController *forwardViewContoller = 
    [[WeiboForwardCommentViewController alloc] initWithNibName:nil bundle:nil];
    forwardViewContoller.forwardMode = NO;
    [forwardViewContoller setDelegate:self];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: forwardViewContoller];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
    [forwardViewContoller release];
}

-(void)onConfirmed:(WeiboForwardCommentViewController*)view
{
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_SHOWWAITOVERLAY object:self];
    
    __block NSInteger doneCount = 0;
    __block NSInteger doneCountExpected = 0;
    __block NSString * errorMsg = nil;
    
    processDoneWithDictBlock doneBlock = ^(AIO_STATUS status, NSDictionary * data){
        NSLog(@"Send done: %d, %@", status, data);
        
        doneCount++;
        if (doneCount == doneCountExpected) {
            [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_HIDEWAITOVERLAY object:self];
            if ([data objectForKey:K_BSDK_RESPONSE_STATUS] && !K_BSDK_IS_RESPONSE_OK(data)) {
                errorMsg = K_BSDK_GET_RESPONSE_MESSAGE(data);
            }
            
            if (errorMsg == nil)
            {
                [ViewHelper showSimpleMessage:NSLocalizedString(@"send_succeed", @"send_succeed") withTitle:nil withButtonText:NSLocalizedString(@"ok", @"ok")];
                [self onRefreshButtonClicked];
            }
            else
            {
                [ViewHelper showSimpleMessage:errorMsg withTitle:nil withButtonText:NSLocalizedString(@"ok", @"ok")];
            }
        }
        
    };
    
    
    if (view.forwardMode || (!view.forwardMode && view.isCheckBoxChecked))
    {
        [[BSDKManager sharedManager] rePostWeiboById:[self.weiboData objectForKey:K_BSDK_UID] WithText:view.weiboContentTextView.text andDoneCallback:doneBlock];
        
        doneCountExpected++;
    };
    
    if (!view.forwardMode || (view.forwardMode && view.isCheckBoxChecked)) {
        [[BSDKManager sharedManager] sendComment:view.weiboContentTextView.text toWeibo:[self.weiboData objectForKey:K_BSDK_UID] andDoneCallback:doneBlock];
        doneCountExpected++;
    }
}

- (void)onFavourate
{
    if (K_BSDK_IS_BLOG_FAVOURATE(self.weiboData)) {
        [[BSDKManager sharedManager] removeFavourateForWeibo:[self.weiboData objectForKey:K_BSDK_UID] andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
            
            if (K_BSDK_IS_RESPONSE_OK(data)) {
                [[iToast makeText:NSLocalizedString(@"cancel_favourate_succeed", @"cancel_favourate_succeed")] show];
                [self onRefreshButtonClicked];
            }
            else
            {
                [[iToast makeText:NSLocalizedString(@"cancel_favourate_failed", @"cancel_favourate_failed")] show];
            }

        }];
    }
    else
    {
        [[BSDKManager sharedManager] addFavourateForWeibo:[self.weiboData objectForKey:K_BSDK_UID] andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
            
            if (K_BSDK_IS_RESPONSE_OK(data)) {
                [[iToast makeText:NSLocalizedString(@"favourate_succeed", @"favourate_succeed")] show];
                [self onRefreshButtonClicked];
            }
            else
            {
                [[iToast makeText:NSLocalizedString(@"favourate_failed", @"favourate_failed")] show];
            }
            
        }];
    }
}

- (void)onRefresh
{
    [self onRefreshButtonClicked];
}

-(IBAction)onCommentListButtonPressed:(UIButton*)sender
{
    ForwardCommentListViewController *commentListViewContoller = 
    [[ForwardCommentListViewController alloc] initWithNibName:nil bundle:nil];
    
    commentListViewContoller.relatedBlogId = [self.weiboData objectForKey:K_BSDK_UID];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: commentListViewContoller];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
    [commentListViewContoller release];
}

-(IBAction)onForwardButtonPressed:(UIButton*)sender
{
    [self onForward];
}

-(IBAction)onFavorateListButtonPressed:(UIButton*)sender
{
    FriendListViewController * friendListViewController = [[FriendListViewController alloc]
                                                                                    initWithNibName:@"FriendListViewController"
                                                                                    bundle:nil
                                                                                    type:FriendListViewController_TYPE_FAV_ONE_BLOG
                                                                                    dictionary:self.weiboData];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: friendListViewController];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
    [friendListViewController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.weiboData) {
        [self refreshView];
    }
    else
    {
        UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activityIndicator.center = CGPointMake(SCREEN_WIDTH/2, 20);
        [activityIndicator startAnimating];
        
        [self.view addSubview:activityIndicator];
        
        [[BSDKManager sharedManager] getWeiboById:_weiboId
                                          andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                              [activityIndicator stopAnimating];
                                              [activityIndicator removeFromSuperview];
                                              [activityIndicator release];
                                              
                                              if (K_BSDK_IS_RESPONSE_OK(data)) {
                                                  NSDictionary * weiboInfo = [data objectForKey:K_BSDK_BLOGINFO];
                                                  NSDictionary * retweetedStatusInfo = [weiboInfo objectForKey:K_BSDK_RETWEET_STATUS];
                                                  if (retweetedStatusInfo && [retweetedStatusInfo count]) {
                                                      self.weiboData = retweetedStatusInfo;
                                                  }
                                                  else
                                                  {
                                                      self.weiboData = weiboInfo;
                                                  }
                                                  
                                                  [self refreshView];
                                              }
                                              else
                                              {
                                                  [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
                                              }
                                          }];
    }
    [self addToolbar];
}

- (void)viewDidUnload
{
    self.weiboAttachedImageView = nil;
    self.avatarImageView = nil;
    self.weiboContent = nil;
    self.contentLabel = nil;
    self.detailScrollView = nil;
    self.forwardedButton = nil;
    self.commentButton = nil;
    self.favourateButton = nil;
    self.timestampLabel = nil;
    self.weiboAttachedImageButton = nil;
    self.mapViewController = nil;
    self.weiboData = nil;
    self.merchantLable = nil;
    self.priceButton = nil;
    self.brandLable = nil;
    self.usernameLabel = nil;
    
    [self.toolbar removeFromSuperview];
    self.toolbar = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addToolbar
{
    UIToolbar *tempToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,372, 320,44)];
    
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
    [tabBarBg release];
    [barItems release];
    [tempToolbar release];
}

- (void)refreshView
{    
    // attach image
    NSInteger picWidth = [[self.weiboData objectForKey:K_BSDK_PICTURE_WIDTH] intValue];
    NSInteger picHeight = [[self.weiboData objectForKey:K_BSDK_PICTURE_HEIGHT] intValue];
    if (picWidth && picHeight) {
        UIImageView * placeholderImageView = [[UIImageView alloc] init];
        [placeholderImageView setImageWithURL:[NSURL URLWithString:[self.weiboData objectForKey:K_BSDK_PICTURE_102]]];                                          
        [self.weiboAttachedImageView setImageWithURL:[NSURL URLWithString:[self.weiboData objectForKey:K_BSDK_PICTURE_320]] placeholderImage:placeholderImageView.image];
        
        [placeholderImageView release];
        
        self.weiboAttachedImageView.frame = CGRectMake((SCREEN_WIDTH - IMAGE_WIDTH)/2, 
                                                       CGRectGetMinY(self.weiboAttachedImageView.frame), 
                                                       IMAGE_WIDTH, 
                                                       picHeight * IMAGE_WIDTH/picWidth);
    }

    //  buttons
    self.favourateButton.frame = CGRectMake(self.favourateButton.frame.origin.x, self.weiboAttachedImageView.frame.origin.y + CGRectGetHeight(self.weiboAttachedImageView.frame) + CELL_CONTENT_MARGIN_BIG, self.favourateButton.frame.size.width, self.favourateButton.frame.size.height);
    
    [self.favourateButton setTitle:[NSString stringWithFormat:@"    %d", [[self.weiboData objectForKey:K_BSDK_FAVOURATE_NUM] intValue]] forState:UIControlStateNormal];
    
    self.forwardedButton.frame = CGRectMake(self.forwardedButton.frame.origin.x, self.favourateButton.frame.origin.y, self.forwardedButton.frame.size.width, self.forwardedButton.frame.size.height);

    [self.forwardedButton setTitle:[NSString stringWithFormat:@"    %d", [[self.weiboData objectForKey:K_BSDK_FORWARD_NUM] intValue]] forState:UIControlStateNormal];
    
    self.commentButton.frame = CGRectMake(self.commentButton.frame.origin.x, self.favourateButton.frame.origin.y, self.commentButton.frame.size.width, self.commentButton.frame.size.height);
    
    [self.commentButton setTitle:[NSString stringWithFormat:@"    %d", [[self.weiboData objectForKey:K_BSDK_COMMENT_NUM] intValue]] forState:UIControlStateNormal];
    
    NSInteger yOffset = self.favourateButton.frame.origin.y + CGRectGetHeight(self.favourateButton.frame) + CELL_CONTENT_MARGIN;
    
    double longtitude = [[self.weiboData objectForKey:K_BSDK_LONGITUDE] doubleValue];
    double latitude = [[self.weiboData objectForKey:K_BSDK_LATITUDE] doubleValue];
    
    if ([self.weiboData objectForKey:K_BSDK_LATITUDE] && [self.weiboData objectForKey:K_BSDK_LONGITUDE] && (longtitude != 0) && (latitude != 0)) {
//        _mapViewController = [[MapViewController alloc] initWithName:@"test map name" description:nil latitude:[[self.weiboData objectForKey:K_BSDK_LATITUDE] floatValue] longitude:[[self.weiboData objectForKey:K_BSDK_LONGITUDE] floatValue] showSelf:NO];

        if (CLLocationCoordinate2DIsValid(CLLocationCoordinate2DMake(latitude, longtitude)))
        {
            if (_mapViewController) {
                [_mapViewController.view removeFromSuperview];
                [self setMapViewController:nil];
            }
            _mapViewController = [[MapViewController alloc] initWithName:@"test map name" description:nil latitude:latitude longitude:longtitude showSelf:NO];
            _mapViewController.view.frame = CGRectMake(MAP_VIEW_X_OFFSET, yOffset, MAP_VIEW_WIDTH, MAP_VIEW_HEIGHT);
            _mapViewController.navigationController.toolbarHidden = YES;
            
            [self.detailScrollView addSubview:_mapViewController.view];
            
            yOffset = _mapViewController.view.frame.origin.y + MAP_VIEW_HEIGHT * 2;
        }
    }
    
    //Content
    if ([self.weiboData objectForKey:K_BSDK_CONTENT]) {
        _weiboContent = [[NSString alloc] initWithString:[self.weiboData objectForKey:K_BSDK_CONTENT]];
        self.contentLabel.text = self.weiboContent;
        self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, yOffset + CELL_CONTENT_MARGIN_BIG, self.contentLabel.frame.size.width, [ViewHelper getHeightOfText:self.weiboContent ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH]);
    }

    // Custom initialization
    [_detailScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.contentLabel.frame.origin.y + CGRectGetHeight(self.contentLabel.frame) + 150)];
    
    NSDictionary * authorInfo = [self.weiboData objectForKey:K_BSDK_USERINFO];
    
    NSString * avatarImageUrl = [authorInfo objectForKey:K_BSDK_PICTURE_65];
    if (avatarImageUrl && [avatarImageUrl length]) {
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:avatarImageUrl] placeholderImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:authorInfo]]];
    }
    else
    {
        [self.avatarImageView setImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:authorInfo]]];
    }  

    self.weiboAttachedImageButton.frame = self.weiboAttachedImageView.frame;
    
    self.timestampLabel.text = [ViewHelper intervalSinceNow:[self.weiboData objectForKey:K_BSDK_CREATETIME]];
    [self.timestampLabel setTextColor:[UIColor purpleColor]];
    
    self.usernameLabel.text = [authorInfo objectForKey:K_BSDK_USERNAME];
    
    NSString * price = [self.weiboData objectForKey:K_BSDK_PRICE];
    if (price && ([price intValue] != 0)) {
        NSString * title = [NSString stringWithFormat:@"¥ %d", [price intValue]];
        [self.priceButton setTitle:title forState:UIControlStateNormal];
        
        self.priceButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5.0);
        self.priceButton.frame = CGRectMake(CGRectGetMinX(self.priceButton.frame), 
                                            CGRectGetMinY(self.favourateButton.frame) - PRICE_BUTTON_Y_OFFSET, 
                                            [ViewHelper getWidthOfText:title ByFontSize:self.priceButton.titleLabel.font.pointSize]+20,
                                            CGRectGetHeight(self.priceButton.frame));
    }
    else
    {
        [self.priceButton setHidden:YES];
    }
    
    NSString * merchant = [self.weiboData objectForKey:K_BSDK_SHOPMERCHANT];
    if  (merchant)
    {
        self.merchantLable.text = merchant;
    }
    
    NSString * brand = [self.weiboData objectForKey:K_BSDK_BRANDSERVICE];
    if  (brand)
    {
        self.brandLable.text = brand;
    }
}

- (void)getWeiboDataFromResponse
{

}

- (void)onBackButtonClicked {
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)onRefreshButtonClicked {
    [[BSDKManager sharedManager] getWeiboById:[self.weiboData objectForKey:K_BSDK_UID] andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        [self setWeiboData:nil];
        self.weiboData = [data objectForKey:K_BSDK_BLOGINFO];
        [self refreshView];
    }];
}

-(IBAction)onImageButtonPressed:(id)sender
{
    [FullImageViewController showImageUrl:[self.weiboData objectForKey:K_BSDK_PICTURE_ORIGINAL] size:CGSizeMake([[self.weiboData objectForKey:K_BSDK_PICTURE_WIDTH] intValue], [[self.weiboData objectForKey:K_BSDK_PICTURE_HEIGHT] intValue]) inNavigationController:self.navigationController];
}

-(IBAction)onBrandButtonPressed:(id)sender
{
    [[BSDKManager sharedManager] getUserInforByName:[self.weiboData objectForKey:K_BSDK_BRANDSERVICE] andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        if (K_BSDK_IS_RESPONSE_OK(data)) {
            FriendDetailViewController * friendDetailViewController = [[FriendDetailViewController alloc] initWithDictionary:[data objectForKey:K_BSDK_USERINFO]];
            [self.navigationController pushViewController:friendDetailViewController animated:YES];
            [friendDetailViewController release];
        }
    }];
}

-(IBAction)onBusinessButtonPressed:(id)sender
{
    [[BSDKManager sharedManager] getUserInforByName:[self.weiboData objectForKey:K_BSDK_SHOPMERCHANT] andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        if (K_BSDK_IS_RESPONSE_OK(data)) {
            FriendDetailViewController * friendDetailViewController = [[FriendDetailViewController alloc] initWithDictionary:[data objectForKey:K_BSDK_USERINFO]];
            [self.navigationController pushViewController:friendDetailViewController animated:YES];
            [friendDetailViewController release];
        }
    }];
}

-(IBAction)onUserButtonPressed:(id)sender
{
    FriendDetailViewController *userDetailController = [[FriendDetailViewController alloc] initWithDictionary:[self.weiboData objectForKey:K_BSDK_USERINFO]];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: userDetailController];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
    [userDetailController release];
}
@end
