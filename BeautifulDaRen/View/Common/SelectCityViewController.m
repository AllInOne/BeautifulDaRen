//
//  SelectCityViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectCityViewController.h"

@interface SelectCityViewController ()

@property (nonatomic, retain) NSArray * cityListData;
@property (nonatomic, assign) id<SelectCityProtocol> delegate;
@end

@implementation SelectCityViewController

@synthesize cityListTableView = _cityListTableView;
@synthesize cityListData = _cityListData;
@synthesize delegate;

- (void)dealloc
{
    [_cityListData release];
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
        
        _cityListData = [[NSArray alloc] initWithObjects:@"成都", 
                                                        @"北京",
                                                        @"上海",
                                                        @"深圳",
                                                        @"重庆",
                                                        @"南京",
                                                        @"拉萨",
                                                        @"天津",
                                                        @"广州",
                                                        @"海口",
                                                        @"哈尔滨",
                                                        @"石家庄",
                                                        @"武汉",
                                                        @"长沙",
                                                        @"珠海",
                                                        @"苏州",
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
    [self.cityListTableView setDelegate:self];
    [self.cityListTableView setDataSource:self];
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
    [self.delegate onCitySelected:[self.cityListData objectAtIndex:[indexPath row]]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - UITableViewDataSource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cityListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.cityListData objectAtIndex:[indexPath row]];
    
    return cell;
}

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

@end
