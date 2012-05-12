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
#define GRID_X_OFFSET 5
#define GRID_X_DELTA 80
#define GRID_Y_DELTA 80

@interface ItemsViewController()
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;

@property (retain, nonatomic) NSMutableArray * fakeData;

@end

@implementation ItemsViewController
@synthesize scrollView;
@synthesize fakeData = _fakeData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void) refreshView
{
    static NSString * cellViewIdentifier = @"GridCellView";
    NSInteger scrollHeight = 0;
    for (int i = 0; i < [self.fakeData count]; i++) {
        GridCellView * cell = [[[NSBundle mainBundle] loadNibNamed:cellViewIdentifier owner:self options:nil] objectAtIndex:0];
        cell.frame = CGRectMake((i % COLUMNS_PER_ROW) * GRID_X_DELTA + GRID_X_OFFSET,
                                (i / COLUMNS_PER_ROW) * GRID_Y_DELTA,
                                cell.frame.size.width,
                                cell.frame.size.height);
        if(i % COLUMNS_PER_ROW == 0) {
            scrollHeight += cell.frame.size.height + 5;
        }

        [self.scrollView addSubview:cell];
        
        WaresItem * item = [self.fakeData objectAtIndex:i];
        cell.cellImageView.image = [UIImage imageWithData:item.itemImageData];
        cell.cellObject = item;
        
        cell.delegate = self;
    }
    [self.scrollView setContentSize:CGSizeMake(0, scrollHeight)];
}

- (void) loadViewData
{
    
}

- (void) loadFakeData
{
    NSArray * imageNames = [NSArray arrayWithObjects:@"item_fake",@"item_fake",
                            @"item_fake",@"item_fake",@"item_fake",@"item_fake",
                            @"item_fake",@"item_fake",@"item_fake",@"item_fake",@"item_fake",@"item_fake", @"item_fake", nil];
    NSArray * imageIds = [NSArray arrayWithObjects:@"NO.001",@"NO.002",
                          @"NO.003",@"NO.004",@"NO.005",@"NO.006",@"NO.007",@"NO.008",@"NO.009",@"NO.010",@"NO.011",@"NO.012", @"NO.013", nil];
    NSArray * imageTitles = [NSArray arrayWithObjects:@"谢谢你",@"不客气",
                           @"对不起",@"没关系",@"您好",@"再见",@"欢迎下次再来",@"好",
                             @"谢霆锋",@"张柏芝",@"陈冠希",@"阿娇", @"史泰龙", nil];

    NSInteger count = [imageIds count];
    self.fakeData = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        WaresItem * item = [[[WaresItem alloc] init] autorelease];
        item.itemTitle = [imageTitles objectAtIndex:i];
        item.itemId = [imageIds objectAtIndex:i];
        UIImage * image = [UIImage imageNamed:[imageNames objectAtIndex:i]];
        item.itemImageData = UIImagePNGRepresentation(image);
        
        [self.fakeData addObject:item];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadFakeData];
    
    [self refreshView];
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

@end
