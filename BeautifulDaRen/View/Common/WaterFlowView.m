
#import "WaterflowView.h"

#define LOADINGVIEW_HEIGHT 44
#define REFRESHINGVIEW_HEIGHT 88
#define MAX_PAGE 10

@interface WaterFlowView()

@property (assign, nonatomic) NSInteger numberOfColumns ; 
@property (assign, nonatomic) NSInteger currentPage;

@property (nonatomic, retain) NSMutableDictionary *reusableCells;
@property (nonatomic, retain) NSMutableArray *cellIndex;
@property (nonatomic, retain) NSMutableArray *visibleCells;
@property (retain, nonatomic) NSMutableArray * cellHeight; 
@property (retain, nonatomic) NSMutableDictionary *reusedCells; 


- (void)initialize;
- (void)reloadData;
- (void)recycleCellIntoReusableQueue:(WaterFlowCell*)cell;
- (void)pageScroll;
- (void)cellSelected:(NSNotification*)notification;

@end

@implementation WaterFlowView
@synthesize currentPage = _currentPage;
@synthesize numberOfColumns = _numberOfColumns;
@synthesize cellIndex = _cellIndex;
@synthesize cellHeight = _cellHeight;
@synthesize visibleCells = _visibleCells;
@synthesize reusedCells = _reusedCells;
@synthesize reusableCells = _reusableCells;
@synthesize flowdelegate = _flowdelegate;
@synthesize flowdatasource = _flowdatasource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
		self.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(cellSelected:)
                                                     name:@"CellSelected"
                                                   object:nil];
        
        _currentPage = 1;
        [self initialize];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"CellSelected"
                                                  object:nil];
    
    self.cellHeight = nil;
    self.visibleCells = nil;
    self.reusedCells = nil;
    self.flowdatasource = nil;
    self.flowdelegate = nil;
    [super dealloc];
}

- (void)setFlowdatasource:(id<WaterFlowViewDatasource>)flowdatasource
{
    _flowdatasource = flowdatasource;
    [self initialize];
}

- (void)setFlowdelegate:(id<WaterFlowViewDelegate>)flowdelegate
{
    _flowdelegate = flowdelegate;
    [self initialize];
}

#pragma mark-
#pragma mark- process notification
- (void)cellSelected:(NSNotification *)notification
{
    if ([self.flowdelegate respondsToSelector:@selector(flowView:didSelectAtCell:ForIndex:)])
    {
        int index = [[[self.cellIndex objectAtIndex:((WaterFlowCell*)notification.object).indexPath.section]objectAtIndex:((WaterFlowCell*)notification.object).indexPath.row] intValue];
        [self.flowdelegate flowView:self didSelectAtCell:((WaterFlowCell*)notification.object) ForIndex:index];
    }
}

#pragma mark-
#pragma mark - manage and reuse cells
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    if (!identifier || identifier == 0 ) return nil;
    
    NSArray *cellsWithIndentifier = [NSArray arrayWithArray:[self.reusableCells objectForKey:identifier]];
    if (cellsWithIndentifier &&  cellsWithIndentifier.count > 0)
    {
        WaterFlowCell *cell = [cellsWithIndentifier lastObject];
        [[cell retain] autorelease];
        [[self.reusableCells objectForKey:identifier] removeLastObject];
        return cell;
    }
    return nil;
}

- (void)recycleCellIntoReusableQueue:(WaterFlowCell *)cell
{
    if(!self.reusableCells)
    {
        self.reusableCells = [NSMutableDictionary dictionary];
        
        NSMutableArray *array = [NSMutableArray arrayWithObject:cell];
        [self.reusableCells setObject:array forKey:cell.reuseIdentifier];
    }
    
    else 
    {
        if (![self.reusableCells objectForKey:cell.reuseIdentifier])
        {
            NSMutableArray *array = [NSMutableArray arrayWithObject:cell];
            [self.reusableCells setObject:array forKey:cell.reuseIdentifier];
        }
        else 
        {
            [[self.reusableCells objectForKey:cell.reuseIdentifier] addObject:cell];
        }
    }
    
}

