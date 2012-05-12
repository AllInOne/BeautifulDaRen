//
//  FirstViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "AdsPageView.h"
#import "ViewConstants.h"
#import "ViewHelper.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"

@interface HomeViewController()

@property (retain, nonatomic) IBOutlet UIBarButtonItem * loginButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem * registerButton;
@property (retain, nonatomic) AdsPageView * adsPageView; 
@property (assign, nonatomic) BOOL isShowAdsPage;

@property (assign, nonatomic) CGFloat paintHeight;

- (void) showAdsPageView;
- (void) showItemsView;
- (void) refreshView;
@end

@implementation HomeViewController
@synthesize itemsViewController;
@synthesize paintHeight = _paintHeight;
@synthesize adsPageView = _adsPageView;
@synthesize isShowAdsPage = _isShowAdsPage;
@synthesize loginButton = _loginButton;
@synthesize registerButton = _registerButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isShowAdsPage = YES;
    
    _loginButton = [ViewHelper getBarItemOfTarget:self action:@selector(onLoginBtnSelected:) title:NSLocalizedString(@"login", @"login button on navigation")];

    _registerButton =[ViewHelper getBarItemOfTarget:self action:@selector(onRegisterBtnSelected:) title:NSLocalizedString(@"register", @"register button on navigation")];
    
    NSArray * navigationBtns = [NSArray arrayWithObjects:_registerButton, _loginButton, nil];
    
    [self.navigationItem setRightBarButtonItems:navigationBtns animated:YES];

    [self.navigationItem setLeftBarButtonItem:[ViewHelper getLeftBarItemOfImageName:@"logo114x29" rectSize:CGRectMake(0, 0, NAVIGATION_LEFT_LOGO_WIDTH, NAVIGATION_LEFT_LOGO_HEIGHT)]];
    
    [self refreshView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
#pragma mark Action
- (IBAction)onLoginBtnSelected:(UIButton*)sender
{
    LoginViewController * loginContorller = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: loginContorller];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
}
- (IBAction)onRegisterBtnSelected:(UIButton*)sender
{
    RegisterViewController * registerController = [[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil] autorelease];
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: registerController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
//    MapViewController * mapController = [[MapViewController alloc] initWithName:@"AAA" description:@"BBB" latitude:12.32f longitude:77.12f];
//    [self.navigationController pushViewController:mapController animated:YES];
}

- (void) showAdsPageView
{
    if(_isShowAdsPage)
    {
        _adsPageView = [[[AdsPageView alloc] initWithNibName:@"AdsPageView" bundle:nil] autorelease];
        _adsPageView.view.frame = CGRectMake(0, _paintHeight, self.view.frame.size.width, ADS_CELL_HEIGHT);
        [self.view addSubview:_adsPageView.view];
        _paintHeight += ADS_CELL_HEIGHT;
    }
}

-(void) showItemsView
{
    self.itemsViewController = [[ItemsViewController alloc] initWithNibName:@"ItemsViewController" bundle:nil];
    CGFloat height = (_isShowAdsPage) ? 280 : 350;
    self.itemsViewController.view.frame = CGRectMake(0, _paintHeight+ 100, self.itemsViewController.view.frame.size.width, height);
    [self.view addSubview:self.itemsViewController.view];
    _paintHeight += ADS_CELL_HEIGHT;
}

-(void) refreshView
{
    _paintHeight = 0;
    [self showAdsPageView];
    [self showItemsView];
    
}
@end
