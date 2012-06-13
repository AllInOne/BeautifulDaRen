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

-(NSInteger)getCheckedCategoriesCount;
-(NSArray*)getCheckedCategories;
@end

@implementation SelectCategoryViewController
@synthesize categoryListData = _categoryListData;
@synthesize categorySelectState = _categorySelectState;
@synthesize delegate;
@synthesize contentScrollView = _contentScrollView;

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.categorySelectState = [NSMutableArray arrayWithCapacity:[self.categoryListData count]];
    
    CGFloat contentHeight = 0.0;
    for (NSInteger index = 0; index < [self.categoryListData count]; index++) {
        SelectCategoryCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryCell" owner:self options:nil] objectAtIndex:0];
        
        cell.textLable.text = [[self.categoryListData objectAtIndex:index] objectForKey:K_BSDK_CLASSNAME];
        
        cell.frame = CGRectMake(CATEGORY_CELL_X_OFFSET + (CGRectGetWidth(cell.frame) + CATEGORY_CELL_X_MARGIN) * (index % 2), 
                                CATEGORY_CELL_Y_OFFSET + (CGRectGetHeight(cell.frame) + CATEGORY_CELL_Y_MARGIN) * (index/2), CGRectGetWidth(cell.frame), 
                                CGRectGetHeight(cell.frame));
        
        contentHeight = CATEGORY_CELL_Y_OFFSET + (CGRectGetHeight(cell.frame) + CATEGORY_CELL_Y_MARGIN) * (index/2 + 1), CGRectGetWidth(cell.frame);
        
        [self.contentScrollView addSubview:cell];

        [self.categorySelectState addObject:[NSNumber numberWithInt:0]];
    }
    
    [self.contentScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, contentHeight)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setCategoryListData:nil];
    [self setCategorySelectState:nil];
    [self setContentScrollView:nil];
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
