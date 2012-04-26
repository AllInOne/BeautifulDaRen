//
//  UserInforCellViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserInforCellViewController.h"
#import "ViewConstants.h"
#import "WeiboComposerViewController.h"
#import "AppDelegate.h"

@implementation UserInforCellViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, USER_INFOR_CELL_HEIGHT);
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

- (IBAction)onNewWeiboButtonPressed:(id)sender
{
    WeiboComposerViewController *weiboComposerController = 
    [[[WeiboComposerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboComposerController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
}

@end
