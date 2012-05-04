//
//  UserAccount.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/4/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccount : NSObject

// TODO 
@property (retain, nonatomic) NSString * uniqueneId;
@property (retain, nonatomic) NSString * userDisplayId;
@property (assign, nonatomic) NSInteger level;
@property (retain, nonatomic) NSString * levelDescription;
@property (retain, nonatomic) NSString * localCity;
@property (retain, nonatomic) NSData * imageData;

@end
