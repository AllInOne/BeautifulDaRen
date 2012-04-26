//
//  WeiboComposerViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboComposerViewController.h"

#define WEIBO_CONTENT_TEXTVIEW_Y_OFFSET (110.0)
#define TOOL_BAR_HEIGHT                 (30.0)

@implementation WeiboComposerViewController

@synthesize cameraButton = _cameraButton;
@synthesize footerView = _footerView;
@synthesize weiboContentTextView = _weiboContentTextView;
@synthesize maketTextView = _maketTextView;
@synthesize brandTextView = _brandTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cameraButton.enabled = YES;
        [_weiboContentTextView setDelegate:self];
        [_maketTextView setDelegate:self];
        [_brandTextView setDelegate:self];
        
        _weiboContentTextView.frame = CGRectMake(0, WEIBO_CONTENT_TEXTVIEW_Y_OFFSET, _weiboContentTextView.frame.size.width, _weiboContentTextView.frame.size.height);
        _footerView.frame = CGRectMake(_footerView.frame.origin.x, _footerView.frame.origin.y, _footerView.frame.size.width, TOOL_BAR_HEIGHT);
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
    
    [UIView animateWithDuration:animDuration animations:^
     {
         self.weiboContentTextView.frame = CGRectMake(self.weiboContentTextView.frame.origin.x,
                                          WEIBO_CONTENT_TEXTVIEW_Y_OFFSET,
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
         self.weiboContentTextView.frame = CGRectMake(self.weiboContentTextView.frame.origin.x,
                                          self.weiboContentTextView.frame.origin.y,
                                          self.weiboContentTextView.frame.size.width,
                                          self.weiboContentTextView.frame.size.height + kbSize.height);
         
         self.footerView.center = CGPointMake(self.footerView.center.x,
                                              self.footerView.center.y + kbSize.height);
     }];
}

@end
