#import "CoreDataManager.h"
#import "DataConstants.h"
#import <dispatch/dispatch.h>

static dispatch_queue_t background_saveQueue = NULL;

@interface CoreDataManager (Private)
- (void)contextDidSaveNotification:(NSNotification*)notif;
@end

@implementation CoreDataManager

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

#pragma mark - C Interface
static dispatch_queue_t getBGSaveQueue() {
    @synchronized([CoreDataManager class]){
        if (background_saveQueue == NULL){
            background_saveQueue = dispatch_queue_create(COREDATA_BG_QUEUE_ID, DISPATCH_QUEUE_SERIAL);
        }
    }

    return background_saveQueue;
}

static void releaseBGSaveQueue() {
    @synchronized([CoreDataManager class]){
        if (background_saveQueue) {
            dispatch_release(background_saveQueue);
            background_saveQueue = NULL;
        }
    }
}

+ (dispatch_queue_t) getQueue {
    return getBGSaveQueue();
}

#pragma mark - Init/Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:bgObserver];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [_delegates release];
    releaseBGSaveQueue();
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        _delegates = [[NSMutableArray alloc] initWithCapacity:2];
        [self persistentStoreCoordinator];

        //We don't want to leave any data related to BG save queue pending and retained when going to background.
        //Specially accessing AddressBook API, we need to release it when going to background. this listener to
        //bg notification releases queues so they will be destroyed as soon as operations in blocks finished.
        //TODO: Setup a global flag to let blocks stop they long-runnning operations when going to background.
        bgObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification* note) {
                                                          releaseBGSaveQueue();
                                                      }];
    }

    return self;
}

- (void) registerDelegate:(id<ManagedObjectDelegate>)delegate {
    NSAssert([NSThread isMainThread],@"must run at Main Thread");
    [_delegates addObject:delegate];
}

- (void) unregisterDelegate:(id<ManagedObjectDelegate>)delegate {
    NSAssert([NSThread isMainThread],@"must run at Main Thread");
    [_delegates removeObject:delegate];
}

#pragma mark - Operations
- (BOOL)isDBInitialized {
    return (nil != managedObjectContext);
}

- (void)saveAllContextChanges {
    NSError* error = nil;
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]){
        
    }
}
- (NSString *) databaseDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)saveUsingBackgroundContextWithBlock:(CoreDataSaveBlock)saveBlock
                                   onFinish:(DataSaveFinishBlock)finishBlock{

    dispatch_async(getBGSaveQueue(), ^{
        //Create a context to perform the save operation specified by the block
        NSManagedObjectContext *bgContext = [[NSManagedObjectContext alloc] init ];
        [bgContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
        [bgContext setUndoManager:nil]; //No undo is needed in our application. Increases performance

        NSError* error = nil;
        @try {
            //Execute save block
            saveBlock(bgContext);

            if ([bgContext hasChanges])
            {
                id saveObserver = [[NSNotificationCenter defaultCenter]
                    addObserverForName:NSManagedObjectContextDidSaveNotification
                                object:nil
                                 queue:[NSOperationQueue mainQueue]
                            usingBlock:^(NSNotification* notif){
                                //Merge changes by trumping what's there (we want to update)
                                [managedObjectContext mergeChangesFromContextDidSaveNotification:notif];
                                [self contextDidSaveNotification:notif];
                                // run the finishBlock after manageObjectContext merge the change on bgContextSaved
                                // the benefit is that caller can use the entity with correct state in finshBlock()
                                // regardless the state consistent issue.
                                finishBlock(error);
                         }];
                //This will trigger notifications and saves to the main managed object context
                [bgContext save:&error];
                [[NSNotificationCenter defaultCenter] removeObserver:saveObserver];

                [bgContext processPendingChanges];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    finishBlock(error);
                });
            }
        }
        @catch (NSException *exception) {

            error = [NSError errorWithDomain:DATAMANAGER_ERRORDOMAIN
                                        code:-1
                                    userInfo:[NSDictionary dictionaryWithObject:exception.description forKey:NSLocalizedDescriptionKey]];
            NSAssert(false,@"** PLEASE CHECK ERROR FEW LINES BEFORE TO CHECK WHY EXCEPTION WAS THROWN ** You shouldn't have exceptions on normal operation while saving. Development assertion.** PLEASE CHECK ERROR FEW LINES BEFORE TO CHECK WHY EXCEPTION WAS THROWN **");
            dispatch_sync(dispatch_get_main_queue(), ^{
                finishBlock(error);
            });
        }

        [bgContext release];
    });
}

