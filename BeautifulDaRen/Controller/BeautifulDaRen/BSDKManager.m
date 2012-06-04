//
//  SinaSDKManager.m
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BSDKManager.h"
#import "AppDelegate.h"
#import "BSDKWeiboRequest.h"
#import "BSDKEngine.h"


static BSDKManager *sharedInstance;

@implementation BSDKManager

@synthesize BSDKWeiboEngine;

+ (BSDKManager*) sharedManager {
    @synchronized([BSDKManager class]) {
        if (!sharedInstance) {
            sharedInstance = [[BSDKManager alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        BSDKWeiboEngine = [[BSDKEngine alloc] initWithAppKey:nil appSecret:nil];
        
        [BSDKWeiboEngine setRootViewController:((AppDelegate*)[UIApplication sharedApplication].delegate).rootViewController];
        [BSDKWeiboEngine setDelegate:self];
        [BSDKWeiboEngine setIsUserExclusive:NO];
    }
    
    return self;
}

- (void)dealloc
{
    [BSDKWeiboEngine release];
    [super dealloc];
}

- (BOOL)isLogin
{
    return [BSDKWeiboEngine isLoggedIn];
}

- (void)setRootviewController:(UIViewController*)rootViewController
{
    [BSDKWeiboEngine setRootViewController:rootViewController];   
}

- (void)loginWithDoneCallback:(loginDoneBlock)doneBlock
{
    Block_release(self.loginCallback);
    self.loginCallback = nil;
    if (!BSDKWeiboEngine.isLoggedIn) {
        [BSDKWeiboEngine logOut];
    }
    [BSDKWeiboEngine logIn];
    self.loginCallback = Block_copy(doneBlock);
}

- (void)sendRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(BSDKRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields
                     doneCallback:(processDoneWithDictBlock)callback
{
    [self addRequest:[[BSDKWeiboRequest alloc] initWithEngine: self.BSDKWeiboEngine
                                              methodName:methodName
                                              httpMethod:httpMethod
                                                  params:params
                                            postDataType:postDataType
                                        httpHeaderFields:httpHeaderFields
                                            doneCallback:callback]];
}

- (void)sendWeiBoWithText:(NSString *)text image:(UIImage *)image doneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    
	[params setObject:(text ? text : @"") forKey:@"status"];
	
    if (image)
    {
		[params setObject:image forKey:@"pic"];
        
        [self sendRequestWithMethodName:@"statuses/upload.json" 
                             httpMethod:@"POST" 
                                 params:params 
                           postDataType:kBSDKRequestPostDataTypeMultipart
                       httpHeaderFields:nil
                           doneCallback:callback];
    }
    else
    {
        [self sendRequestWithMethodName:@"statuses/update.json" 
                             httpMethod:@"POST" 
                                 params:params 
                           postDataType:kBSDKRequestPostDataTypeNormal
                       httpHeaderFields:nil
                           doneCallback:callback];
    }
    
}

#pragma mark SINA engine delegates

- (void)engineAlreadyLoggedIn:(BSDKEngine *)engine
{
    [super doNotifyLoginStatus:LOGIN_STATUS_ALREADY_LOGIN];
}

// Log in successfully.
- (void)engineDidLogIn:(BSDKEngine *)engine
{
    [super doNotifyLoginStatus:LOGIN_STATUS_SUCCESS];
}

// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)engine:(BSDKEngine *)engine didFailToLogInWithError:(NSError *)error
{
    [super doNotifyLoginStatus:LOGIN_STATUS_SERVER_BASE + error.code];
}

// Log out successfully.
- (void)engineDidLogOut:(BSDKEngine *)engine
{
    
}

// When you use the BSDKEngine's request methods,
// you may receive the following four callbacks.
- (void)engineNotAuthorized:(BSDKEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(BSDKEngine *)engine
{
    
}

- (void)engine:(BSDKEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSLog(@"SINA requestDidSucceed!");
    NSLog(@"SINA data: %@!", result);
    
    NSDictionary *dict = nil;
    if ([result isKindOfClass:[NSDictionary class]])
    {
        dict = (NSDictionary *)result;
    }
    
    [self doNotifyProcessStatus:AIO_STATUS_SUCCESS andData:dict];
}

- (void)engine:(BSDKEngine *)engine requestDidFailWithError:(NSError *)error
{
    NSLog(@"requestDidFailWithError: %@", error);
    
    [self doNotifyProcessStatus:error.code andData:nil];
}

@end
