#import <UIKit/UIKit.h>
#import "WaterFlowView.h"

@interface ItemsViewController : UIViewController <WaterFlowViewDelegate, WaterFlowViewDatasource, UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet WaterFlowView * waterFlowView;

-(id)initWithArray:(NSArray*)array;

@end

