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
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"

// TODO delete this
#import "MapViewController.h"

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"UnRegisterTopView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:topView];
    AdsPageView * adsPageView = [[[AdsPageView alloc] initWithNibName:@"AdsPageView" bundle:nil] autorelease];
    adsPageView.view.frame = CGRectMake(0, 30, self.view.frame.size.width, ADS_CELL_HEIGHT);
    [self.view insertSubview:adsPageView.view belowSubview:topView];

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
//    RegisterViewController * registerController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
//    [self.navigationController pushViewController:registerController animated:YES];
    MapViewController * mapController = [[MapViewController alloc] initWithName:@"AAA" description:@"BBB" latitude:12.32f longitude:77.12f];
    [self.navigationController pushViewController:mapController animated:YES];
}


@end
