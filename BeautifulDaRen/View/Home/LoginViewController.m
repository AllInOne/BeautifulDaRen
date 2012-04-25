//
//  LoginViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/20/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "LoginViewController.h"
#import "SinaSDKManager.h"

@implementation LoginViewController

@synthesize scrollView = _scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)onSinaLoginButtonPressed:(id)sender
{
    [[SinaSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
        NSLog(@"Sina SDK login done, status:%d", status);
        [[SinaSDKManager sharedManager] sendWeiBoWithText:@"Nice" image:[UIImage imageNamed:@"123.jpg"] doneCallback:^(AIO_STATUS status, NSDictionary *data) {
            NSLog(@"send done, status:%d", status);
        }];
    }];
}

-(IBAction)onTencentLoginButtonPressed:(id)sender
{

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 480)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
