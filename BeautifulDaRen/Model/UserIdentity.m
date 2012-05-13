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

+ (UserIdentity*) userIdentityWithDictionary:(NSDictionary *)dict insideObjectContext:(NSManagedObjectContext*) objectContext
{
    NSEntityDescription *userIdentityDescription = [NSEntityDescription entityForName:@"UserIdentity" inManagedObjectContext:objectContext];
    UserIdentity * userIdentity = [[UserIdentity alloc] initWithEntity:userIdentityDescription insertIntoManagedObjectContext:objectContext];
    userIdentity.uniqueId = [dict objectForKey:USERIDENTITY_UNIQUE_ID];
    userIdentity.displayName = [dict objectForKey:USERIDENTITY_DISPLAY_NAME];
    userIdentity.level = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_LEVEL] intValue]];
    userIdentity.localCity = [dict objectForKey:USERIDENTITY_LOCAL_CITY];
    userIdentity.isMale = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_IS_MALE] intValue]];
    userIdentity.followCount = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_FOLLOW_COUNT] intValue]];
    userIdentity.fansCount = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_FANS_COUNT] intValue]];
    userIdentity.buyedCount = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_BUYED_COUNT] intValue]];
    userIdentity.collectionCount = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_COLLECTION_COUNT] intValue]];
    userIdentity.topicCount = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_TOPIC_COUNT] intValue]];
    userIdentity.blackListCount = [NSNumber numberWithInt:[[dict objectForKey:USERIDENTITY_BLACK_LIST_COUNT] intValue]];
    userIdentity.personalBrief = [dict objectForKey:USERIDENTITY_PERSONAL_BRIEF];
    userIdentity.detailedAddress = [dict objectForKey:USERIDENTITY_DETAILED_ADDRESS];
    return [userIdentity autorelease];
}
@end
