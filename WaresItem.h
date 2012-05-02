//
//  WaresItem.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaresItem : NSObject

// TODO  the id maybe NSNumber
@property (retain, nonatomic) NSString * itemId;
@property (retain, nonatomic) NSString * itemTitle;
@property (retain, nonatomic) NSData * itemImageData;

@end
