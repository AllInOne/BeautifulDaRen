//
//  BaseManager.m
//  AllInOne
//
//  Created by jerry.li on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseManager.h"

@interface BaseManager ()

- (void)addRequest: (id<RequestProtocol>) request;

@property (nonatomic, assign) NSMutableArray * requests;
@property (nonatomic, assign) id<RequestProtocol> currentRequest;

- (void)doNotifyLoginStatus:(LOGIN_STATUS)status;
- (void)doNotifyProcessStatus:(AIO_STATUS)status andData:(NSDictionary *)dict;

@end

@implementation BaseManager

@synthesize loginCallback;
@synthesize requests;
@synthesize currentRequest = _currentRequest;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        requests = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return self;
}

- (void)dealloc
{
    Block_release(self.loginCallback);
    self.loginCallback = nil;
    [super dealloc];
}

- (void)addRequest: (id<RequestProtocol>) request
{
    if (self.currentRequest) {
        [self.requests addObject:request];
    }
    else {
        self.currentRequest = request;
        [self.currentRequest start];
    }
}

- (void)doNotifyLoginStatus:(LOGIN_STATUS)status
{
    if (self.loginCallback) {
        self.loginCallback(status);
        Block_release(self.loginCallback);
        self.loginCallback = nil;
    }
}

- (void)doNotifyProcessStatus:(AIO_STATUS)status andData:(NSDictionary *)dict
{
    if (self.currentRequest) {
        [self.currentRequest doneWithStatus:status andData:dict];
        self.currentRequest = nil;
    }
    
    if ([self.requests count]) {
        self.currentRequest = [self.requests objectAtIndex:0];
        [self.requests removeObjectAtIndex:0];
        [self.currentRequest start];
    }
}


@end
