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
#import "ViewHelper.h"

@interface FriendsSelectionViewController()

@property (nonatomic, retain) FriendsViewController * friendsViewController;

@end

@implementation FriendsSelectionViewController

@synthesize selectedContacts=_selectedContacts;
@synthesize friendsViewController = _friendsViewController;
@synthesize friendsList = _friendsList;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
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
        _friendsViewController.friendsList = self.friendsList;
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
    self.friendsViewController = nil;
}

- (void)dealloc {
    [_friendsViewController release];
    [_selectedContacts release];
    [_friendsList release];
    
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
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end

/** @} */