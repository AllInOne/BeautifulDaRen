#import <AudioToolbox/AudioToolbox.h>

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "UpdateViewControllerProtocol.h"
#import "DataManagerCallbacks.h"
#import "DataConstants.h"
#import "UserIdentity.h"
#import "Comment.h"

@interface DataManager : NSObject{
@private
    id<UpdateViewControllerProtocol> delegate;

}

@property (nonatomic, assign) id<UpdateViewControllerProtocol> delegate;

+ (DataManager*) sharedManager;

- (void)handleLowMemory;

- (void)saveLocalIdentityWithDictionary:(NSDictionary*)dictionary finishBlock:(ProcessFinishBlock)finishBlock;

- (void)saveCommentWithDictionary:(NSDictionary*)dictionary finishBlock:(ProcessFinishBlock)finishBlock;

- (Comment*)getCommentById:(NSString*)commentId inContext:(NSManagedObjectContext*)context;

- (NSArray*)getCommentOfLocalIdentityWithLimit:(NSInteger)limit finishBlock:(ProcessFinishBlock)finishBlock;

- (UserIdentity*)getLocalIdentityWithId:(NSString*)id inContext:(NSManagedObjectContext*)context;

- (UserIdentity*)getCurrentLocalIdentityInContext:(NSManagedObjectContext*)context;


@end
/** @} */
