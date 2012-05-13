#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataManagerCallbacks.h"  //Same callback blocks are transmitted to DataManager delegates

@class NSManagedObjectModel;
@class NSManagedObjectContext;
@class NSPersistentStoreCoordinator;

@protocol ManagedObjectDelegate;

typedef void(^DataSaveFinishBlock)(NSError* error);
typedef void(^CoreDataSaveBlock)(NSManagedObjectContext *objectContext);

/**
 @brief Handles all CoreData related functionalities, as creation, merging, and offers utility method to save to
 database in background thread, in a manner transparent for the user of this object
 */
@interface CoreDataManager : NSObject {
@private
    NSManagedObjectModel *managedObjectModel;  
    NSManagedObjectContext *managedObjectContext;      
    NSPersistentStoreCoordinator *persistentStoreCoordinator; 
    NSMutableArray *_delegates;
    
    id bgObserver;
}

/**
 @brief get coredatamanager queue
 */
+ (dispatch_queue_t) getQueue;

/**
 @brief Designated initializer
 */
- (id)init;

/**
 @brief add a ManagedObjectHandler
 @param handler Delegate of this manager
 */
- (void) registerDelegate:(id<ManagedObjectDelegate>)delegate;

/**
 @brief remove a ManagedObjectHandler
 @param handler Delegate of this manager
 */
- (void) unregisterDelegate:(id<ManagedObjectDelegate>)delegate;

/**
 @brief Checks if Core data stack was initialized
 @return YES if initialize, NO otherwise.
 */
- (BOOL)isDBInitialized;

/**
 @brief Forces a save to context. Used to save in case of failures, errors, or app terminated
 */
- (void)saveAllContextChanges;

/**
 @brief Initiates a background save operation using blocks and GCD. Invoking several saves is safe as all operations
 are serialized.
 
 @param saveBlock Code executing insertion/deletion of objects in context. Use the provided context, which is created in 
        the background. This code is executed asynchronously.
 @param finishBlock Called upon correct execution of the save in the background context. Called on main thread.
 @param errorBlock Called upon any error/exception when performing the save operation. Called on main thread.
 */
- (void)saveUsingBackgroundContextWithBlock:(CoreDataSaveBlock)saveBlock 
                                   onFinish:(DataSaveFinishBlock)finishBlock;

/**
 @brief Helper method to fetch an identity with a given predicate. Useful for simple fetchs of single entities
 */
- (NSManagedObject*)fetchEntity:(NSString*)entity
                  withPredicate:(NSPredicate*)predicate
              prefetchRelations:(NSArray*) prefetchRelations context:(NSManagedObjectContext *)context;

/**
 @brief Helper method to fetch all entities with predicate and sorting
 
 Provides a wrapper around NSFetchRequest. It basically makes the same as creating a Fetch request manually.
 
 @param entity the Entity name to target the fetch
 @param predicate The created predicate to use in the fetch. Use nil if you don't want to specify it.
 @param sort SortDescriptor to use in the fetch. Use nil if you don't want to specify it.
 @param limitnum Number of entities to fetch. Use 0 not to limit the fetch to any number explicitly.
 */
- (NSArray*)fetchAllEntities:(NSString*)entity 
               withPredicate:(NSPredicate*)predicate 
                 withSorting:(NSSortDescriptor*)sort 
                  fetchLimit:(NSUInteger)limitnum
           prefetchRelations:(NSArray*)prefetchRelations
                     context:(NSManagedObjectContext *)context;

/**
 @brief Helper method to fetch count of an entity with predicate
 
 Provides a wrapper around NSFetchRequest. It basically makes the same as creating a Fetch request manually.
 
 @param entity the Entity name to target the fetch
 @param predicate The created predicate to use in the fetch. Use nil if you don't want to specify it.
 */
- (NSUInteger)fetchCountOfEntity:(NSString*)entity 
                   withPredicate:(NSPredicate*)predicate 
                         context:(NSManagedObjectContext *)context;

/**
 @brief Utility method to get where database directory is
 
 @return The directory
 */
- (NSString *)databaseDirectory;

/**
 Necessary part of the core data stack.
 */
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;  

/**
 Necessary part of the core data stack.
 */
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;  

/**
 Necessary part of the core data stack.
 */
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;  


@end

/**
 Owner of #CoreDataManager should implement this protocol to receive changes, specially when using utility method
 to save in background (using different context)
 */
@protocol ManagedObjectDelegate <NSObject>
- (void)contextDidSaveObjects:(NSNotification*)notif;
@end

/** @} */