//
//  ItemsViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ItemsViewController.h"
#import "GridCellView.h"
#import "WaresItem.h"

#define COLUMNS_PER_ROW 4
#define GRID_X_DELTA 80
#define GRID_Y_DELTA 120

@interface ItemsViewController()

@property (retain, nonatomic) NSMutableArray * fakeData;
@property (retain, nonatomic) NSMutableArray * gridCells;

@end

@implementation ItemsViewController
@synthesize gridCells = _gridCells;
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
    for (int i = 0; i < [self.fakeData count]; i++) {
        GridCellView * cell = [[[NSBundle mainBundle] loadNibNamed:cellViewIdentifier owner:self options:nil] objectAtIndex:0];
        cell.frame = CGRectMake((i % COLUMNS_PER_ROW) * GRID_X_DELTA,
                                (i / COLUMNS_PER_ROW) * GRID_Y_DELTA,
                                GRID_X_DELTA,
                                GRID_Y_DELTA);
        cell.delegate = self;
        [self.gridCells addObject:cell];
        [self.view addSubview:cell];
        
        WaresItem * item = [self.fakeData objectAtIndex:i];
        cell.cellTitle.text = item.itemTitle;
        cell.cellImageView.image = [UIImage imageWithData:item.itemImageData];
    }
}

- (void) loadViewData
{
    
}

- (void) loadFakeData
{
    NSArray * imageNames = [NSArray arrayWithObjects:@"item_fake",@"item_fake",
                           @"item_fake",@"item_fake",@"item_fake",@"item_fake",@"item_fake",@"item_fake", nil];
    NSArray * imageIds = [NSArray arrayWithObjects:@"NO.001",@"NO.002",
                           @"NO.003",@"NO.004",@"NO.005",@"NO.006",@"NO.007",@"NO.008", nil];
    NSArray * imageTitles = [NSArray arrayWithObjects:@"谢谢你",@"不客气",
                           @"对不起",@"没关系",@"您好",@"再见",@"欢迎下次再来",@"好", nil];
    
    NSInteger count = 8;
    // set the initial capacity to 8
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
    // TODO
}

@end
