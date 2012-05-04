//
//  SelectCategoryViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectCategoryViewController.h"

@interface SelectCategoryViewController ()

@property (nonatomic, retain) NSArray * categoryListData;
@end

@implementation SelectCategoryViewController

@synthesize categoryListTableView = _categoryListTableView;
@synthesize categoryListData = _categoryListData;
@synthesize delegate;

- (void)dealloc
{
    [_categoryListData release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onBackButtonClicked)];
        [self.navigationItem setLeftBarButtonItem:backButton];
        
        [backButton release];
        
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
