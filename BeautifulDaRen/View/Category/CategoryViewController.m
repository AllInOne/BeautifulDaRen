//
//  FirstViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "ViewConstants.h"
#import "ViewHelper.h"
#import "CommonScrollView.h"
#import "BSDKDefines.h"
#import "BSDKManager.h"

@interface CategoryViewController ()
- (void)refreshView;
- (void)onRefreshButtonClicked;
@property (retain, nonatomic) id observerForLoginStatus;
@end

@implementation CategoryViewController

@synthesize adsPageView = _adsPageView;
@synthesize categoryContentView = _categoryContentView;
@synthesize observerForLoginStatus = _observerForLoginStatus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self refreshView];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];
    self.observerForLoginStatus = [[NSNotificationCenter defaultCenter]
                                   addObserverForName:K_NOTIFICATION_LOGIN_SUCCESS
                                   object:nil
                                   queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       [self onRefreshButtonClicked];
                                   }];
}

- (void)dealloc {
    [self.adsPageView stop];
    [_adsPageView release];
    [_categoryContentView release];
    if (_observerForLoginStatus) {
        [[NSNotificationCenter defaultCenter] removeObserver:_observerForLoginStatus];
        self.observerForLoginStatus = nil;
    }
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.categoryContentView = nil;
    [self.adsPageView stop];
    self.adsPageView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:_observerForLoginStatus];
    self.observerForLoginStatus = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)refreshView
{
    if (self.adsPageView == nil) {
        _adsPageView = [[AdsPageView alloc] initWithNibName:@"AdsPageView" bundle:nil];
        [self.adsPageView setType:K_BSDK_ADSTYPE_HOT];
        if ([[BSDKManager sharedManager] isLogin]) {
            [self.adsPageView setCity:[ViewHelper getMyCity]];
        }

        [self.adsPageView setDelegate:self];
        self.adsPageView.view.frame = CGRectMake(0, 0, ADS_CELL_WIDTH, ADS_CELL_HEIGHT);
        [self.view addSubview:self.adsPageView.view];
    }

    [self.adsPageView.view setHidden:NO];

    if (self.categoryContentView == nil) {
        _categoryContentView = [[CategoryContentViewController  alloc] initWithNibName:@"CategoryContentViewController" bundle:nil];
        _categoryContentView.view.frame = CGRectMake(0, ADS_CELL_HEIGHT + CONTENT_MARGIN, self.view.frame.size.width, USER_WINDOW_HEIGHT - ADS_CELL_HEIGHT - CONTENT_MARGIN);
        [self.view addSubview:_categoryContentView.view];
    }
}

- (void)onAdsPageViewClosed
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];

    [self.adsPageView.view setHidden:YES];
    [self.categoryContentView.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.categoryContentView.view.frame), USER_WINDOW_HEIGHT)];

    [UIView commitAnimations];

    [self.adsPageView stop];
    [self.adsPageView.view removeFromSuperview];
    [self setAdsPageView:nil];
}

- (void)onRefreshButtonClicked {
    for (UIView * view in self.view.subviews)
    {
        [view removeFromSuperview];
    }

    [self setCategoryContentView:nil];
    if (self.adsPageView) {

        [self.adsPageView stop];
        [self setAdsPageView:nil];
    }

    [self refreshView];
}
@end
