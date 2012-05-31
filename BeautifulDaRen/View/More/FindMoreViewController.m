//
//  FindMoreViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/8/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FindMoreViewController.h"
#import "ContactItemCell.h"
#import "ViewConstants.h"
#import "ViewHelper.h"
#import "FindFriendViewCell.h"
#import "FindWeiboViewCell.h"
#import "FriendDetailViewController.h"
#import "FindWeiboViewController.h"
#import "BorderImageView.h"

#define X_OFFSET 7
#define CONTENT_VIEW_HEIGHT_OFFSET 50
@interface FindMoreViewController()

@property (retain, nonatomic) IBOutlet UIButton * followOrInviteSinaWeiboFriendButton;
@property (retain, nonatomic) IBOutlet UIScrollView * contentScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView * sameCityDaRenView;
@property (retain, nonatomic) IBOutlet UIScrollView * youMayInterestinView;
@property (retain, nonatomic) IBOutlet UIScrollView * hotDaRenView;

@property (retain, nonatomic) IBOutlet UITableView * friendViewController;
@property (retain, nonatomic) IBOutlet UISearchBar * searchBar;
@property (nonatomic, copy) NSArray *allItems;
@property (nonatomic, copy) NSArray *searchResults;

@property (nonatomic, assign) BOOL isFindWeibo;
- (void) refreshSameCityDaRenView;
- (void) refreshYouMayInterestinView;
- (void) refreshHotDaRenView;

@end

@implementation FindMoreViewController
@synthesize sameCityDaRenView = _sameCityDaRenView;
@synthesize youMayInterestinView = _youMayInterestinView;
@synthesize hotDaRenView = _hotDaRenView;
@synthesize contentScrollView = _contentScrollView;
@synthesize friendViewController = _friendViewController;
@synthesize searchBar = _searchBar;
@synthesize isFindWeibo = _isFindWeibo;

@synthesize followOrInviteSinaWeiboFriendButton = _followOrInviteSinaWeiboFriendButton;

@synthesize allItems = _allItems;
@synthesize searchResults = _searchResults;

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

- (void)onRefreshButtonClicked
{
    [ViewHelper showSimpleMessage:@"刷新" withTitle:nil withButtonText:@"关闭"];
}
#pragma mark - View lifecycle
-(void)dealloc
{
    [_sameCityDaRenView release];
    [_hotDaRenView release];
    [_youMayInterestinView release];
    [super dealloc];
}