#pragma mark-
#pragma mark- methods
- (void)initialize
{    
    _numberOfColumns = [self.flowdatasource numberOfColumnsInFlowView:self];
    
    self.reusableCells = [NSMutableDictionary dictionary];
    self.cellHeight = [NSMutableArray arrayWithCapacity:_numberOfColumns];
    self.cellIndex = [NSMutableArray arrayWithCapacity:_numberOfColumns];
    self.visibleCells = [NSMutableArray arrayWithCapacity:_numberOfColumns];
    
    CGFloat scrollHeight = 0.f;
    
    /////
    for (int i = 0; i<_numberOfColumns; i++)
    {
        [self.visibleCells addObject:[NSMutableArray array]]; 
    }
    CGFloat minHeight = 0.f;
    NSInteger minHeightAtColumn = 0;
    for (int i = 0; i < _numberOfColumns * [_flowdatasource flowView:self numberOfRowsInColumn:i] * _currentPage ; i++)
    {        
        //the first pics
        if(self.cellHeight.count < _numberOfColumns)
        {
            [self.cellHeight addObject:[NSMutableArray arrayWithObject:[NSNumber numberWithFloat:[self.flowdelegate flowView:self heightForCellAtIndex:i]]]];
            [self.cellIndex addObject:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:i]]];
            minHeight = [self.flowdelegate flowView:self heightForCellAtIndex:i];
            continue;
        }

        //find the column with the shortest height and insert the cell height into self.cellHeight[column]
        for (int j = 0; j < _numberOfColumns; j++)
        {
            NSMutableArray *cellHeightInPresentColumn = [NSMutableArray arrayWithArray:[self.cellHeight objectAtIndex:j]];
            if (floor([[cellHeightInPresentColumn lastObject]floatValue]) <= minHeight)
            {
                minHeight = [[cellHeightInPresentColumn lastObject]floatValue];
                minHeightAtColumn = j;
            }
        }
        [[self.cellHeight objectAtIndex:minHeightAtColumn] addObject:[NSNumber numberWithFloat:minHeight+=[self.flowdelegate flowView:self heightForCellAtIndex:i]]];
        [[self.cellIndex objectAtIndex:minHeightAtColumn]addObject:[NSNumber numberWithInt:i]];
    }
    for (int j = 0; j< _numberOfColumns; j++)
    {
        if(self.cellHeight.count < _numberOfColumns ||self.cellHeight.count == 0) break;
        CGFloat columnHeight = [[[self.cellHeight objectAtIndex:j] lastObject] floatValue];
        scrollHeight = scrollHeight>columnHeight?scrollHeight:columnHeight;
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, scrollHeight + LOADINGVIEW_HEIGHT);
    
    [self pageScroll];
}

- (void)reloadData
{
    //remove and recycle all visible cells
    for (int i = 0; i < _numberOfColumns; i++)
    {
        NSMutableArray *array = [self.visibleCells objectAtIndex:i];
        for (id cell in array)
        {
            [self recycleCellIntoReusableQueue:(WaterFlowCell*)cell];
            [cell removeFromSuperview];
        }
    }

    [self initialize];
}

