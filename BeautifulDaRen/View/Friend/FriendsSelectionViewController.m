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
#import "ViewConstants.h"
#import "BSDKDefines.h"
#import "BSDKManager.h"
#import "iToast.h"

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
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        
        [self.navigationItem setTitle:NSLocalizedString(@"at_my_followed_person", @"at_my_followed_person")];
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
    
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.frame = CGRectMake(SCREEN_WIDTH/2, 2*ADS_CELL_HEIGHT + CONTENT_MARGIN, CGRectGetWidth(activityIndicator.frame), CGRectGetHeight(activityIndicator.frame));
    
    [self.view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];

    [[BSDKManager sharedManager] getFollowList:GET_CURRENT_USER_INFO_BY_KEY(K_BSDK_UID) pageSize:500 pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [activityIndicator release];
        
        if (K_BSDK_IS_RESPONSE_OK(data)) {
            NSArray * userList = [data objectForKey:K_BSDK_USERLIST];
            NSMutableArray * friendList = [NSMutableArray arrayWithCapacity:[userList count]];
            
            for(NSDictionary * user in userList)
            {
                [friendList addObject:[[user objectForKey:K_BSDK_ATTENTIONUSERINFO] objectForKey:K_BSDK_USERNAME]];
            }
            
            self.friendsList = friendList;
            [self preloadView];
        }
        else
        {
            [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
        }
    }];
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
    // We MUST put super dealloc here, or it will crash on iOS4.x, because [super dealloc] will need to touch _friendsViewController
    [super dealloc];
    
    [_friendsViewController release];
    [_selectedContacts release];
    [_friendsList release];
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
//    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end

/** @} */