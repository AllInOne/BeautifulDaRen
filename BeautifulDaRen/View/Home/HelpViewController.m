//
//  HelpViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/16/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "HelpViewController.h"
#import "ViewHelper.h"
#import "BSDKManager.h"

@interface HelpViewController()
@property (retain, nonatomic) IBOutlet UITextView *textView;

@end

@implementation HelpViewController
@synthesize textView = _textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"title_help", @"title_help")];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back",@"go_back")]];
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(backToHomePageButtonClicked) title:NSLocalizedString(@"title_home",@"title_home")]];
    }
    return self;
}

- (void)onBackButtonClicked
{
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)backToHomePageButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    activityIndicator.frame = CGRectMake((self.view.frame.size.width - activityIndicator.frame.size.width) / 2,
                                         15,
                                         activityIndicator.frame.size.width,
                                         activityIndicator.frame.size.height);
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [[BSDKManager sharedManager] getHelpAndCallback:^(AIO_STATUS status, NSDictionary *data) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [activityIndicator release];
        self.textView.text = [data valueForKey:@"msg"];
    }];
}

-(void)dealloc
{
    [super dealloc];
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
