//
//  SelectCategoryViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import "ViewConstants.h"
#import "ViewHelper.h"

@interface SelectCategoryViewController ()

@property (nonatomic, retain) NSArray * categoryListData;
@end

@implementation SelectCategoryViewController

@synthesize categoryListTableView = _categoryListTableView;
@synthesize categoryListData = _categoryListData;
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        
        _categoryListData = [[NSArray alloc] initWithObjects:@"鞋子", 
                                                         @"裙子",
                                                         @"裤子",
                                                         @"衣服",
                                                         @"包包",
                                                         @"首饰",
                                                         @"眼睛",
                                                         @"手表",
                                                        nil];
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
- (void)dealloc
{
    [super dealloc];
    [_categoryListData release];
    [_categoryListTableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.categoryListTableView setDataSource:self];
    [self.categoryListTableView setDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.categoryListData = nil;
    self.categoryListTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate onCategorySelected:[self.categoryListData objectAtIndex:[indexPath row]]];
    [self dismissModalViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - UITableViewDataSource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categoryListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.categoryListData objectAtIndex:[indexPath row]];
    
    return cell;
}

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}
@end
