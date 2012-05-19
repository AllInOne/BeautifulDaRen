//
//  PrivateLetter.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/18/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserIdentity;

@interface PrivateLetter : NSManagedObject

@property (nonatomic, retain) NSString * personId;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSString * personName;
@property (nonatomic, retain) UserIdentity *userIdentity;

@end