- (NSManagedObject*)fetchEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate prefetchRelations:(NSArray*) prefetchRelations context:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName: entity];
    NSError *error = nil;
    fetchRequest.predicate = predicate;
    if (prefetchRelations) {
        [fetchRequest setRelationshipKeyPathsForPrefetching:prefetchRelations];
    }
    NSArray *fetchResults = [(context ? context : self.managedObjectContext) executeFetchRequest: fetchRequest error: &error];

    if (error) {
        NSLog(@"Error reading Core Data %@",error);
    }

    NSManagedObject* fetched = nil;
    if (!error && [fetchResults count] > 0) {
        fetched = (NSManagedObject*)[fetchResults objectAtIndex:0];
    }
    return fetched;
}

- (NSArray*)fetchAllEntities:(NSString*)entity
               withPredicate:(NSPredicate*)predicate
                 withSorting:(NSSortDescriptor*)sort
                  fetchLimit:(NSUInteger)limitnum
           prefetchRelations:(NSArray*) prefetchRelations
                     context:(NSManagedObjectContext *)context{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName: entity];
    fetchRequest.predicate = predicate;
    fetchRequest.fetchLimit = limitnum;
    if (prefetchRelations) {
        [fetchRequest setRelationshipKeyPathsForPrefetching:prefetchRelations];
    }

    if (sort) {
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
    }

    NSArray*  fetched = [(context ? context : self.managedObjectContext) executeFetchRequest: fetchRequest error: &error] ;
    if (error) {
        NSLog(@"Error reading Core Data %@",error);
        fetched = nil;
    }

    return fetched;
}

- (NSUInteger)fetchCountOfEntity:(NSString*)entity
                   withPredicate:(NSPredicate*)predicate
                         context:(NSManagedObjectContext *)context {
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName: entity];
    fetchRequest.predicate = predicate;

    NSUInteger  count = [(context ? context : self.managedObjectContext) countForFetchRequest: fetchRequest error: &error];
    if (error) {
        count = 0;
    }
    return count;
}

#pragma mark - Core Data stack accessors (and creation)
- (NSManagedObjectContext *) managedObjectContext {

    //This is a WIP check. Only from main thread this context should be accessed
    NSAssert([NSThread isMainThread],@" must run at Main Thread");

    if (managedObjectContext) {
        return managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        //Creation
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
        [managedObjectContext setUndoManager:nil];  //No undo is needed in our application. Increases performance
        [managedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    }

    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {

    if (managedObjectModel) {
        return managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BeautifulDaRen" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

    if (persistentStoreCoordinator) {
        return persistentStoreCoordinator;
    }

    NSURL *storeUrl = [NSURL fileURLWithPath: [[self databaseDirectory]
                                               stringByAppendingPathComponent: @"BeautifulDaRen.sqlite"]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:self.managedObjectModel];

    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:nil error:&error]) {

        NSError* retryError = nil;
        //Handle creation of data storage when there's already one in the same location
        //by deleting it first. this is caused normally by different versions of the store (data model update)
        if (NSPersistentStoreIncompatibleVersionHashError == [error code]) {
            //Delete old store. Will be recreated
            NSError* removeError = nil;
            [[NSFileManager defaultManager]removeItemAtURL:storeUrl error:&removeError];
            //This would be stupid
            NSAssert(removeError == nil, @"Error deleting previously created DB file!");
            //Retry creation
            [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                         configuration:nil URL:storeUrl options:nil error:&retryError];
        }

        if (retryError || NSPersistentStoreIncompatibleVersionHashError != [error code]){
            //TODO: Better error handling (UI dialog?)
            NSLog(@"***** ERROR CREATING PERSISTENT STORE COORDINATOR: %@*****",error);
            abort();
        }
    }

    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Private interface

- (void)contextDidSaveNotification:(NSNotification*)notif {
    for (id<ManagedObjectDelegate> delegate in _delegates) {
        [delegate contextDidSaveObjects:notif];
    }
}

@end

/** @} */