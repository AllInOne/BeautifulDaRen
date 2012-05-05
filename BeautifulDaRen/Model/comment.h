//
//  comment.h
//  BeautifulDaRen
//
//  Created by jerry.li on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, retain) NSString * commentId;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * age;
@end
