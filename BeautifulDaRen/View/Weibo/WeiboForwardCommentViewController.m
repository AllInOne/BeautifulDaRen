//
//  WeiboComposerViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboForwardCommentViewController.h"
#import "FriendsSelectionViewController.h"
#import "ViewHelper.h"

#define WEIBO_CONTENT_TEXTVIEW_Y_OFFSET (90.0)
#define TOOL_BAR_HEIGHT                 (30.0)
#define WEIBO_CONTENT_TEXTVIEW_MARGIN   (2.0)
#define WEIBO_CONTENT_SCROLL_BOUNCE_SIZE   (30.0)

@interface WeiboForwardCommentViewController ()
@property (nonatomic, assign) BOOL isKeypadShow;
@end

@implementation WeiboForwardCommentViewController

@synthesize footerView = _footerView;
@synthesize weiboContentTextView = _weiboContentTextView;
@synthesize forwardMode = _forwardMode;
@synthesize isKeypadShow = _isKeypadShow;
@synthesize checkBoxText = _checkBoxText;
@synthesize checkBoxButton = _checkBoxButton;
@synthesize isCheckBoxChecked = _isCheckBoxChecked;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        [_weiboContentTextView setDelegate:self];

        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];

        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onSendButtonClicked) title:NSLocalizedString(@"send", @"send")]];
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

    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.forwardMode) {
        self.navigationItem.title = @"转发";
        self.checkBoxText.text = @"同时评论给用户";
    }
    else
    {
        self.checkBoxText.text = @"同时转发到我的微博";
        self.navigationItem.title = @"评论";
    }
    
    UIImageView * toolbarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_background"]];
    toolbarBg.contentMode = UIViewContentModeScaleToFill;
    [self.footerView  insertSubview:toolbarBg atIndex:0];
    
    [toolbarBg release];
    
    self.isCheckBoxChecked = YES;
    
    [_weiboContentTextView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setFooterView:nil];
    [self setWeiboContentTextView:nil];
    [self setCheckBoxText:nil];
    [self setCheckBoxButton:nil];
    [self setIsCheckBoxChecked:YES];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [_footerView release];
    [_weiboContentTextView release];
    [_checkBoxText release];
    [_checkBoxButton release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)keyboardWillShow:(NSNotification *)note 
{
    if (!self.isKeypadShow)
    {
        NSDictionary *info = [note userInfo];
        
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        double animDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        NSLog(@"%@", self.weiboContentTextView);
        [UIView animateWithDuration:animDuration animations:^
         {
             self.weiboContentTextView.frame =CGRectMake(self.weiboContentTextView.frame.origin.x,
                                                         self.weiboContentTextView.frame.origin.y,
                                                         self.weiboContentTextView.frame.size.width,
                                                         self.weiboContentTextView.frame.size.height - kbSize.height);
             
             self.footerView.center = CGPointMake(self.footerView.center.x,
                                                  self.footerView.center.y - kbSize.height);
         }];
        self.isKeypadShow = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isKeypadShow)
    {
        NSDictionary *info = [note userInfo];
        
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        double animDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:animDuration animations:^
         {
             self.weiboContentTextView.frame =CGRectMake(self.weiboContentTextView.frame.origin.x,
                                                         self.weiboContentTextView.frame.origin.y,
                                                         self.weiboContentTextView.frame.size.width,
                                                         self.weiboContentTextView.frame.size.height + kbSize.height);
             
             self.footerView.center = CGPointMake(self.footerView.center.x,
                                                  self.footerView.center.y + kbSize.height);
         }];
        self.isKeypadShow = NO;
    }
}

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onSendButtonClicked {
    if (self.delegate) {
        [self.delegate onConfirmed:self];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onAtFriendPressed:(id)sender
{
    FriendsSelectionViewController *friendSelectionController = 
    [[FriendsSelectionViewController alloc] initWithNibName:nil bundle:nil];
    friendSelectionController.delegate = self;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: friendSelectionController];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
    [friendSelectionController release];
}

- (IBAction)onLocationPressed:(id)sender
{
    //TODO:
}

- (IBAction)onCategoryPressed:(id)sender
{
    //TODO:
}

- (IBAction)onForward2SinaPressed:(id)sender
{
    //TODO:
}

- (IBAction)onForward2TencentPressed:(id)sender
{
    //TODO:
}

- (IBAction)onCheckBoxPressed:(id)sender
{
    if (self.isCheckBoxChecked) {
        self.isCheckBoxChecked = NO;
        [self.checkBoxButton setImage:[UIImage imageNamed:@"comment_forward_unchecked.png"] forState:UIControlStateNormal];
    }
    else {
        self.isCheckBoxChecked = YES;
        [self.checkBoxButton setImage:[UIImage imageNamed:@"comment_forward_checked.png"] forState:UIControlStateNormal];        
    }
}

- (void)didFinishContactSelectionWithContacts:(NSString *)friendId
{
    self.weiboContentTextView.text = [self.weiboContentTextView.text stringByAppendingString: [NSString stringWithFormat:@"@%@ ", friendId]];
}

@end
