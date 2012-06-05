//
//  Comment.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/18/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "Comment.h"
#import "UserIdentity.h"
#import "DataManager.h"

@implementation Comment

@dynamic personId;
@dynamic timeStamp;
@dynamic detail;
@dynamic weiBoId;
@dynamic uniqueId;
@dynamic personName;
@dynamic userIdentity;

- (void)updateCommentWithDictionary:(NSDictionary *)dict insideObjectContext:(NSManagedObjectContext*) objectContext
{
    self.personId = [dict objectForKey:COMMENT_PERSON_ID];
    self.personName = [dict objectForKey:COMMENT_PERSON_NAME];
    self.detail = [dict objectForKey:COMMENT_DETAIL];
    self.weiBoId = [dict objectForKey:COMMENT_WEIBO_ID];
    self.timeStamp = [NSDate dateWithTimeIntervalSince1970: [[dict objectForKey:TIME_STAMP] doubleValue]];
    self.userIdentity = [[DataManager sharedManager] getCurrentLocalIdentityInContext:objectContext];
}

+ (Comment*)commentWithDictionary:(NSDictionary *)dict insideObjectContext:(NSManagedObjectContext*) objectContext
{
    NSEntityDescription *commentDescription = [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:objectContext];
    Comment * comment = [[Comment alloc] initWithEntity:commentDescription insertIntoManagedObjectContext:objectContext];
    comment.uniqueId = [dict objectForKey:COMMENT_UNIQUE_ID];
    [comment updateCommentWithDictionary:dict insideObjectContext:objectContext];
    return [comment autorelease];
}
@end
