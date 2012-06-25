//
//  ItemsViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ItemsViewController.h"
#import "ViewConstants.h"
#import "WaresItem.h"
#import "WeiboDetailViewController.h"
#import "ViewHelper.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "BorderImageView.h"

#define COLUMNS_PER_ROW 4
#define GRID_X_OFFSET 3
#define GRID_Y_OFFSET 5

#define GRID_X_DELTA 80
#define GRID_Y_DELTA 80

@interface ItemsViewController()

@property (retain, nonatomic) NSMutableArray * itemDatas;
@property (retain, nonatomic) NSMutableArray * itemsHeight;
-(void)loadItemsHeight;

@end

@implementation ItemsViewController
@synthesize waterFlowView = _waterFlowView;
@synthesize itemDatas = _itemDatas;
@synthesize itemsHeight = _itemsHeight;

-(id)initWithArray:(NSArray*)array
{
    self = [super initWithNibName:@"ItemsViewController" bundle:nil];
    if (self) {
        self.itemDatas = [NSMutableArray arrayWithArray:array];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View

- (void) loadItemsHeight
{
    NSInteger count = [self.itemDatas count];
    for (int i = 0; i < count; i++)
    {
        CGFloat picWidth = [[[self.itemDatas objectAtIndex:i] valueForKey:@"Picture_width"] floatValue];
        CGFloat picHeight = [[[self.itemDatas objectAtIndex:i] valueForKey:@"Picture_height"] floatValue];
        CGFloat frameWidth = (self.view.frame.size.width - 14) / 3;
        CGFloat frameHeight = (frameWidth / picWidth) * picHeight;
        [_itemsHeight addObject:[NSNumber numberWithFloat:(frameHeight+4)]];
    }
}

#pragma mark - View lifecycle

-(void) dealloc
{
    [_waterFlowView release];
    [_itemsHeight release];
    [_itemDatas release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _itemsHeight = [[NSMutableArray alloc] init];
    [self loadItemsHeight];
    
    _waterFlowView = [[WaterFlowView alloc] initWithFrame:self.view.frame];
    _waterFlowView.flowdelegate = self;
    _waterFlowView.flowdatasource = self;
    [self.view addSubview:_waterFlowView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.waterFlowView = nil;
    self.itemsHeight = nil;
    self.itemDatas = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(cellSelected:)
                                                 name:@"borderImageViewSelected"
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)cellSelected:(NSNotification *)notification
{
// TODO: [Jerry] need to set the weiboData of WeiboDetailViewController
//    WeiboDetailViewController *weiboDetailController = 
//    [[WeiboDetailViewController alloc] init];
//    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
//    
//    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
//    
//    [navController release];
//    [weiboDetailController release];
}

#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterFlowView *)flowView
{
    return 3;
}

- (NSInteger)flowView:(WaterFlowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    return [self.itemDatas count] / 3;
}

- (WaterFlowCell *)flowView:(WaterFlowView *)flowView cellForRowAtIndex:(NSInteger)index
{
    static NSString *cellIdentifier = @"WaterFlowCell";
	WaterFlowCell *cell = nil;
    // TODO don't use reusedable cell, there is some issues.
//    cell = [flowView dequeueReusableCellWithIdentifier:cellIdentifier withIndex:index];
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
        
        NSDictionary * dict = [self.itemDatas objectAtIndex:index];
        CGFloat picWidth = [[dict valueForKey:@"Picture_width"] floatValue];
        CGFloat picHeight = [[dict valueForKey:@"Picture_height"] floatValue];
        CGFloat frameWidth = (self.view.frame.size.width - 14) / 3;
        CGFloat frameHeight = (frameWidth / picWidth) * picHeight;
        
        UIImageView * imageView = [[UIImageView alloc] init];
        NSString * url = [dict valueForKey:@"pic_102"];
        [imageView setImageWithURL:[NSURL URLWithString:url]];
        
        BorderImageView * borderImageView = [[BorderImageView alloc] initWithFrame:CGRectMake(2, 2, frameWidth + 2, frameHeight + 2) andView:imageView];
        [cell addSubview:borderImageView];
        [borderImageView release];
        [imageView release];
	}
	return cell;
}

#pragma mark-
#pragma mark- WaterflowDelegate

- (CGFloat)flowView:(WaterFlowView *)flowView heightForCellAtIndex:(NSInteger)index
{
    return [[_itemsHeight objectAtIndex:index] floatValue];
}

- (void)flowView:(WaterFlowView *)flowView didSelectAtCell:(WaterFlowCell *)cell ForIndex:(int)index
{
    WeiboDetailViewController *weiboDetailController = 
    [[WeiboDetailViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
    [weiboDetailController release];
}

- (void)flowView:(WaterFlowView *)flowView willLoadData:(int)page
{
    [_waterFlowView reloadData];
}

@end
