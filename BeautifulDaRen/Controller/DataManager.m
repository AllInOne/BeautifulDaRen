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
#import "Comment.h"

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
- (void)saveLocalIdentityWithDictionary:(NSDictionary*)dictionary finishBlock:(ProcessFinishBlock)finishBlock
{
    [_cdm saveUsingBackgroundContextWithBlock:^(NSManagedObjectContext *objectContext) {
        UserIdentity * userIdentity = [self getLocalIdentityWithId:[dictionary objectForKey:USERIDENTITY_UNIQUE_ID] inContext:objectContext];
        if(!userIdentity)
        {
            [UserIdentity userIdentityWithDictionary:dictionary insideObjectContext:objectContext];
        }
        else
        {
            [userIdentity updateUserIdentityWithDictionary:dictionary insideObjectContext:objectContext];
        }
    } onFinish:^(NSError *error) {
        finishBlock(error);
    }];
}

- (void)saveCommentWithDictionary:(NSDictionary*)dictionary finishBlock:(ProcessFinishBlock)finishBlock
{
    [_cdm saveUsingBackgroundContextWithBlock:^(NSManagedObjectContext *objectContext) {
        Comment * comment = [self getCommentById:[dictionary objectForKey:COMMENT_UNIQUE_ID] inContext:objectContext];
        if(!comment)
        {
            [Comment commentWithDictionary:dictionary insideObjectContext:objectContext];
        }
        else
        {
            [comment updateCommentWithDictionary:dictionary insideObjectContext:objectContext];
        }
    } onFinish:^(NSError *error) {
        finishBlock(error);
    }];
}

- (Comment*)getCommentById:(NSString*)commentId inContext:(NSManagedObjectContext*)context
{
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"uniqueId == %@", commentId];
    return (Comment*)[_cdm fetchEntity:@"Comment" withPredicate:predict prefetchRelations:nil context:context];
}

- (NSArray*) getCommentOfLocalIdentityWithLimit:(NSInteger)limit finishBlock:(ProcessFinishBlock)finishBlock
{
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"userIdentity.uniqueId == %@", [[NSUserDefaults standardUserDefaults] stringForKey:BEAUTIFUL_DAREN_USER_IDENTITY_ID]];
    return [_cdm fetchAllEntities:@"Comment" withPredicate:predict withSorting:nil fetchLimit:limit prefetchRelations:nil context:nil];
}

-(UserIdentity*)getLocalIdentityWithId:(NSString*)id inContext:(NSManagedObjectContext*)context{
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"uniqueId == %@", id];
    return (UserIdentity*)[_cdm fetchEntity:@"UserIdentity" withPredicate:predict prefetchRelations:nil context:context];
}

-(UserIdentity*)getCurrentLocalIdentityInContext:(NSManagedObjectContext*)context
{
    return [self getLocalIdentityWithId:[[NSUserDefaults standardUserDefaults] stringForKey:BEAUTIFUL_DAREN_USER_IDENTITY_ID] inContext:context];            
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
