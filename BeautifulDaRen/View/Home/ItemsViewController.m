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
#import <QuartzCore/QuartzCore.h>
#import "BorderImageView.h"

#define COLUMNS_PER_ROW 4
#define GRID_X_OFFSET 3
#define GRID_Y_OFFSET 5

#define GRID_X_DELTA 80
#define GRID_Y_DELTA 80

@interface ItemsViewController()

@property (retain, nonatomic) NSMutableArray * fakeData;
@property (retain, nonatomic) NSMutableArray * itemsHeight;
-(void)loadFakeData;

@end

@implementation ItemsViewController
@synthesize waterFlowView = _waterFlowView;
@synthesize fakeData = _fakeData;
@synthesize itemsHeight = _itemsHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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

- (void) loadFakeData
{
    NSArray * imageNames = [NSArray arrayWithObjects:@"weibo_sample1",@"weibo_sample2",
                            @"weibo_sample3",@"weibo_sample4",@"weibo_sample5",@"weibo_sample6",@"weibo_sample7",
                            @"weibo_sample8",@"weibo_sample9",@"weibo_sample10",
                            @"weibo_sample11",@"weibo_sample1",@"weibo_sample2",@"weibo_sample3",
                            @"weibo_sample4",@"weibo_sample5",@"weibo_sample6",@"weibo_sample7",
                            @"weibo_sample8",@"weibo_sample9",@"weibo_sample10",@"weibo_sample1",
                            @"weibo_sample2",@"weibo_sample3", nil];
    NSArray * imageIds = [NSArray arrayWithObjects:@"NO.001",@"NO.002",
                          @"NO.003",@"NO.004",@"NO.005",@"NO.006",
                          @"NO.007",@"NO.008",@"NO.009",@"NO.010",
                          @"NO.011",@"NO.012", @"NO.013",@"NO.021",
                          @"NO.022", @"NO.023",@"NO.024",@"NO.025",
                          @"NO.026",@"NO.027",@"NO.028",@"NO.029",
                          @"NO.030",@"NO.031",@"NO.032", @"NO.033", nil];

    NSInteger count = [imageNames count];
    _fakeData = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        WaresItem * item = [[WaresItem alloc] init];
        item.itemId = [imageIds objectAtIndex:i];
        UIImage * image = [UIImage imageNamed:[imageNames objectAtIndex:i]];
        item.itemImageData = UIImagePNGRepresentation(image);
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:item.itemImageData]];
        
        CGFloat frameWidth = (self.view.frame.size.width - 14) / 3;
        CGFloat frameHeight = [ViewHelper getRatioHeightOfImage:imageView.image ratioWidth:frameWidth];
        [_itemsHeight addObject:[NSNumber numberWithFloat:(frameHeight+4)]];
        [self.fakeData addObject:item];
        [imageView release];
        [item release];
    }
}

#pragma mark - View lifecycle

-(void) dealloc
{
    [_waterFlowView release];
    [_itemsHeight release];
    [_fakeData release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _itemsHeight = [[NSMutableArray alloc] init];
    [self loadFakeData];
    
    _waterFlowView = [[WaterFlowView alloc] initWithFrame:self.view.frame];
    _waterFlowView.flowdelegate = self;
    _waterFlowView.flowdatasource = self;
    [self.view addSubview:_waterFlowView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _waterFlowView = nil;
    _itemsHeight = nil;
    _fakeData = nil;
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
    WeiboDetailViewController *weiboDetailController = 
    [[WeiboDetailViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
    [weiboDetailController release];
}

#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterFlowView *)flowView
{
    return 3;
}

- (NSInteger)flowView:(WaterFlowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    return 8;
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
        
        UIImage * image = [UIImage imageWithData:((WaresItem*)[self.fakeData objectAtIndex:index]).itemImageData];
        
        CGFloat frameWidth = (self.view.frame.size.width - 14) / 3;
        CGFloat frameHeight = [ViewHelper getRatioHeightOfImage:image ratioWidth:frameWidth];
        
        BorderImageView * borderImageView = [[BorderImageView alloc] initWithFrame:CGRectMake(2, 2, frameWidth + 2, frameHeight + 2) andImage:image];
        [cell addSubview:borderImageView];
        [borderImageView release];
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
