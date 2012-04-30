//
//  WeiboComposerViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboComposerViewController.h"

#define WEIBO_CONTENT_TEXTVIEW_Y_OFFSET (130.0)
#define TOOL_BAR_HEIGHT                 (30.0)
#define WEIBO_CONTENT_TEXTVIEW_MARGIN   (2.0)
#define WEIBO_CONTENT_SCROLL_BOUNCE_SIZE   (30.0)

@interface WeiboComposerViewController ()

- (void)setContentFrame:(CGRect)frame;
@end

@implementation WeiboComposerViewController

@synthesize cameraButton = _cameraButton;
@synthesize footerView = _footerView;
@synthesize weiboContentTextView = _weiboContentTextView;
@synthesize maketTextView = _maketTextView;
@synthesize brandTextView = _brandTextView;
@synthesize weiboContentBgTextFiled = _weiboContentBgTextFiled;
@synthesize contentScrollView = _contentScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cameraButton.enabled = YES;
        [_weiboContentTextView setDelegate:self];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(onBackButtonClicked)];
        [self.navigationItem setLeftBarButtonItem:backButton];
        
        [backButton release];
        
        UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:(UIBarButtonItemStylePlain) target:self action:@selector(onSendButtonClicked)];
        [self.navigationItem setRightBarButtonItem:sendButton];        
        
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

    [self setContentFrame:CGRectMake(_weiboContentBgTextFiled.frame.origin.x, WEIBO_CONTENT_TEXTVIEW_Y_OFFSET, _weiboContentBgTextFiled.frame.size.width, _weiboContentTextView.frame.size.height)];
    
    [_contentScrollView setContentSize:CGSizeMake(_weiboContentTextView.frame.size.width, WEIBO_CONTENT_TEXTVIEW_Y_OFFSET + _weiboContentTextView.frame.size.height + WEIBO_CONTENT_SCROLL_BOUNCE_SIZE)];
     NSLog(@"%@", self.weiboContentTextView);
    
    [_brandTextView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setCameraButton:nil];
    [self setFooterView:nil];
    [self setBrandTextView:nil];
    [self setWeiboContentTextView:nil];
    [self setMaketTextView:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [_cameraButton release];
    [_footerView release];
    [_weiboContentTextView release];
    [_maketTextView release];
    [_brandTextView release];
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
         [self setContentFrame: CGRectMake(self.weiboContentTextView.frame.origin.x,
                                          WEIBO_CONTENT_TEXTVIEW_Y_OFFSET,
                                          self.weiboContentTextView.frame.size.width,
                                          self.weiboContentTextView.frame.size.height - kbSize.height)];
         
         self.footerView.center = CGPointMake(self.footerView.center.x,
                                              self.footerView.center.y - kbSize.height);
     }];
    
     self.contentScrollView.frame = CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height - kbSize.height);
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.contentSize.width, self.contentScrollView.contentSize.height - kbSize.height);
    
     NSLog(@"keyboardWillShow, weibo content frame.y = %f", _weiboContentTextView.frame.origin.y);
}

- (void)keyboardWillHide:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    double animDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animDuration animations:^
     {
         [self setContentFrame:CGRectMake(self.weiboContentTextView.frame.origin.x,
                                          self.weiboContentTextView.frame.origin.y,
                                          self.weiboContentTextView.frame.size.width,
                                          self.weiboContentTextView.frame.size.height + kbSize.height)];
         
         self.footerView.center = CGPointMake(self.footerView.center.x,
                                              self.footerView.center.y + kbSize.height);
     }];
    
    NSLog(@"keyboardWillHide, weibo content frame.y = %f", _weiboContentTextView.frame.origin.y);
}

- (void)setContentFrame:(CGRect)frame
{
    self.weiboContentTextView.frame = frame;

    self.weiboContentBgTextFiled.frame = CGRectMake(frame.origin.x - WEIBO_CONTENT_TEXTVIEW_MARGIN, frame.origin.y - WEIBO_CONTENT_TEXTVIEW_MARGIN, frame.size.width + 2 * WEIBO_CONTENT_TEXTVIEW_MARGIN, frame.size.height + 2 * WEIBO_CONTENT_TEXTVIEW_MARGIN);
}

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onSendButtonClicked {
    // TODO:
}

@end
