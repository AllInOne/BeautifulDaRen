#import <UIKit/UIKit.h>
#import "WaterFlowView.h"
#import "EGORefreshTableHeaderView.h"

typedef enum {
    ITEMSVIEW_MODE_HOME,
    ITEMSVIEW_MODE_MINE,
    ITEMSVIEW_MODE_HOT
}ITEMSVIEW_MODE;

@interface ItemsViewController : UIViewController <WaterFlowViewDelegate, WaterFlowViewDatasource, UIScrollViewDelegate> {
    EGORefreshTableHeaderView *refreshHeaderView;
}

@property (nonatomic, retain) IBOutlet WaterFlowView * waterFlowView;
@property (nonatomic, retain) NSMutableArray * itemDatas;
@property (nonatomic, assign) ITEMSVIEW_MODE viewMode;
@property (nonatomic, assign) NSString * hotClassId;

-(id)initWithArray:(NSArray*)array;
-(void)refreshInNewAds:(BOOL)isNewAds;
-(void)clearData;
-(void)reset;
@end

