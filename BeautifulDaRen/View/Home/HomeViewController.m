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

@property (retain, nonatomic) AdsPageView * adsPageView; 


@end

@implementation HomeViewController
@synthesize itemsViewController = _itemsViewController;
@synthesize adsPageView = _adsPageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View lifecycle

-(void) dealloc
{
    [_adsPageView release];
    [_itemsViewController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    {
        UIBarButtonItem* loginButton = [ViewHelper getBarItemOfTarget:self action:@selector(onLoginBtnSelected:) title:NSLocalizedString(@"login", @"login button on navigation")];
        
        UIBarButtonItem* registerButton =[ViewHelper getBarItemOfTarget:self action:@selector(onRegisterBtnSelected:) title:NSLocalizedString(@"register", @"register button on navigation")];
        
        NSArray * navigationBtns = [NSArray arrayWithObjects:registerButton, loginButton, nil];
        // setRightBarButtonItems only availability on ios 5.0 and later.
        [self.navigationItem setRightBarButtonItems:navigationBtns animated:YES];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:[ViewHelper getRightBarItemOfTarget1:self action1:@selector(onLoginBtnSelected:) title1:NSLocalizedString(@"login", @"login button on navigation") target2:self action2:@selector(onRegisterBtnSelected:) title2:NSLocalizedString(@"register", @"register button on navigation")]];
    }
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getLeftBarItemOfImageName:@"beautifuldaren_logo" rectSize:CGRectMake(0, 0, NAVIGATION_LEFT_LOGO_WIDTH, NAVIGATION_LEFT_LOGO_HEIGHT)]];
    
    if(_adsPageView == nil)
    {
        _adsPageView = [[AdsPageView alloc] initWithNibName:@"AdsPageView" bundle:nil];
        _adsPageView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, ADS_CELL_HEIGHT);
        [self.view addSubview:_adsPageView.view];
    }

    if(_itemsViewController == nil)
    {
        _itemsViewController = [[ItemsViewController alloc] initWithNibName:@"ItemsViewController" bundle:nil];
        
        _itemsViewController.view.frame = CGRectMake(0, ADS_CELL_HEIGHT + CONTENT_MARGIN, self.view.frame.size.width, USER_WINDOW_HEIGHT - ADS_CELL_HEIGHT - CONTENT_MARGIN);
        [self.view addSubview:_itemsViewController.view];
    }
    
    _adsPageView.delegate = self;
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
    [self.navigationController pushViewController:loginContorller animated:YES];
}

- (IBAction)onRegisterBtnSelected:(UIButton*)sender
{
    RegisterViewController * registerController = [[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:registerController animated:YES];

//    MapViewController * mapController = [[MapViewController alloc] initWithName:@"AAA" description:@"BBB" latitude:12.32f longitude:77.12f];
//    [self.navigationController pushViewController:mapController animated:YES];
}

#pragma mark AdsPageViewProtocol
-(void) onAdsPageViewClosed
{    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [_adsPageView.view setHidden:YES];
    [_itemsViewController.view setFrame:CGRectMake(0, 0, CGRectGetWidth(_itemsViewController.view.frame), USER_WINDOW_HEIGHT)];
    
    [UIView commitAnimations];
}
@end
