#import <AudioToolbox/AudioToolbox.h>

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "UpdateViewControllerProtocol.h"
#import "DataManagerCallbacks.h"
#import "DataConstants.h"

@interface DataManager : NSObject{
@private
    id<UpdateViewControllerProtocol> delegate;

    NSError *errorDataRetrieval; // SDK failed
}

@property (nonatomic, assign) id<UpdateViewControllerProtocol> delegate;

+ (DataManager*) sharedManager;

- (void)handleLowMemory;


- (void)saveLocalUserWithDictionary:(NSDictionary*)dictionary FinishBlock:(ProcessFinishBlock)finishBlock;

- (void)getLocalIdentityWithFinishBlock:(ProcessFinishBlock)finishBlock;

@end
/** @} */
