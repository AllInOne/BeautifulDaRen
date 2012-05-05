//
//  FriendsSelectionViewController.m
//  Pivot
//
//  Created by Krzysztof Siejkowski on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

/** \addtogroup VIEW
 *  @{
 */

#import "FriendsSelectionViewController.h"
#import "FriendsViewController.h"

@interface FriendsSelectionViewController()

@property (nonatomic, retain) FriendsViewController * friendsViewController;

@end

@implementation FriendsSelectionViewController

@synthesize selectedContacts=_selectedContacts;
@synthesize friendsViewController = _friendsViewController;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setBackgroundImage:[UIImage imageNamed:@"顶部按钮50x29.png"] forState:UIControlStateNormal];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(onBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        backButton.frame = CGRectMake(0, 0, 50, 30);
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
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
    
    [self preloadView];
}

- (void)preloadView {
    if (_friendsViewController == nil) {
        _friendsViewController = [[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil];
        [_friendsViewController setDelegate:self];
        _friendsViewController.view.frame = CGRectMake(0, 44, self.view.frame.size.width, 375);
        [self.view addSubview:_friendsViewController.view];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.searchDisplayController setDelegate:_friendsViewController];
    [self.searchDisplayController setSearchResultsDelegate:_friendsViewController];
    [self.searchDisplayController setSearchResultsDataSource:_friendsViewController];
    _friendsViewController.searchController = self.searchDisplayController;
    [self.friendsViewController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.friendsViewController viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_friendsViewController.view removeFromSuperview];
}

- (void)dealloc {
    [_friendsViewController release];
    [_selectedContacts release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didFinishContactSelectionWithContacts:(NSString *)friendId
{
    if ([self.delegate respondsToSelector:@selector(didFinishContactSelectionWithContacts:)]) {
        [self.delegate didFinishContactSelectionWithContacts:friendId];
    }
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

@end

/** @} */