-(void)refreshView
{
    [self refreshSameCityDaRenView];
    [self refreshHotDaRenView];
    [self refreshYouMayInterestinView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _allItems = [[NSArray alloc] initWithObjects:
     @"西西110",
     @"雅力士",
     @"Voltes V",
     @"葫芦娃",
     @"Daimos",
     nil];
    _isFindWeibo = NO;
    [self.navigationItem setTitle:NSLocalizedString(@"find_weibo_or_friend", @"find_weibo_or_friend")];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    {
        _searchBar.backgroundImage = [UIImage imageNamed:@"search_switcher_btn"];
        _searchBar.scopeBarBackgroundImage = [UIImage imageNamed:@"search_switcher_btn"];
        [_searchBar setScopeBarButtonBackgroundImage:[UIImage imageNamed:@"search_switcher_selected"] forState:UIControlStateSelected];
        [_searchBar setScopeBarButtonBackgroundImage:[UIImage imageNamed:@"search_switcher_unselected"] forState:UIControlStateNormal];
        [_searchBar setScopeBarButtonDividerImage:[UIImage imageNamed:@"searchScopeDividerRightSelected"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected];
        [_searchBar setScopeBarButtonDividerImage:[UIImage imageNamed:@"searchScopeDividerLeftSelected"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal];
    }
    else
    {
    }
    _searchBar.scopeButtonTitles = [NSArray arrayWithObjects:
                                    NSLocalizedString(@"weibo", @""),
                                    NSLocalizedString(@"user", @""), nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_contentScrollView setContentSize:CGSizeMake(0, 360)];
    [_contentScrollView setFrame:CGRectMake(0, CONTENT_VIEW_HEIGHT_OFFSET, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height)];
    
    [self.view addSubview:_contentScrollView];
    
    [_friendViewController setFrame:CGRectMake(0, CONTENT_VIEW_HEIGHT_OFFSET + 44.0f, _friendViewController.frame.size.width,270)];
    [self.view addSubview:_friendViewController];
    [_friendViewController setHidden:YES];
    [self refreshView];
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

- (void)refreshSameCityDaRenView
{
    static NSString * cellViewIdentifier = @"ContactItemCell";
    NSInteger scrollWidth = 0;
    NSArray * avatars = [NSArray arrayWithObjects:
                         @"search_avatar_sample1",
                         @"search_avatar_sample2",
                         @"search_avatar_sample3",
                         @"search_avatar_sample4",
                         @"search_avatar_sample5",
                         @"search_avatar_sample6",
                         @"search_avatar_sample7",
                         @"search_avatar_sample8",
                         @"search_avatar_sample9",
                         @"search_avatar_sample10",
                         @"search_avatar_sample11",
                         nil];
    for (int i = 0; i < [avatars count]; i++) {
        ContactItemCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellViewIdentifier owner:self options:nil] objectAtIndex:0];
        
        cell.frame = CGRectMake(i * (cell.frame.size.width + X_OFFSET), 0,
                                cell.frame.size.width,
                                cell.frame.size.height);
        scrollWidth += (cell.frame.size.width + X_OFFSET);
        
        [_sameCityDaRenView addSubview:cell];
    
        BorderImageView * borderImageView = [[[BorderImageView alloc] initWithFrame:cell.contactImageView.frame andImage:[UIImage imageNamed:[avatars objectAtIndex:i]]] autorelease];
        [cell addSubview:borderImageView];
        cell.contactLabel.text = @"宇多田光";
    }
    [_sameCityDaRenView setContentSize:CGSizeMake(scrollWidth, 0)];
}

-(void) refreshYouMayInterestinView
{
    static NSString * cellViewIdentifier = @"ContactItemCell";
    NSInteger scrollWidth = 0;
    NSArray * avatars = [NSArray arrayWithObjects:
                         @"search_avatar_sample5",
                         @"search_avatar_sample6",
                         @"search_avatar_sample7",
                         @"search_avatar_sample8",
                         @"search_avatar_sample9",
                         @"search_avatar_sample10",
                         @"search_avatar_sample11",
                         @"search_avatar_sample1",
                         @"search_avatar_sample2",
                         @"search_avatar_sample3",
                         @"search_avatar_sample4",
                         nil];
    for (int i = 0; i < [avatars count]; i++) {
        ContactItemCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellViewIdentifier owner:self options:nil] objectAtIndex:0];
        cell.frame = CGRectMake(i * (cell.frame.size.width + X_OFFSET), 0,
                                cell.frame.size.width,
                                cell.frame.size.height);
        scrollWidth += (cell.frame.size.width + X_OFFSET);
        
        [_youMayInterestinView addSubview:cell];
        
        BorderImageView * borderImageView = [[[BorderImageView alloc] initWithFrame:cell.contactImageView.frame andImage:[UIImage imageNamed:[avatars objectAtIndex:i]]] autorelease];
        [cell addSubview:borderImageView];
        cell.contactLabel.text = @"美丽达人";
    }
    [_youMayInterestinView setContentSize:CGSizeMake(scrollWidth, 0)];
}

