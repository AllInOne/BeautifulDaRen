#import <UIKit/UIKit.h>
#import "WaterFlowView.h"
#import "EGORefreshTableHeaderView.h"

@interface ItemsViewController : UIViewController <WaterFlowViewDelegate, WaterFlowViewDatasource, UIScrollViewDelegate> {
    EGORefreshTableHeaderView *refreshHeaderView;
}

@property (nonatomic, retain) IBOutlet WaterFlowView * waterFlowView;

@property (retain, nonatomic) NSMutableArray * itemDatas;
-(id)initWithArray:(NSArray*)array;
-(void)refresh;
-(void)clearData;
-(void)reset;
@end

