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
#import "BSDKDefines.h"
#import "BSDKManager.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "iToast.h"

@interface HomeViewController()

//@property (retain, nonatomic) AdsPageView * adsPageView;
@property (retain, nonatomic) ItemsViewController* itemsViewController;
@property (retain, nonatomic) AdsPageView * adsPageView;
@property (retain, nonatomic) id observerForLoginStatus;
@property (retain, nonatomic) id observerForLogout;
@property (retain, nonatomic) id observerForShouldLogin;

- (void)refreshNavigationView;
- (void) showAdsPageView;
@end

@implementation HomeViewController
@synthesize itemsViewController = _itemsViewController;
@synthesize adsPageView = _adsPageView;
@synthesize observerForLoginStatus = _observerForLoginStatus;
@synthesize observerForShouldLogin = _observerForShouldLogin;
@synthesize observerForLogout = _observerForLogout;

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
    
    self.observerForLoginStatus = [[NSNotificationCenter defaultCenter]
                                   addObserverForName:K_NOTIFICATION_LOGIN_SUCCESS
                                   object:nil
                                   queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       [self refreshNavigationView];
                                       [self.itemsViewController clearData];
                                       [self.itemsViewController refresh];
                                   }];
    
    self.observerForLogout = [[NSNotificationCenter defaultCenter]
                                   addObserverForName:K_NOTIFICATION_LOGINOUT_SUCCESS
                                   object:nil
                                   queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       [self refreshNavigationView];
                                       [self.itemsViewController clearData];
                                       [self.itemsViewController refresh];
                                   }];
    
    self.observerForShouldLogin = [[NSNotificationCenter defaultCenter]
                                    addObserverForName:K_NOTIFICATION_SHOULD_LOGIN
                                    object:nil
                                    queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       [[iToast makeText:@"您还没登录，请先登录！"] show];
                                       if (![self.navigationController.topViewController isKindOfClass:[LoginViewController class]]) {
                                           LoginViewController * loginContorller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                                           [self.navigationController pushViewController:loginContorller animated:YES];
                                           [loginContorller release];
                                       }
                                    }];
    
    _adsPageView = [[AdsPageView alloc] initWithNibName:@"AdsPageView" bundle:nil];
    self.adsPageView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, ADS_CELL_HEIGHT);
    [self.view addSubview:self.adsPageView.view];
    self.adsPageView.delegate = self;
    
    NSNumber * isAutoLogin = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_IS_AUTO_LOGIN];
    if (![[BSDKManager sharedManager] isLogin] && [isAutoLogin boolValue])
    {
        __block NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_AUTO_LOGIN_ACCOUNT_NAME];
        __block NSString * userPwd = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_AUTO_LOGIN_ACCOUNT_PASSWORD];
        if (userName && userPwd)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_SHOWWAITOVERLAY object:self];
            [[BSDKManager sharedManager] loginWithUsername:userName
                                                  password:userPwd
                                           andDoneCallback:^(AIO_STATUS status, NSDictionary *data)
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_HIDEWAITOVERLAY object:self];
                 if(AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
                 {
                     NSDictionary * dict = [data objectForKey:K_BSDK_USERINFO];
                     [[NSUserDefaults standardUserDefaults] setObject:dict forKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
                     [self.navigationController popToRootViewControllerAnimated:YES];
                     [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_LOGIN_SUCCESS object:self userInfo:data];
                 }
                 else
                 {
                     [[iToast makeText:[NSString stringWithFormat:@"%@", K_BSDK_GET_RESPONSE_MESSAGE(data)]] show];
                 }
             }];
        }
    }

    
    _itemsViewController = [[ItemsViewController alloc] initWithArray:nil];
    _itemsViewController.view.frame = CGRectMake(0,
                                                 ADS_CELL_HEIGHT + CONTENT_MARGIN,
                                                 self.view.frame.size.width,
                                                 USER_WINDOW_HEIGHT - ADS_CELL_HEIGHT - CONTENT_MARGIN);
    [self.view addSubview:_itemsViewController.view];
    if (![[BSDKManager sharedManager] isLogin] && ![isAutoLogin boolValue])
    {
        [self.itemsViewController refresh];
    }
    [self refreshNavigationView];
}

-(void) dealloc
{
    [self.adsPageView stop];
    [_adsPageView release];
    [_itemsViewController release];
    [_observerForLoginStatus release];
    [_observerForLogout release];
    [_observerForShouldLogin release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self.itemsViewController viewDidUnload];
    [self.adsPageView stop];
    self.adsPageView = nil;
    self.itemsViewController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:_observerForLoginStatus];
    self.observerForLoginStatus = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:_observerForLogout];
    self.observerForLogout = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self.observerForShouldLogin];
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
    [_itemsViewController viewWillDisappear:animated];
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
    [self showAdsPageView];
    [self.itemsViewController refresh];
}

- (IBAction)onRegisterBtnSelected:(UIButton*)sender
{
    RegisterViewController * registerController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    
    [self.navigationController pushViewController:registerController animated:YES];
    [registerController release];
}

-(void) showAdsPageView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [_adsPageView.view setHidden:NO];
    [_itemsViewController.view setFrame:CGRectMake(0,
                                                   ADS_CELL_HEIGHT + CONTENT_MARGIN,
                                                   self.view.frame.size.width,
                                                   USER_WINDOW_HEIGHT - ADS_CELL_HEIGHT - CONTENT_MARGIN)];
    
    [UIView commitAnimations]; 
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
        UIBarButtonItem* refreshButton = [ViewHelper getBarItemOfTarget:self action:@selector(onRefreshBtnSelected:) title:NSLocalizedString(@"refresh", @"refresh")];
        [self.navigationItem setRightBarButtonItem:refreshButton];
    }
    else {
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
        
        [self.navigationItem setTitle:nil];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getLeftBarItemOfImageName:@"beautifuldaren_logo" rectSize:CGRectMake(0, 0, NAVIGATION_LEFT_LOGO_WIDTH, NAVIGATION_LEFT_LOGO_HEIGHT)]];
    }
}

@end
