//
//  SelectCityViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectCityViewController.h"
#import "ViewConstants.h"
#import "ViewHelper.h"

@interface SelectCityViewController ()

@property (nonatomic, retain) NSArray * cityListData;
@end

@implementation SelectCityViewController

@synthesize cityListTableView = _cityListTableView;
@synthesize cityListData = _cityListData;
@synthesize delegate = _delegate;

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
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];

        _cityListData = [[NSArray alloc] initWithObjects:@"北京",
                                                        @"上海",
                                                        @"深圳",
                                                        @"广州", 
                                                        @"成都",
                                                        @"重庆",
                                                        @"长沙",
                                                        @"苏州",
                                                        @"杭州",
                                                        @"沈阳",
                                                        @"大连",
                                                        @"青岛",
                                                        @"天津",
                                                        @"南京",
                                                        @"哈尔滨",
                                                        @"武汉",
                                                        @"长春",
                                                        @"西安",
                                                        @"温州",
                                                        @"昆明",
                                                        @"无锡",
                                                        @"太原",
                                                        @"济南",
                                                        @"乌鲁木齐",
                                                        @"兰州",
                                                        @"石家庄",
                                                        @"银川",
                                                        @"合肥",
                                                        @"贵阳",
                                                        @"昆明",
                                                        @"南宁",
                                                        @"南昌",
                                                        @"福州",
                                                        @"厦门",
                                                        @"呼和浩特",
                                                        @"郑州",
                                                        @"海口",
                                                        @"台北",
                                                        @"香港",
                                                        @"澳门",
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
    [self dismissModalViewControllerAnimated:YES];

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
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
