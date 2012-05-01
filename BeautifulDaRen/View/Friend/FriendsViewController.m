/***********************************************************************
 *
 * Copyright (C) 2011-2012 Myriad Group AG. All Rights Reserved.
 *
 * File     :   $Id: //depot/ds/projects/MSSS/pivot/apps/Pivot/Pivot/View/Friend/FriendsViewController.m#42 $
 *
 ***********************************************************************/

/** \addtogroup VIEW
 *  @{
 */

#import "FriendsViewController.h"
#import "FriendListCellView.h"
#import "ChineseToPinyin.h"

#define DEFAULT_SECTION_LETTER @"#"
#define COLUMNS_PER_ROW 3
#define GRIDTABLECELL_FIRST_BUTTON_TAG 101
#define GRIDTABLECELL_SECOND_BUTTON_TAG 102
#define GRIDTABLECELL_THIRD_BUTTON_TAG 103

@interface FriendsViewController()

- (NSString*) sectionLetterForContact: (NSString*) contact;
- (void) createSectionsForContacts: (NSArray*) contacts;

- (void)updateViewController;

@property(assign, nonatomic) BOOL scrolling;

@end

@implementation FriendsViewController

@synthesize sections=_sections;
@synthesize sectionsArray=_sectionsArray;
@synthesize filteredContacts=_filteredContacts;
@synthesize searchController=_searchController;
@synthesize tableView=_tableView;
@synthesize scrolling=_scrolling;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateViewController];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTableView:nil];
    [self setFilteredContacts:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [_filteredContacts release];
    [_searchController release];
    [_tableView release];
    [_sections release];
    [_sectionsArray release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString*) sectionLetterForContact: (NSString*) contact {
    if (contact) {
        NSString *filteredName = [[contact uppercaseString] stringByTrimmingCharactersInSet: [[NSCharacterSet letterCharacterSet] invertedSet]];
        
        NSString* pingying = [ChineseToPinyin pinyinFromChiniseString:filteredName];
        if ([pingying length]) {
            return [pingying substringToIndex: 1];
        }
        
        return DEFAULT_SECTION_LETTER;
    }
    
    return DEFAULT_SECTION_LETTER;
}

- (void) createSectionsForContacts: (NSArray*) contacts {
    for(NSString *contact in contacts) {
        NSString *sectionLetter = [self sectionLetterForContact: contact];
        
        if (!_sections) {
            _sections = [[NSMutableDictionary alloc] init];
        }
        
        NSMutableArray *contactsInSection = [self.sections objectForKey: sectionLetter];
        
        if (!contactsInSection) {
            contactsInSection = [NSMutableArray array];
        }
        
        [contactsInSection addObject: contact];
        
        [self.sections setObject: contactsInSection forKey: sectionLetter];
    }
    self.sectionsArray = [[self.sections allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
}

/* UITableViewDelegate/UITableViewDataSource delegate methods */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *friendListTableViewCellIdentifier = @"FriendListCellView";

    NSArray *contacts = nil;
    if (tableView == self.searchController.searchResultsTableView)
    {
        contacts = self.filteredContacts;
    }
    else
    {
        contacts = [self.sections objectForKey: [self.sectionsArray objectAtIndex: indexPath.section]];
    }
    
    FriendListCellView *cell = [tableView dequeueReusableCellWithIdentifier:friendListTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:friendListTableViewCellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    cell.name.text = [contacts objectAtIndex:[indexPath row]];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *contacts = nil;
    
    if (tableView == self.searchController.searchResultsTableView)
    {
        contacts = self.filteredContacts;
    }
    else
    {
        contacts = [self.sections objectForKey: [self.sectionsArray objectAtIndex: section]];
    }
    
    return [contacts count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchController.searchResultsTableView) {
        return 1;
    }
    else {
        return [self.sectionsArray count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchController.searchResultsTableView) {
        return nil;
    }
    else {
        return [self.sectionsArray objectAtIndex:section];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchController.searchResultsTableView) {
        return nil;
    }
    else {
        return self.sectionsArray;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * contacts = nil;
    
    if (tableView == self.searchController.searchResultsTableView) {
        contacts = self.filteredContacts;
    }
    else {
        contacts = [self.sections objectForKey: [self.sectionsArray objectAtIndex: indexPath.section]];
    }
    
    NSString* contactId = [contacts objectAtIndex: indexPath.row];
    [self.delegate didFinishContactSelectionWithContacts:contactId];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    tableView.bounds = CGRectMake(tableView.bounds.origin.x, tableView.bounds.origin.y, self.tableView.frame.size.width, tableView.bounds.size.height);
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if (!_filteredContacts) {
        _filteredContacts = [[NSMutableArray alloc] init];
    }

    [self.filteredContacts removeAllObjects];
    
    for (id key in self.sections)
    {
        NSArray *section = [self.sections objectForKey:key];
        
        for (NSString *contactId in section)
        {
            if (([contactId rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
                || ([[ChineseToPinyin pinyinFromChiniseString:contactId] rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)) {
                [self.filteredContacts addObject:contactId];
            }
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [[self.searchController.searchBar scopeButtonTitles] objectAtIndex:[self.searchController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:[self.searchController.searchBar text] scope:
     [[self.searchController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];

    return YES;
}

- (void)refreshVisibleData {
    if (!_tableView.dragging && !_tableView.decelerating) {
        [_tableView reloadData];
    }
}

#pragma mark - BaseViewController subclass

- (void)updateViewController {
    NSArray* allContacts = [NSArray arrayWithObjects:@"Andrew", @"Breck", @"Cary", @"Hok", @"李蕾", @"韩梅梅", nil];
    [self.sections removeAllObjects];
    [self createSectionsForContacts: allContacts];
    
    [self.tableView reloadData];
}

- (void)imageLoadedForContact:(NSString *)contactId {
    [self refreshVisibleData];
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self refreshVisibleData];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self refreshVisibleData];
    }
}

@end

/** @} */
