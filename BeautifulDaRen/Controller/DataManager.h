#import <AudioToolbox/AudioToolbox.h>

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "UpdateViewControllerProtocol.h"
#import "DataManagerCallbacks.h"
#import "DataConstants.h"
#import "UserIdentity.h"

@interface DataManager : NSObject{
@private
    id<UpdateViewControllerProtocol> delegate;

    NSError *errorDataRetrieval; // SDK failed
}

@property (nonatomic, assign) id<UpdateViewControllerProtocol> delegate;

+ (DataManager*) sharedManager;

- (void)handleLowMemory;


- (void)saveLocalIdentityWithDictionary:(NSDictionary*)dictionary FinishBlock:(ProcessFinishBlock)finishBlock;

- (UserIdentity*)getLocalIdentityWithFinishBlock:(ProcessFinishBlock)finishBlock;

@end
/** @} */
