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

@interface CategoryViewController ()
- (void)refreshView;
@end

@implementation CategoryViewController

@synthesize adsPageView = _adsPageView;
@synthesize categoryContentView = _categoryContentView;


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
}

- (void)dealloc {
    [super dealloc];
    [_adsPageView release];
    [_categoryContentView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.categoryContentView = nil;
    self.adsPageView = nil;
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
        self.adsPageView = [[AdsPageView alloc] initWithNibName:@"AdsPageView" bundle:nil];
        self.adsPageView.view.frame = CGRectMake(0, 0, ADS_CELL_WIDTH, ADS_CELL_HEIGHT);
        [self.adsPageView setDelegate:self];
        [self.view addSubview:self.adsPageView.view];
    }
    
    [self.adsPageView.view setHidden:NO];
    
    if (self.categoryContentView == nil) {
        _categoryContentView = [[CategoryContentViewController  alloc] initWithNibName:@"CategoryContentViewController" bundle:nil];
        _categoryContentView.view.frame = CGRectMake(0, ADS_CELL_HEIGHT + CONTENT_MARGIN, self.view.frame.size.width, USER_WINDOW_HEIGHT - ADS_CELL_HEIGHT - CONTENT_MARGIN);
        [self.view addSubview:_categoryContentView.view];
    }
    
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]]; 
}

- (void)onAdsPageViewClosed
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [self.adsPageView.view setHidden:YES];
    [self.categoryContentView.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.categoryContentView.view.frame), USER_WINDOW_HEIGHT)];
    
    [UIView commitAnimations];
    
    [self.adsPageView removeFromParentViewController];
    [self setAdsPageView:nil];
}

- (void)onRefreshButtonClicked {
    [self.categoryContentView removeFromParentViewController];
    [self setCategoryContentView:nil];
    if (self.adsPageView) {
        [self.adsPageView removeFromParentViewController];
        [self setAdsPageView:nil];
    }
    
    [self refreshView];
}
@end