- (void) refreshHotDaRenView
{
    static NSString * cellViewIdentifier = @"ContactItemCell";
    NSInteger scrollWidth = 0;
    NSArray * avatars = [NSArray arrayWithObjects:
                         @"search_avatar_sample9",
                         @"search_avatar_sample10",
                         @"search_avatar_sample11",
                         @"search_avatar_sample1",
                         @"search_avatar_sample2",
                         @"search_avatar_sample3",
                         @"search_avatar_sample4",
                         @"search_avatar_sample5",
                         @"search_avatar_sample6",
                         @"search_avatar_sample7",
                         @"search_avatar_sample8",
                         nil];
    for (int i = 0; i < [avatars count]; i++) {
        ContactItemCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellViewIdentifier owner:self options:nil] objectAtIndex:0];
        cell.frame = CGRectMake(i * (cell.frame.size.width + X_OFFSET), 0,
                                cell.frame.size.width,
                                cell.frame.size.height);
        scrollWidth += (cell.frame.size.width + X_OFFSET);
        
        [_hotDaRenView addSubview:cell];
        
        BorderImageView * borderImageView = [[[BorderImageView alloc] initWithFrame:cell.contactImageView.frame andImage:[UIImage imageNamed:[avatars objectAtIndex:i]]] autorelease];
        [cell addSubview:borderImageView];
        cell.contactLabel.text = @"小清新";
    }
    [_hotDaRenView setContentSize:CGSizeMake(scrollWidth, 0)];
}
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isFindWeibo == NO)
    {
        FriendDetailViewController *weiboDetailController = 
        [[[FriendDetailViewController alloc] init] autorelease];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
        
        [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
        
        [navController release];
    }
    else
    {
        FindWeiboViewController *weiboDetailController = 
        [[[FindWeiboViewController alloc] init] autorelease];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
        
        [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
        
        [navController release];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    if(_isFindWeibo == NO)
    {
        height = 75.0f;
    }
    else
    {
        height = 44.0f;
    }
    return height;
}

#pragma mark UITableViewDataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        rows = [_searchResults count];
    }
    else
    {
        rows = [_allItems count];
    }
    return  rows;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *findFriendViewCell = @"FindFriendViewCell";
    static NSString *findWeiboViewCell = @"FindWeiboViewCell";
    
    UITableViewCell *cell = nil;
    if (_isFindWeibo == NO) {
        cell = [tableView dequeueReusableCellWithIdentifier:findFriendViewCell];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:findFriendViewCell owner:self options:nil] objectAtIndex:0];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:findWeiboViewCell];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:findWeiboViewCell owner:self options:nil] objectAtIndex:0];
        }
    }
    return cell;
}

#pragma mark COMMON
- (void)filterContentForSearchText:(NSString*)searchText 
                             scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate 
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    self.searchResults = [self.allItems filteredArrayUsingPredicate:resultPredicate];
}
#pragma mark - UISearchBarDelegate delegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    CGFloat height = 44.0f;
    BOOL isShowsCancelButton = NO;
    BOOL isShowsScopeButton = NO;
    if([searchText length] > 0)
    {
        height = 88.0f;
        isShowsCancelButton = YES;
        isShowsScopeButton = YES;
        if(_contentScrollView.frame.origin.y == CONTENT_VIEW_HEIGHT_OFFSET)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            [_contentScrollView setFrame:CGRectMake(_contentScrollView.frame.origin.x, CONTENT_VIEW_HEIGHT_OFFSET + 44.0f, _contentScrollView.frame.size.width,_contentScrollView.frame.size.height)];
            
            [UIView commitAnimations];
        }
    }
    else
    {
        height = 44.0f;
        
        isShowsCancelButton = NO;
        isShowsScopeButton = NO;
        if(_contentScrollView.frame.origin.y == CONTENT_VIEW_HEIGHT_OFFSET + 44.0f)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            [_contentScrollView setFrame:CGRectMake(_contentScrollView.frame.origin.x, CONTENT_VIEW_HEIGHT_OFFSET, _contentScrollView.frame.size.width,_contentScrollView.frame.size.height)];
            
            [UIView commitAnimations];
        }
    }
    
    [searchBar setShowsCancelButton:isShowsCancelButton animated:YES];
    [searchBar setShowsScopeBar:isShowsScopeButton];
    [searchBar setSelectedScopeButtonIndex:1];
    [searchBar setFrame:CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, searchBar.frame.size.width, height)];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_contentScrollView setHidden:YES];
    [_friendViewController setHidden:NO];
    [searchBar endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [_friendViewController setHidden:YES];
    [_contentScrollView setHidden:NO];

    searchBar.text = @"";
    [searchBar endEditing:YES];
    [searchBar setShowsScopeBar:NO];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar setFrame:CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, searchBar.frame.size.width, 44.0f)];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [_contentScrollView setFrame:CGRectMake(_contentScrollView.frame.origin.x, CONTENT_VIEW_HEIGHT_OFFSET, _contentScrollView.frame.size.width,_contentScrollView.frame.size.height)];
    
    [UIView commitAnimations];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    _isFindWeibo = (selectedScope ==0) ? YES : NO;
    [_friendViewController reloadData];
}
@end
