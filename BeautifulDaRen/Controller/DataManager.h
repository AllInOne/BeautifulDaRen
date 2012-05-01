//
//  BaseManager.h
//  AllInOne
//
//  Created by jerry.li on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// Publice file used to manage the interaction between client and server,
// Also the data storage
#import <Foundation/Foundation.h>
#import "ControllerConstants.h"

@interface DataManager : NSObject

+ (DataManager*) sharedManager;

@end
