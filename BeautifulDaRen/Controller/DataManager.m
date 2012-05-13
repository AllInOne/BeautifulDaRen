/***********************************************************************
 *
 * Copyright (C) 2011-2012 Myriad Group AG. All Rights Reserved.
 *
 * File     :   $Id: //depot/ds/projects/MSSS/pivot/apps/Pivot/Pivot/Controller/DataManager.m#198 $
 *
 ***********************************************************************/

#import "DataManager.h"
#import "CoreDataManager.h"
#import "ViewConstants.h"

#import "UserIdentity.h"

static DataManager *sharedInstance;

@interface DataManager()
@property (retain, nonatomic) CoreDataManager * coreDataManager;

- (void)contextWillSaveObjects:(NSNotification*)notif;
- (void)contextDidSaveObjects:(NSNotification*)notif;
- (void)contextObjectsDidChange:(NSNotification*)notif;
@end

@implementation DataManager

@synthesize delegate;
@synthesize coreDataManager = _coreDataManager;

#pragma mark - Class methods

+ (DataManager*) sharedManager {
    @synchronized([DataManager class]) {
        if (!sharedInstance) {
            sharedInstance = [[DataManager alloc] init];
        }
    }
    return sharedInstance;
}

#pragma mark - init/dealloc
- (void)dealloc {
    [_coreDataManager release];
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    _coreDataManager = [[CoreDataManager alloc] init];
    
    if (self) {
        // run at next iteration to avoid call datamanager init recursively.
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        
    }
    
    return self;
}

-(void)initErrors {
}

- (void)handleLowMemory {
}

//#pragma mark - Data accessors
- (void)saveLocalUserWithDictionary:(NSDictionary*)dictionary FinishBlock:(ProcessFinishBlock)finishBlock
{
    [self.coreDataManager saveUsingBackgroundContextWithBlock:^(NSManagedObjectContext *objectContext) {
        [UserIdentity userIdentityWithDictionary:dictionary insideObjectContext:objectContext];
    } onFinish:^(NSError *error) {
        finishBlock(error);
    }];
}

- (void)getLocalIdentityWithFinishBlock:(ProcessFinishBlock)finishBlock
{
}
#pragma mark - CoreDataManager delegate
- (void)contextWillSaveObjects:(NSNotification*)notif {
    //No actions
}
- (void)contextDidSaveObjects:(NSNotification*)notif {
    //No actions
}

- (void)contextObjectsDidChange:(NSNotification*)notif {
    //No actions
}

@end

/** @} */
