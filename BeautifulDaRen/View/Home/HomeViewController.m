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
#import "BSDKManager.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "iToast.h"

@interface HomeViewController()

//@property (retain, nonatomic) AdsPageView * adsPageView;
@property (retain, nonatomic) ItemsViewController* itemsViewController;
@property (retain, nonatomic) AdsPageView * adsPageView;
@property (retain, nonatomic) id observerForLoginSuccess;
@property (retain, nonatomic) id observerForShouldLogin;

- (void)refreshNavigationView;
- (void)refreshWeibosView;
@end

@implementation HomeViewController
@synthesize itemsViewController = _itemsViewController;
@synthesize adsPageView = _adsPageView;
@synthesize observerForLoginSuccess = _observerForLoginSuccess;
@synthesize observerForShouldLogin = _observerForShouldLogin;

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
    
    self.observerForLoginSuccess = [[NSNotificationCenter defaultCenter]
                 addObserverForName:K_NOTIFICATION_LOGIN_SUCCESS
                 object:nil
                 queue:nil
                 usingBlock:^(NSNotification *note) {
                     [self refreshNavigationView];
                 }];
    
    self.observerForShouldLogin = [[NSNotificationCenter defaultCenter]
                                    addObserverForName:K_NOTIFICATION_SHOULD_LOGIN
                                    object:nil
                                    queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       [[iToast makeText:@"您还没登陆，请先登录！"] show];
                                       if (![self.navigationController.topViewController isKindOfClass:[LoginViewController class]]) {
                                           LoginViewController * loginContorller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                                           [self.navigationController pushViewController:loginContorller animated:YES];
                                           [loginContorller release];
                                       }
                                    }];
    
    if(self.adsPageView == nil)
    {
        _adsPageView = [[AdsPageView alloc] initWithNibName:@"AdsPageView" bundle:nil];
        self.adsPageView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, ADS_CELL_HEIGHT);
        [self.view addSubview:self.adsPageView.view];
        self.adsPageView.delegate = self;
    }


    [self refreshNavigationView];
    [self refreshWeibosView];
}

-(void) dealloc
{
    [self.adsPageView stop];
    [_adsPageView release];
    [_itemsViewController release];
    [_observerForLoginSuccess release];
    [_observerForShouldLogin release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:_observerForLoginSuccess];
    [self.adsPageView stop];
    self.adsPageView = nil;
    self.itemsViewController = nil;
    self.observerForLoginSuccess = nil;
    self.observerForShouldLogin = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_itemsViewController viewWillAppear:animated];
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
    LoginViewController * loginContorller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginContorller animated:YES];
    [loginContorller release];
}

-(IBAction)onRefreshBtnSelected:(UIButton*)sender
{
    [self refreshWeibosView];
}

- (IBAction)onRegisterBtnSelected:(UIButton*)sender
{
    RegisterViewController * registerController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    
    [self.navigationController pushViewController:registerController animated:YES];
    [registerController release];

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


- (void)refreshNavigationView
{
    if ([[BSDKManager sharedManager] isLogin]) {
        [self.navigationItem setTitle:[[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:KEY_ACCOUNT_USER_NAME]];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
        {
            [self.navigationItem setRightBarButtonItems:nil];
        }
        else {
            [self.navigationItem setRightBarButtonItem:nil];
        }
        //        UIBarButtonItem* detailModeButton = [ViewHelper getBarItemOfTarget:self action:@selector(onDetailModeBtnSelected:) title:NSLocalizedString(@"detail_mode", @"detail_mode")];
        UIBarButtonItem* refreshButton = [ViewHelper getBarItemOfTarget:self action:@selector(onRefreshBtnSelected:) title:NSLocalizedString(@"refresh", @"refresh")];
        //        [self.navigationItem setRightBarButtonItem:detailModeButton];
        [self.navigationItem setLeftBarButtonItem:refreshButton];
    }
    else {
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
        {
            if(![[BSDKManager sharedManager] isLogin])
            {
                UIBarButtonItem* loginButton = [ViewHelper getBarItemOfTarget:self action:@selector(onLoginBtnSelected:) title:NSLocalizedString(@"login", @"login button on navigation")];
                
                UIBarButtonItem* registerButton =[ViewHelper getBarItemOfTarget:self action:@selector(onRegisterBtnSelected:) title:NSLocalizedString(@"register", @"register button on navigation")];
                
                NSArray * navigationBtns = [NSArray arrayWithObjects:registerButton, loginButton, nil];
                // setRightBarButtonItems only availability on ios 5.0 and later.
                [self.navigationItem setRightBarButtonItems:navigationBtns animated:YES];
            }
        }
        else
        {
            [self.navigationItem setRightBarButtonItem:[ViewHelper getRightBarItemOfTarget1:self action1:@selector(onLoginBtnSelected:) title1:NSLocalizedString(@"login", @"login button on navigation") target2:self action2:@selector(onRegisterBtnSelected:) title2:NSLocalizedString(@"register", @"register button on navigation")]];
        }
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getLeftBarItemOfImageName:@"beautifuldaren_logo" rectSize:CGRectMake(0, 0, NAVIGATION_LEFT_LOGO_WIDTH, NAVIGATION_LEFT_LOGO_HEIGHT)]];
    }
}


- (void)refreshWeibosView
{
    NSString * userName = nil;
    if ([[BSDKManager sharedManager] isLogin])
    {
        userName = [[[NSUserDefaults standardUserDefaults]
                     valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO]
                    valueForKey:KEY_ACCOUNT_USER_NAME];
    }
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.frame = CGRectMake(SCREEN_WIDTH/2, 2*ADS_CELL_HEIGHT + CONTENT_MARGIN, CGRectGetWidth(activityIndicator.frame), CGRectGetHeight(activityIndicator.frame));
    
    [self.view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    [[BSDKManager sharedManager] getWeiboListByUsername:userName
                                               pageSize:20
                                              pageIndex:1
                                        andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                            [activityIndicator stopAnimating];
                                            [activityIndicator removeFromSuperview];
                                            [activityIndicator release];
                                            
                                            NSArray * array = [data valueForKey:@"BlogList"];
                                            //TODO [felix] should to remove
                                            NSMutableArray * mutableArray = [NSMutableArray array];
                                            for (NSDictionary * dict in array) {
                                                if ([[dict valueForKey:@"Picture_width"] floatValue] > 0)
                                                {
                                                    [mutableArray addObject:dict];
                                                }
                                            }
                                            if(_itemsViewController == nil)
                                            {
                                                _itemsViewController = [[ItemsViewController alloc] initWithArray:mutableArray];
                                                _itemsViewController.view.frame = CGRectMake(0,
                                                                                             ADS_CELL_HEIGHT + CONTENT_MARGIN,
                                                                                             self.view.frame.size.width,
                                                                                             USER_WINDOW_HEIGHT - ADS_CELL_HEIGHT - CONTENT_MARGIN);
                                                [self.view addSubview:_itemsViewController.view];
                                            }
                                            else
                                            {
                                                _itemsViewController.itemDatas = mutableArray;
                                            }
                                        }];
}

@end
