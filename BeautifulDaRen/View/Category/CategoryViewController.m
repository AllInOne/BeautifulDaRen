//
//  FirstViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "ViewConstants.h"
#import "CommonScrollView.h"

@implementation CategoryViewController

@synthesize adsPageView = _adsPageView;
@synthesize userInforCellView = _userInforCellView;
@synthesize categoryContentView = _categoryContentView;

- (void)dealloc {
    [_adsPageView release];
    [_userInforCellView release];
    [_categoryContentView release];
    [super dealloc];
}

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
    if (self.userInforCellView == nil) {
        _userInforCellView = [[UserInforCellViewController alloc] initWithNibName:@"UserInforCellViewController" bundle:nil];
        _userInforCellView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, USER_INFOR_CELL_HEIGHT);
        [self.view addSubview:_userInforCellView.view];
    }

    if (self.adsPageView == nil) {
        _adsPageView = [[AdsPageView alloc] initWithNibName:@"AdsPageView" bundle:nil];
        _adsPageView.view.frame = CGRectMake(0, USER_INFOR_CELL_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:_adsPageView.view];
    }
    
    if (self.categoryContentView == nil) {
        _categoryContentView = [[CategoryContentViewController  alloc] initWithNibName:@"CategoryContentViewController" bundle:nil];
        _categoryContentView.view.frame = CGRectMake(0, USER_INFOR_CELL_HEIGHT + ADS_CELL_HEIGHT, self.view.frame.size.width, 220);
        [self.view addSubview:_categoryContentView.view];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

@end
