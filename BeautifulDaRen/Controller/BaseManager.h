//
//  BaseManager.h
//  AllInOne
//
//  Created by jerry.li on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ControllerConstants.h"

@interface BaseManager : NSObject

@property (nonatomic, assign) loginDoneBlock loginCallback;

- (void)addRequest: (id<RequestProtocol>) request;
- (void)doNotifyLoginStatus:(LOGIN_STATUS)status;
- (void)doNotifyProcessStatus:(AIO_STATUS)status andData:(NSDictionary *)dict;

@end
