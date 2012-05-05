//
//  comment.m
//  BeautifulDaRen
//
//  Created by jerry.li on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Comment.h"

@implementation Comment
@synthesize userId,userName,commentId,content,age;

- (void)dealloc
{
    [userName release];
    [userId release];
    [commentId release];
    [content release];
    [age release];
}
@end