- (void)pageScroll
{
    for (int i = 0 ; i< _numberOfColumns; i++)
    {
        float origin_x = i * (self.frame.size.width / _numberOfColumns);
		float width = self.frame.size.width / _numberOfColumns;
        
        WaterFlowCell *cell = nil;
        
        if ([self.visibleCells objectAtIndex:i] == nil || ((NSArray*)[self.visibleCells objectAtIndex:i]).count == 0) //everytime reloadData is called and no cells in visibleCellArray
        {
            int rowToDisplay = 0;
			for( int j = 0; j < [[self.cellHeight objectAtIndex:i] count] - 1; j++)  //calculate which row to display in this column
			{
				float everyCellHeight = [[[self.cellHeight objectAtIndex:i] objectAtIndex:j] floatValue];
				if(everyCellHeight < self.contentOffset.y)
				{
					rowToDisplay ++;
				}
			}
			
#ifdef DEBUG
			NSLog(@"row to display %d", rowToDisplay);
#endif	
            
			float origin_y = 0;
			float height = 0;
			if(rowToDisplay == 0)  
			{
				origin_y = 0;
				height = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay] floatValue];
			}
			else if(rowToDisplay < [[self.cellHeight objectAtIndex:i] count]) 
            {
				origin_y = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay - 1] floatValue];
				height  = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay ] floatValue] - origin_y;
			}
            
			cell = [_flowdatasource flowView:self cellForRowAtIndex:[[[self.cellIndex objectAtIndex:i]objectAtIndex:rowToDisplay]intValue]];
			cell.indexPath = [NSIndexPath indexPathForRow: rowToDisplay inSection:i];
			cell.frame = CGRectMake(origin_x, origin_y, width, height);
			[self addSubview:cell];
			[[self.visibleCells objectAtIndex:i] insertObject:cell atIndex:0];
        }
        else   //there are cells in visibelCellArray
        {
            cell = [[self.visibleCells objectAtIndex:i] objectAtIndex:0];
        }
        
        //base on this cell at rowToDisplay and process the other cells
        //1. add cell above this basic cell if there's margin between basic cell and top
        while ( cell && ((cell.frame.origin.y - self.contentOffset.y) > 0.0001)) 
        {
            float origin_y = 0;
			float height = 0;
            int rowToDisplay = cell.indexPath.row;
            
            if(rowToDisplay == 0) 
            {
                cell = nil;
                break;
            }
            else if (rowToDisplay == 1)
            {
                origin_y = 0;
                height = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay  -1] floatValue];
            }
            else if (cell.indexPath.row < [[self.cellHeight objectAtIndex:i] count])
            {
                origin_y = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay -2] floatValue];
                height = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay - 1] floatValue] - origin_y;
            }
            
            cell = [self.flowdatasource flowView:self cellForRowAtIndex:[[[self.cellIndex objectAtIndex:i]objectAtIndex:rowToDisplay > 0 ? (rowToDisplay  - 1) : 0]intValue]];
            cell.indexPath = [NSIndexPath indexPathForRow: rowToDisplay > 0 ? (rowToDisplay - 1) : 0 inSection:i];
            cell.frame = CGRectMake(origin_x,origin_y , width, height);
            [[self.visibleCells objectAtIndex:i] insertObject:cell atIndex:0];
            
            [self insertSubview:cell atIndex:0];
        }
        //2. remove cell above this basic cell if there's no margin between basic cell and top
        while (cell &&  ((cell.frame.origin.y + cell.frame.size.height  - self.contentOffset.y) <  0.0001)) 
		{
			[cell removeFromSuperview];
			[self recycleCellIntoReusableQueue:cell];
			[[self.visibleCells objectAtIndex:i] removeObject:cell];
			
			if(((NSMutableArray*)[self.visibleCells objectAtIndex:i]).count > 0)
			{
				cell = [[self.visibleCells objectAtIndex:i] objectAtIndex:0];
			}
			else 
            {
				cell = nil;
			}
		}
        //3. add cells below this basic cell if there's margin between basic cell and bottom
        cell = [[self.visibleCells objectAtIndex:i] lastObject];
        while (cell &&  ((cell.frame.origin.y + cell.frame.size.height - self.frame.size.height - self.contentOffset.y) <  0.0001)) 
		{
            //NSLog(@"self.offset %@, self.frame %@, cell.frame %@, cell.indexpath %@",NSStringFromCGPoint(self.contentOffset),NSStringFromCGRect(self.frame),NSStringFromCGRect(cell.frame),cell.indexPath);
            float origin_y = 0;
			float height = 0;
            int rowToDisplay = cell.indexPath.row;
            
            if(rowToDisplay == [[self.cellHeight objectAtIndex:i] count] - 1)
			{
				origin_y = 0;
				cell = nil;
				break;;
			}
            else 
            {
                origin_y = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay] floatValue];
                height = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay + 1] floatValue] -  origin_y;
            }
            
            cell = [self.flowdatasource flowView:self cellForRowAtIndex:[[[self.cellIndex objectAtIndex:i]objectAtIndex:rowToDisplay+1]intValue]];
            cell.indexPath = [NSIndexPath indexPathForRow:rowToDisplay + 1 inSection:i];
            cell.frame = CGRectMake(origin_x, origin_y, width, height);
            [[self.visibleCells objectAtIndex:i] addObject:cell];
            
            [self addSubview:cell];
        }
        //4. remove cells below this basic cell if there's no margin between basic cell and bottom
        while (cell &&  ((cell.frame.origin.y - self.frame.size.height - self.contentOffset.y) > 0.0001)) 
		{
			[cell removeFromSuperview];
			[self recycleCellIntoReusableQueue:cell];
			[[self.visibleCells objectAtIndex:i] removeObject:cell];
			
			if(((NSMutableArray*)[self.visibleCells objectAtIndex:i]).count > 0)
			{
				cell = [[self.visibleCells objectAtIndex:i] lastObject];
			}
			else 
            {
				cell = nil;
			}
		}
    }
}

#pragma mark-
#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self pageScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // TODO
//    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
//    
//    if (bottomEdge >=  floor(scrollView.contentSize.height) ) 
//    {
////        if (self.loadingmore) return;
//        
//        if (currentPage == MAX_PAGE)
//        {
//            NSLog(@"last page!");
//            //toast view
//            return;
//        }
//        
//        NSLog(@"load more");
////        self.loadingmore = YES;
////        self.loadFooterView.showActivityIndicator = YES;
//        
//        currentPage ++;
//        if ([self.flowdelegate respondsToSelector:@selector(flowView:willLoadData:)])
//        {
//            [self.flowdelegate flowView:self willLoadData:currentPage];  //在delegate中对flowview进行reloadData
//        }
//        //[self performSelector:@selector(reloadData) withObject:self afterDelay:1.0f]; //make a delay to show loading process for a while
//    }
}

@end

//===================================================================
//
//*************************WaterflowCell*****************************
//
//===================================================================
@implementation WaterFlowCell
@synthesize indexPath = _indexPath;
@synthesize reuseIdentifier = _reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super init])
	{
		self.reuseIdentifier = reuseIdentifier;
	}
	
	return self;
}

- (void)dealloc
{
    self.indexPath = nil;
    self.reuseIdentifier = nil;
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellSelected"
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self,@"cell",self.indexPath,@"indexPath",nil]];
    
}

@end