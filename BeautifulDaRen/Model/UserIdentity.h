//
//  UserIdentity.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/12/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataConstants.h"

@interface UserIdentity : NSManagedObject

@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * localCity;
@property (nonatomic, retain) NSNumber * isMale;
@property (nonatomic, retain) NSNumber * followCount;
@property (nonatomic, retain) NSNumber * fansCount;
@property (nonatomic, retain) NSNumber * collectionCount;
@property (nonatomic, retain) NSNumber * buyedCount;
@property (nonatomic, retain) NSNumber * topicCount;
@property (nonatomic, retain) NSNumber * blackListCount;
@property (nonatomic, retain) NSString * personalBrief;
@property (nonatomic, retain) NSString * detailedAddress;

- (void)updateUserIdentityWithDictionary:(NSDictionary *)dict insideObjectContext:(NSManagedObjectContext*) objectContext;

+ (UserIdentity*)userIdentityWithDictionary:(NSDictionary *)dict insideObjectContext:(NSManagedObjectContext*) objectContext; 

@end
