//
//  LoadFakeData.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/19/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadFakeData : NSObject

+(LoadFakeData*) sharedLoadManager;
-(void) load;

@end
