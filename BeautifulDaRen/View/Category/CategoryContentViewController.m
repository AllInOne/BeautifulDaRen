//
//  CategoryContentViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryContentViewController.h"
#import "CommonScrollView.h"
#import "CategoryItemCell.h"
#import "ViewConstants.h"

#define CATEGORY_CONTENT_Y_OFFSET   (70.0)
#define CATEGORY_ITEM_HEIGHT        (120.0)

@interface CategoryContentViewController ()

@end

@implementation CategoryContentViewController

@synthesize categoryListView = _categoryListView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // TODO: Read categories from network
        NSInteger index = 0;
        CGFloat height = CATEGORY_CONTENT_Y_OFFSET;
        NSArray * titles = [NSArray arrayWithObjects:@"女装", @""@"上装", @"化妆品", @"裙子", nil];
        while (index < [titles count]) {
            CategoryItemCell * categoryCell = [[CategoryItemCell alloc] initWithNibName:nil bundle:nil title:[titles objectAtIndex:index] andData:nil];
            
            categoryCell.view.frame = CGRectMake(0, CATEGORY_CONTENT_Y_OFFSET, CGRectGetWidth(self.view.frame), [categoryCell getHeight]);
            
            [self.categoryListView addSubview: categoryCell.view];
        }
        
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

@end
