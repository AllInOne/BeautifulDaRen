//
//  CategorySelectViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategorySelectViewController.h"
#import "ViewHelper.h"
#import "BSDKDefines.h"
#import "ViewConstants.h"
#import "CategoryItemViewController.h"

#define MAX_CHECK_CATEGOROIES_COUNT 2

#define CATEGORY_CELL_X_OFFSET  (10.0)
#define CATEGORY_CELL_X_MARGIN  (10.0)
#define CATEGORY_CELL_Y_OFFSET  (70.0)
#define CATEGORY_CELL_Y_MARGIN  (10.0)

@interface CategorySelectViewController ()
@property (nonatomic, retain) NSMutableArray * categorySelectState;
@property (nonatomic, retain) NSMutableArray * categorySelectCells;

-(void)clearCheckedCategories;
-(NSArray*)getCheckedCategories;
@end

@implementation CategorySelectViewController

@synthesize categoryListData = _categoryListData;
@synthesize categorySelectState = _categorySelectState;
@synthesize delegate;
@synthesize contentScrollView = _contentScrollView;
@synthesize categorySelectCells = _categorySelectCells;
@synthesize initialSelectedCategoryId = _initialSelectedCategoryId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onConfirmButtonClicked) title:NSLocalizedString(@"enter", @"enter")]];
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
    
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.frame = self.view.frame;
    [self.view addSubview:_contentScrollView];
    // Do any additional setup after loading the view from its nib.
    self.categorySelectState = [NSMutableArray arrayWithCapacity:[self.categoryListData count]];
    self.categorySelectCells = [NSMutableArray arrayWithCapacity:[self.categoryListData count]];
    
    CGFloat contentHeight = 0.0;
    for (NSInteger index = 0; index < [self.categoryListData count]; index++) {
        CategoryItemViewController* cell = [[CategoryItemViewController alloc] initWithNibName:nil bundle:nil];
        
        cell.view.frame = CGRectMake(CATEGORY_CELL_X_OFFSET + (CGRectGetWidth(cell.view.frame) + CATEGORY_CELL_X_MARGIN) * (index % 2), 
                                CATEGORY_CELL_Y_OFFSET + (CGRectGetHeight(cell.view.frame) + CATEGORY_CELL_Y_MARGIN) * (index/2), CGRectGetWidth(cell.view.frame), 
                                CGRectGetHeight(cell.view.frame));
        
        contentHeight = CATEGORY_CELL_Y_OFFSET + (CGRectGetHeight(cell.view.frame) + CATEGORY_CELL_Y_MARGIN) * (index/2 + 1), CGRectGetWidth(cell.view.frame);
        
        if (self.initialSelectedCategoryId && [self.initialSelectedCategoryId isEqualToString:[[self.categoryListData objectAtIndex:index] objectForKey:K_BSDK_UID]]) {
            [cell.radioImage setImage:[UIImage imageNamed:@"radio_btn_selected"]];
            [self.categorySelectState addObject:[NSNumber numberWithInt:1]];
        }
        else
        {
            [cell.radioImage setImage:[UIImage imageNamed:@"radio_btn_unselected"]];
            [self.categorySelectState addObject:[NSNumber numberWithInt:0]];
        }
        
        cell.textLable.text = [[self.categoryListData objectAtIndex:index] objectForKey:K_BSDK_CLASSNAME];
        cell.cellButton.tag = index;
        
        [cell setDelegate:self];
        
        [self.categorySelectCells addObject:cell];
        
        [self.contentScrollView addSubview:cell.view];
    }
    
    [self.contentScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, contentHeight)];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setCategorySelectState:nil];
    [self setContentScrollView:nil];
    [self setCategorySelectCells:nil];
    [self setInitialSelectedCategoryId:nil];
}

- (void)dealloc
{
    for (CategoryItemViewController * item in self.categorySelectCells) {
        [item.view removeFromSuperview];
    }
    [self.categorySelectCells removeAllObjects];
    [_categorySelectCells release];
    
    [_categoryListData release];
    [_categorySelectState release];
    [_contentScrollView release];
    
    [_initialSelectedCategoryId release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

-(void)onCheckBoxPressed:(UIButton*)sender
{
    [self clearCheckedCategories];
    [((CategoryItemViewController*)[self.categorySelectCells objectAtIndex:sender.tag]).radioImage setImage:[UIImage imageNamed:@"radio_btn_selected"]];
    
    [self.categorySelectState replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:1]];
    
}

-(void)clearCheckedCategories
{
    
    for (NSInteger index = 0; index < [self.categorySelectState count]; index++) {
        NSNumber * checkValue = [self.categorySelectState objectAtIndex:index];
        if ([checkValue intValue] == 1) {
            [self.categorySelectState replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
            [((CategoryItemViewController*)[self.categorySelectCells objectAtIndex:index]).radioImage setImage:[UIImage imageNamed:@"radio_btn_unselected"]];
        }
    }
}

-(NSArray*)getCheckedCategories
{
    NSMutableArray * ret = [NSMutableArray arrayWithCapacity:10];
    NSInteger index = 0;
    
    for (NSNumber * checkValue in self.categorySelectState) {
        if ([checkValue intValue] == 1) {
            [ret addObject:[[self.categoryListData objectAtIndex:index] objectForKey:K_BSDK_UID]];
        }
        index++;
    }
    
    return ret;
}

@end
