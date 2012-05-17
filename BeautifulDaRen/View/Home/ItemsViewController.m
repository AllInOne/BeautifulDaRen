//
//  ItemsViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ItemsViewController.h"
#import "GridCellView.h"
#import "ViewConstants.h"
#import "WaresItem.h"
#import "WeiboDetailViewController.h"

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
    NSArray * imageNames = [NSArray arrayWithObjects:@"fake_item1",@"fake_item2",
                            @"fake_item3",@"fake_item4",@"fake_item5",@"fake_item6",
                            @"fake_item7",@"fake_item8",@"fake_item9",@"fake_item10",
                            @"fake_item11",@"fake_item12", nil];
    NSArray * imageIds = [NSArray arrayWithObjects:@"NO.001",@"NO.002",
                          @"NO.003",@"NO.004",@"NO.005",@"NO.006",@"NO.007",@"NO.008",@"NO.009",@"NO.010",@"NO.011",@"NO.012", @"NO.013",@"NO.021",@"NO.022",
                          @"NO.023",@"NO.024",@"NO.025",@"NO.026",@"NO.027",@"NO.028",@"NO.029",@"NO.030",@"NO.031",@"NO.032", @"NO.033", nil];

    NSInteger count = [imageNames count];
    self.fakeData = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        WaresItem * item = [[[WaresItem alloc] init] autorelease];
        item.itemId = [imageIds objectAtIndex:i];
        UIImage * image = [UIImage imageNamed:[imageNames objectAtIndex:i]];
        item.itemImageData = UIImagePNGRepresentation(image);
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:item.itemImageData]];
        [_itemsHeight addObject:[NSNumber numberWithFloat:imageView.frame.size.height]];
        [self.fakeData addObject:item];
    }
}

#pragma mark - View lifecycle

-(void) dealloc
{
    [_waterFlowView release];
    [_itemsHeight release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _itemsHeight = [[NSMutableArray alloc] init];
    [self loadFakeData];
    
    _waterFlowView = [[WaterFlowView alloc] initWithFrame:self.view.frame];
    _waterFlowView.flowdelegate = self;
    _waterFlowView.flowdatasource = self;
    [_waterFlowView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_waterFlowView];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark GridCellViewDelegate

- (void)didPressGridCell:(GridCellView *)sender
{
    NSLog(@"item id: %@",((WaresItem*)sender.cellObject).itemId);
    WeiboDetailViewController *weiboDetailController = 
    [[[WeiboDetailViewController alloc] init] autorelease];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
}

#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterFlowView *)flowView
{
    return 3;
}

- (NSInteger)flowView:(WaterFlowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    return 4;
}

- (WaterFlowCell *)flowView:(WaterFlowView *)flowView cellForRowAtIndex:(NSInteger)index
{
    static NSString *cellIdentifier = @"WaterFlowCell";
	WaterFlowCell *cell = [flowView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
        
        UIImageView * imageView = [[[UIImageView alloc] init] autorelease];
        imageView.image = [UIImage imageWithData:((WaresItem*)[self.fakeData objectAtIndex:index]).itemImageData];
        
        [cell addSubview:imageView];

        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / 3, imageView.image.size.height);
		imageView.tag = 1001;
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
    NSLog(@"cell = %@, AT %d",cell,index);
}

- (void)flowView:(WaterFlowView *)flowView willLoadData:(int)page
{
    [_waterFlowView reloadData];
}

@end
