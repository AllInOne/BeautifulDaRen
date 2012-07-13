#import <UIKit/UIKit.h>
#import "WaterFlowView.h"

@interface ItemsViewController : UIViewController <WaterFlowViewDelegate, WaterFlowViewDatasource, UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet WaterFlowView * waterFlowView;

@property (retain, nonatomic) NSMutableArray * itemDatas;
-(id)initWithArray:(NSArray*)array;
-(void)refresh;
@end

