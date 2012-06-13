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
#import "iToast.h"
#import "BSDKDefines.h"

#define MAX_CHECK_CATEGOROIES_COUNT 2

@interface SelectCategoryViewController ()
@property (nonatomic, retain) NSMutableArray * categorySelectState;

-(NSInteger)getCheckedCategoriesCount;
-(NSArray*)getCheckedCategories;
@end

@implementation SelectCategoryViewController

@synthesize categoryListTableView = _categoryListTableView;
@synthesize categoryListData = _categoryListData;
@synthesize categorySelectState = _categorySelectState;
@synthesize delegate;
@synthesize category1 = _category1;
@synthesize category2 = _category2;
@synthesize category3 = _category3;
@synthesize category4 = _category4;
@synthesize category5 = _category5;
@synthesize category6 = _category6;
@synthesize category7 = _category7;
@synthesize category8 = _category8;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];

        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onConfirmButtonClicked) title:NSLocalizedString(@"enter", @"enter")]];
        
        _categoryListData = [[NSArray alloc] initWithObjects:@"鞋子", 
                                                         @"裙子",
                                                         @"裤子",
                                                         @"衣服",
                                                         @"包包",
                                                         @"首饰",
                                                         @"眼睛",
                                                         @"手表",
                                                        nil];
        
        _categorySelectState = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0],         
                                                                [NSNumber numberWithInt:0],
                                                                [NSNumber numberWithInt:0],
                                                                [NSNumber numberWithInt:0],
                                                                [NSNumber numberWithInt:0],
                                                                [NSNumber numberWithInt:0],
                                                                [NSNumber numberWithInt:0],
                                                                [NSNumber numberWithInt:0],
                                                                [NSNumber numberWithInt:0],
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
    [_categorySelectState release];
    
    [_category1 release];
    [_category2 release];
    [_category3 release];
    [_category4 release];
    [_category5 release];
    [_category6 release];
    [_category7 release];
    [_category8 release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.categoryListTableView setDataSource:self];
    [self.categoryListTableView setDelegate:self];
    
    self.category8.text = [[self.categoryListData objectAtIndex:0] objectForKey:K_BSDK_CLASSNAME];
    self.category7.text = [[self.categoryListData objectAtIndex:1] objectForKey:K_BSDK_CLASSNAME];
    self.category6.text = [[self.categoryListData objectAtIndex:2] objectForKey:K_BSDK_CLASSNAME];
    self.category5.text = [[self.categoryListData objectAtIndex:3] objectForKey:K_BSDK_CLASSNAME];
    self.category4.text = [[self.categoryListData objectAtIndex:4] objectForKey:K_BSDK_CLASSNAME];
    self.category3.text = [[self.categoryListData objectAtIndex:5] objectForKey:K_BSDK_CLASSNAME];
    self.category2.text = [[self.categoryListData objectAtIndex:6] objectForKey:K_BSDK_CLASSNAME];
    self.category1.text = [[self.categoryListData objectAtIndex:7] objectForKey:K_BSDK_CLASSNAME];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setCategoryListData:nil];
    [self setCategoryListTableView:nil];
    [self setCategorySelectState:nil];
    
    [self setCategory1:nil];
    [self setCategory2:nil];
    [self setCategory3:nil];
    [self setCategory4:nil];
    [self setCategory5:nil];
    [self setCategory6:nil];
    [self setCategory7:nil];
    [self setCategory8:nil];
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

- (void)onConfirmButtonClicked {
    if (self.delegate) {
        [self.delegate onCategorySelected:[self getCheckedCategories]];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)onCheckBoxPressed:(UIButton*)sender
{
    switch ([[self.categorySelectState objectAtIndex:sender.tag] intValue]) {
        case 0:
            if ([self getCheckedCategoriesCount] < 2) {
                [sender setImage:[UIImage imageNamed:@"myshow_category_checked"] forState:UIControlStateNormal];
                [self.categorySelectState replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:1]];
                break;
            }
            else
            {
                [[iToast makeText:[NSString stringWithFormat:NSLocalizedString(@"prompt_category_max", @"prompt_category_max"), MAX_CHECK_CATEGOROIES_COUNT]] show];
            }
        case 1:
            [sender setImage:[UIImage imageNamed:@"myshow_category_unchecked"] forState:UIControlStateNormal];
            [self.categorySelectState replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:0]];
            break;
            
        default:
            break;
    }
}

-(NSInteger)getCheckedCategoriesCount
{
    NSInteger checkedCategoriesCount = 0;
    for (NSNumber * checkValue in self.categorySelectState) {
        if ([checkValue intValue] == 1) {
            checkedCategoriesCount++;
        }
    }
    
    return checkedCategoriesCount;
}

-(NSArray*)getCheckedCategories
{
    NSMutableArray * ret = [NSMutableArray arrayWithCapacity:10];
    NSInteger index = 0;

    for (NSNumber * checkValue in self.categorySelectState) {
        if ([checkValue intValue] == 1) {
           [ret addObject:[self.categoryListData objectAtIndex:index]];
        }
        index++;
    }
    
    return ret;
}
@end
