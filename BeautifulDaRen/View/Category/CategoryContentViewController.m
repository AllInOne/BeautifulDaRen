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
        CGFloat height = CONTENT_MARGIN;
        NSArray * titles = [NSArray arrayWithObjects:@"女装", @"上装", @"化妆品", @"裙子", nil];
        NSArray * array1 = [NSArray arrayWithObjects:
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample1"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample2"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample3"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample4"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample5"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample6"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample7"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample8"]),
                            nil];
        NSArray * array2 = [NSArray arrayWithObjects:
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_food_sample1"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_food_sample2"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_food_sample3"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_food_sample4"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_food_sample1"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_food_sample2"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_food_sample3"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_food_sample4"]),
                            nil];
        NSArray * array3 = [NSArray arrayWithObjects:
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_toiletry_sample1"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_toiletry_sample2"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_toiletry_sample3"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_toiletry_sample4"]), 
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_toiletry_sample1"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_toiletry_sample2"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_toiletry_sample3"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_toiletry_sample4"]),
                            nil];
        NSArray * array4 = [NSArray arrayWithObjects:
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample1"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample2"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample3"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample4"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample5"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample6"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample7"]),
                                UIImagePNGRepresentation([UIImage imageNamed:@"hot_clothes_sample8"]),
                                nil];
        NSArray * arrays = [NSArray arrayWithObjects:
                            array1,
                            array2, 
                            array3, 
                            array4, 
                            nil];
        while (index < [titles count]) {
            CategoryItemCell * categoryCell = [[CategoryItemCell alloc] initWithNibName:nil bundle:nil title:[titles objectAtIndex:index] andData:[arrays objectAtIndex:index]];
            
            categoryCell.view.frame = CGRectMake(0, height, CGRectGetWidth(self.view.frame), [categoryCell getHeight]);
            
            height += ([categoryCell getHeight] + CONTENT_MARGIN);
            
            [self.categoryListView addSubview: categoryCell.view];
            index++;
        }
        
        [self.categoryListView setContentSize:CGSizeMake(SCREEN_WIDTH, height)];
        [self.categoryListView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        
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
