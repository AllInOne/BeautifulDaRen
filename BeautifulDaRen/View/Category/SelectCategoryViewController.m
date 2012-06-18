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
#import "SelectCategoryCell.h"

#define MAX_CHECK_CATEGOROIES_COUNT 2

#define CATEGORY_CELL_X_OFFSET  (10.0)
#define CATEGORY_CELL_X_MARGIN  (10.0)
#define CATEGORY_CELL_Y_OFFSET  (70.0)
#define CATEGORY_CELL_Y_MARGIN  (10.0)

@interface SelectCategoryViewController ()
@property (nonatomic, retain) NSMutableArray * categorySelectState;
@property (nonatomic, retain) NSMutableArray * categorySelectCells;

-(void)clearCheckedCategories;
-(NSArray*)getCheckedCategories;
@end

@implementation SelectCategoryViewController
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
- (void)dealloc
{
    [super dealloc];
    [_categoryListData release];
    [_categorySelectState release];
    [_contentScrollView release];
    [_categorySelectCells release];
    [_initialSelectedCategoryId release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.categorySelectState = [NSMutableArray arrayWithCapacity:[self.categoryListData count]];
    self.categorySelectCells = [NSMutableArray arrayWithCapacity:[self.categoryListData count]];
    
    CGFloat contentHeight = 0.0;
    for (NSInteger index = 0; index < [self.categoryListData count]; index++) {
        SelectCategoryCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryCell" owner:self options:nil] objectAtIndex:0];
        
        cell.textLable.text = [[self.categoryListData objectAtIndex:index] objectForKey:K_BSDK_CLASSNAME];
        cell.checkBox.tag = index;
        
        cell.frame = CGRectMake(CATEGORY_CELL_X_OFFSET + (CGRectGetWidth(cell.frame) + CATEGORY_CELL_X_MARGIN) * (index % 2), 
                                CATEGORY_CELL_Y_OFFSET + (CGRectGetHeight(cell.frame) + CATEGORY_CELL_Y_MARGIN) * (index/2), CGRectGetWidth(cell.frame), 
                                CGRectGetHeight(cell.frame));
        
        contentHeight = CATEGORY_CELL_Y_OFFSET + (CGRectGetHeight(cell.frame) + CATEGORY_CELL_Y_MARGIN) * (index/2 + 1), CGRectGetWidth(cell.frame);
        
        if (self.initialSelectedCategoryId && [self.initialSelectedCategoryId isEqualToString:[[self.categoryListData objectAtIndex:index] objectForKey:K_BSDK_UID]]) {
            [cell.checkBox setImage:[UIImage imageNamed:@"myshow_category_checked"] forState:UIControlStateNormal];
            [self.categorySelectState addObject:[NSNumber numberWithInt:1]];
        }
        else
        {
            [self.categorySelectState addObject:[NSNumber numberWithInt:0]];
        }
        
        [self.contentScrollView addSubview:cell];
        
        [self.categorySelectCells addObject:cell];


    }
    
    [self.contentScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, contentHeight)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setCategoryListData:nil];
    [self setCategorySelectState:nil];
    [self setContentScrollView:nil];
    [self setCategorySelectCells:nil];
    [self setInitialSelectedCategoryId:nil];
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

-(IBAction)onCheckBoxPressed:(UIButton*)sender
{
    [self clearCheckedCategories];
    [sender setImage:[UIImage imageNamed:@"myshow_category_checked"] forState:UIControlStateNormal];
    [self.categorySelectState replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:1]];

}

-(void)clearCheckedCategories
{
    
    for (NSInteger index = 0; index < [self.categorySelectState count]; index++) {
        NSNumber * checkValue = [self.categorySelectState objectAtIndex:index];
        if ([checkValue intValue] == 1) {
            [self.categorySelectState replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
            [((SelectCategoryCell*)[self.categorySelectCells objectAtIndex:index]).checkBox setImage:[UIImage imageNamed:@"myshow_category_unchecked"] forState:UIControlStateNormal];
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
