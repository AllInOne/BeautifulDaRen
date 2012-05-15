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
@property (retain, nonatomic) CoreDataManager * cdm;

- (void)contextWillSaveObjects:(NSNotification*)notif;
- (void)contextDidSaveObjects:(NSNotification*)notif;
- (void)contextObjectsDidChange:(NSNotification*)notif;
@end

@implementation DataManager

@synthesize delegate;
@synthesize cdm = _cdm;

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
    [_cdm release];
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    _cdm = [[CoreDataManager alloc] init];
    
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
- (void)saveLocalIdentityWithDictionary:(NSDictionary*)dictionary FinishBlock:(ProcessFinishBlock)finishBlock
{
    [_cdm saveUsingBackgroundContextWithBlock:^(NSManagedObjectContext *objectContext) {
        [UserIdentity userIdentityWithDictionary:dictionary insideObjectContext:objectContext];
    } onFinish:^(NSError *error) {
        finishBlock(error);
    }];
}

- (UserIdentity*)getLocalIdentityWithFinishBlock:(ProcessFinishBlock)finishBlock
{
    return [[_cdm fetchAllEntities:@"UserIdentity" withPredicate:nil withSorting:nil fetchLimit:1 prefetchRelations:nil context:nil] objectAtIndex:0];
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
