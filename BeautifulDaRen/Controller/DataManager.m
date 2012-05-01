//
//  BaseManager.m
//  AllInOne
//
//  Created by jerry.li on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"

static DataManager *sharedInstance;

@implementation DataManager

+ (DataManager*) sharedManager {
    @synchronized([DataManager class]) {
        if (!sharedInstance) {
            sharedInstance = [[DataManager alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        //TODO:
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
