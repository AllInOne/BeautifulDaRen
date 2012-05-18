//
//  UserIdentity.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/12/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "UserIdentity.h"


@implementation UserIdentity

@dynamic uniqueId;
@dynamic displayName;
@dynamic level;
@dynamic localCity;
@dynamic isMale;
@dynamic followCount;
@dynamic fansCount;
@dynamic collectionCount;
@dynamic buyedCount;
@dynamic topicCount;
@dynamic blackListCount;
@dynamic personalBrief;
@dynamic detailedAddress;

- (void)updateUserIdentityWithDictionary:(NSDictionary *)dict insideObjectContext:(NSManagedObjectContext*) objectContext
{
    self.displayName = [dict objectForKey:USERIDENTITY_DISPLAY_NAME];
    self.level = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_LEVEL] intValue]];
    self.localCity = [dict objectForKey:USERIDENTITY_LOCAL_CITY];
    self.isMale = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_IS_MALE] intValue]];
    self.followCount = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_FOLLOW_COUNT] intValue]];
    self.fansCount = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_FANS_COUNT] intValue]];
    self.buyedCount = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_BUYED_COUNT] intValue]];
    self.collectionCount = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_COLLECTION_COUNT] intValue]];
    self.topicCount = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_TOPIC_COUNT] intValue]];
    self.blackListCount = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_BLACK_LIST_COUNT] intValue]];
    self.personalBrief = [dict objectForKey:USERIDENTITY_PERSONAL_BRIEF];
    self.detailedAddress = [dict objectForKey:USERIDENTITY_DETAILED_ADDRESS];
}

+ (UserIdentity*) userIdentityWithDictionary:(NSDictionary *)dict insideObjectContext:(NSManagedObjectContext*) objectContext
{
    NSEntityDescription *userIdentityDescription = [NSEntityDescription entityForName:@"UserIdentity" inManagedObjectContext:objectContext];
    UserIdentity * userIdentity = [[UserIdentity alloc] initWithEntity:userIdentityDescription insertIntoManagedObjectContext:objectContext];
    userIdentity.uniqueId = [dict objectForKey:USERIDENTITY_UNIQUE_ID];
    [userIdentity updateUserIdentityWithDictionary:dict insideObjectContext:objectContext];
    return [userIdentity autorelease];
}
@end
