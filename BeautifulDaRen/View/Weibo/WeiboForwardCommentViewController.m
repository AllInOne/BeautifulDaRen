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
#import "BSDKManager.h"
#import "BSDKDefines.h"
#import "ViewConstants.h"
#import "SinaSDKManager.h"

#define WEIBO_CONTENT_TEXTVIEW_Y_OFFSET (90.0)
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
@synthesize atButton = _atButton;
@synthesize delegate = _delegate;

@synthesize orignalContent = _orignalContent;

@synthesize sinaButton = _sinaButton;
@synthesize sinaShareImageView = _sinaShareImageView;
@synthesize sinaSepImageView = _sinaSepImageView;

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

    [self.checkBoxText setFont:[UIFont systemFontOfSize:16.0]];

    UIImageView * toolbarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_background"]];
    toolbarBg.contentMode = UIViewContentModeScaleToFill;
    [self.footerView  insertSubview:toolbarBg atIndex:0];

    [toolbarBg release];

    self.isCheckBoxChecked = NO;

    [_weiboContentTextView becomeFirstResponder];

    [_weiboContentTextView setDelegate:self];

    if (self.forwardMode) {
        if ([[SinaSDKManager sharedManager] isLogin])
        {
            [self.sinaButton setImage:[UIImage imageNamed:@"myshow_sina_color"] forState:UIControlStateNormal];
        }
        else
        {
            [self.sinaButton setImage:[UIImage imageNamed:@"myshow_sina_gray"] forState:UIControlStateNormal];
            [self.sinaShareImageView setHidden:YES];
        }
        
        
        self.weiboContentTextView.text = [self.orignalContent substringToIndex:TEXT_VIEW_MAX_CHARACTOR_NUMBER];
    }
    else
    {
        [self.sinaButton setHidden:YES];
        [self.sinaSepImageView setHidden:YES];
        [self.sinaShareImageView setHidden:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setFooterView:nil];
    [self setWeiboContentTextView:nil];
    [self setCheckBoxText:nil];
    [self setCheckBoxButton:nil];
    [self setAtButton:nil];
    [self setSinaButton:nil];
    [self setSinaShareImageView:nil];
    [self setSinaSepImageView:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [_footerView release];
    [_weiboContentTextView release];
    [_checkBoxText release];
    [_checkBoxButton release];
    [_atButton release];
    [_sinaShareImageView release];
    [_sinaButton release];
    [_sinaSepImageView release];
    [_orignalContent release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([[textView text] length] - range.length + text.length > TEXT_VIEW_MAX_CHARACTOR_NUMBER) {
        return NO;
    }
    return YES;
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
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"prompt")
                                                    message:NSLocalizedString(@"composer_back_confirmation", @"composer_back_confirmation")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                          otherButtonTitles:NSLocalizedString(@"confirm", @"confirm"), nil];
    alert.tag = TAG_ALERTVIEW_BACK_CONFIRM;

    [alert show];
    [alert release];

    return;
}

- (IBAction)onSinaPressed:(id)sender
{
    if (![[SinaSDKManager sharedManager] isLogin])
    {
        [[SinaSDKManager sharedManager] setRootviewController:self.navigationController];
        [[SinaSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
            NSLog(@"Sina SDK login done, status:%d", status);
            [self.sinaButton setImage:[UIImage imageNamed:@"myshow_sina_color"] forState:UIControlStateNormal];
            [self.sinaShareImageView setHidden:NO];
        }];
    }
    else
    {
        [self.sinaShareImageView setHidden:(self.sinaShareImageView.hidden ? NO : YES)];
    }
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TAG_ALERTVIEW_BACK_CONFIRM)
    {
        switch (buttonIndex) {
            case 1:
                if (![self.navigationController popViewControllerAnimated:YES])
                {
                    [self dismissModalViewControllerAnimated:YES];
                }
                break;
            default:
                break;
        }
    }
}

@end
