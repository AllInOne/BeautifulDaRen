//
//  WeiboDetailViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboDetailViewController.h"
#import "ViewConstants.h"

@implementation WeiboDetailViewController

@synthesize userInforCellView = _userInforCellView;
@synthesize userId = _userId;
@synthesize detailScrollView = _detailScrollView;

- (void)dealloc
{
    [_userInforCellView release];
    [_detailScrollView release];
    [_userId release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onBackButtonClicked)];
        [self.navigationItem setLeftBarButtonItem:backButton];
        
        [backButton release];
        // Custom initialization
        if (self.userInforCellView == nil) {
            _userInforCellView = [[UserInforCellViewController alloc] initWithNibName:@"UserInforCellViewController" bundle:nil];
            _userInforCellView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, USER_INFOR_CELL_HEIGHT);
            [_detailScrollView addSubview:_userInforCellView.view];
        }
        [_detailScrollView setContentSize:CGSizeMake(320, 600)];
    }
    return self;
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

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

@end
