//
//  PrivateLetterDetailViewController.m
//  BeautifulDaRen
//
//  Created by Jerry Lee on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrivateLetterDetailViewController.h"
#import "ViewHelper.h"
#import "ViewConstants.h"
#import "BSDKManager.h"
#import "iToast.h"

#define BUBBLE_VIEW_MARGIN  (10.0)

@interface PrivateLetterDetailViewController ()

@property (nonatomic, assign) BOOL  isKeypadShow;

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) BOOL  isAllRetrieved;
@property (nonatomic, retain) NSMutableArray * messages;

- (void)refreshView;

@end

@implementation PrivateLetterDetailViewController

@synthesize contentScrollView = _contentScrollView;
@synthesize footerView = _footerView;
@synthesize privateLetterComposerView = _privateLetterComposerView;
@synthesize isKeypadShow = _isKeypadShow;
@synthesize currentPageIndex = _currentPageIndex;
@synthesize isAllRetrieved = _isAllRetrieved;
@synthesize messages = _messages;
@synthesize userId = _userId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        
        [self.navigationItem setTitle:NSLocalizedString(@"private_letter", @"private_letter")];
        
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];
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

}

- (void)refreshView
{
    CGFloat viewHeight = 10.0;
    
    for (UIView * view in self.contentScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (NSDictionary * message in [_messages reverseObjectEnumerator]) {
        UIView * bubbleView= [ViewHelper bubbleView:[message objectForKey:K_BSDK_CONTENT] from:[message objectForKey:K_BSDK_USERINFO] atTime:[message objectForKey:K_BSDK_CREATETIME]];
        
        bubbleView.frame = CGRectMake(0.0, viewHeight, CGRectGetWidth(bubbleView.frame), CGRectGetHeight(bubbleView.frame));
        
        [self.contentScrollView addSubview:bubbleView];
        
        viewHeight += (CGRectGetHeight(bubbleView.frame) + 10.0);
                                                                                                
    }
    
    [self.contentScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, (viewHeight))];

}

#pragma mark - View lifecycle

- (void)dealloc
{
    [_contentScrollView release];
    [_footerView release];
    [_privateLetterComposerView release];
    [_messages release];
    [_userId release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.messages = [NSMutableArray arrayWithCapacity:40];

    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center = CGPointMake(SCREEN_WIDTH/2, ADS_CELL_HEIGHT/2);
    [activityIndicator startAnimating];
    
    [self.view addSubview:activityIndicator];
    
    [[BSDKManager sharedManager] getPrivateMsgListOfUser:self.userId
                                                    type:K_BSDK_PRIVATEMSG_MSG_TYPE_ALL
                                                pageSize:20 
                                               pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                                   
                                                   [activityIndicator stopAnimating];
                                                   [activityIndicator removeFromSuperview];
                                                   [activityIndicator release];
                                                   
                                                   [_messages addObjectsFromArray:[data objectForKey:K_BSDK_USERLIST]];
                                                    
                                                   [self refreshView];
                                                       
                                                   }];
    
    
    
    
    UIImageView * toolbarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_background"]];
    toolbarBg.contentMode = UIViewContentModeScaleToFill;
    [self.footerView  insertSubview:toolbarBg atIndex:0];
    
    [self.privateLetterComposerView setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.contentScrollView setDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.contentScrollView = nil;
    self.footerView = nil;
    self.privateLetterComposerView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isKeypadShow) {
        [self.privateLetterComposerView resignFirstResponder];
    }
}

- (void)keyboardWillShow:(NSNotification *)note 
{
    if (!self.isKeypadShow)
    {
        NSDictionary *info = [note userInfo];
        
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        double animDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:animDuration animations:^
         {
             NSLog(@"%@", self.contentScrollView);
             self.contentScrollView.frame = CGRectMake(self.contentScrollView.frame.origin.x,
                                               self.contentScrollView.frame.origin.y - kbSize.height,
                                               self.contentScrollView.frame.size.width,
                                               self.contentScrollView.frame.size.height);
             
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
             self.contentScrollView.frame = CGRectMake(self.contentScrollView.frame.origin.x,
                                                       self.contentScrollView.frame.origin.y + kbSize.height,
                                                       self.contentScrollView.frame.size.width,
                                                       self.contentScrollView.frame.size.height);
             
             self.footerView.center = CGPointMake(self.footerView.center.x,
                                                  self.footerView.center.y + kbSize.height);
         }];
        
        self.isKeypadShow = NO;    
    }
}

-(IBAction)onSendButtonPressed:(id)sender
{
    [[BSDKManager sharedManager] sendPrivateMsgToUser:self.userId content:self.privateLetterComposerView.text andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
    }];
}
@end
