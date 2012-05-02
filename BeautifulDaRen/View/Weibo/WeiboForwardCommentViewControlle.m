//
//  WeiboComposerViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboForwardCommentViewController.h"
#import "FriendsSelectionViewController.h"

#define WEIBO_CONTENT_TEXTVIEW_Y_OFFSET (90.0)
#define TOOL_BAR_HEIGHT                 (30.0)
#define WEIBO_CONTENT_TEXTVIEW_MARGIN   (2.0)
#define WEIBO_CONTENT_SCROLL_BOUNCE_SIZE   (30.0)

@implementation WeiboForwardCommentViewController

@synthesize footerView = _footerView;
@synthesize weiboContentTextView = _weiboContentTextView;
@synthesize forwardMode = _forwardMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        [_weiboContentTextView setDelegate:self];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(onBackButtonClicked)];
        [self.navigationItem setLeftBarButtonItem:backButton];
        
        [backButton release];
        
        UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:(UIBarButtonItemStylePlain) target:self action:@selector(onSendButtonClicked)];
        [self.navigationItem setRightBarButtonItem:sendButton];
        
        [sendButton release];
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
    }
    else
    {
        self.navigationItem.title = @"评论";
    }
    
    [_weiboContentTextView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setFooterView:nil];
    [self setWeiboContentTextView:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [_footerView release];
    [_weiboContentTextView release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)keyboardWillShow:(NSNotification *)note 
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
}

- (void)keyboardWillHide:(NSNotification *)note
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
}

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onSendButtonClicked {
    // TODO:
}

- (IBAction)onAtFriendPressed:(id)sender
{
    FriendsSelectionViewController *friendSelectionController = 
    [[[FriendsSelectionViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    friendSelectionController.delegate = self;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: friendSelectionController];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
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

- (void)didFinishContactSelectionWithContacts:(NSString *)friendId
{
    self.weiboContentTextView.text = [self.weiboContentTextView.text stringByAppendingString: [NSString stringWithFormat:@"@%@ ", friendId]];
}

@end
