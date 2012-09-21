//
//  SinaSDKManager.m
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SinaSDKManager.h"
#import "AppDelegate.h"
#import "SinaRequest.h"

#define SINA_WEIBO_APP_KEY          @"3283276068"
#define SINA_WEIBO_APP_SECRET       @"650cf4283c4ef2f79800c046eb92e8e6"

static SinaSDKManager *sharedInstance;

@implementation SinaSDKManager

@synthesize sinaWeiboEngine;

+ (SinaSDKManager*) sharedManager {
    @synchronized([SinaSDKManager class]) {
        if (!sharedInstance) {
            sharedInstance = [[SinaSDKManager alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];

    if (self)
    {
        sinaWeiboEngine = [[WBEngine alloc] initWithAppKey:SINA_WEIBO_APP_KEY                         appSecret:SINA_WEIBO_APP_SECRET];

        [sinaWeiboEngine setRootViewController:((AppDelegate*)[UIApplication sharedApplication].delegate).rootViewController];
        [sinaWeiboEngine setDelegate:self];
        [sinaWeiboEngine setIsUserExclusive:NO];
    }

    return self;
}

- (void)dealloc
{
    [sinaWeiboEngine release];
    [super dealloc];
}

- (BOOL)isLogin
{
    return [sinaWeiboEngine isLoggedIn];
}

- (void)setRootviewController:(UIViewController*)rootViewController
{
    [sinaWeiboEngine setRootViewController:rootViewController];
}

- (void)loginWithDoneCallback:(loginDoneBlock)doneBlock
{
    Block_release(self.loginCallback);
    self.loginCallback = nil;
    if (!sinaWeiboEngine.isLoggedIn) {
        [sinaWeiboEngine logOut];
    }
    [sinaWeiboEngine logIn];
    self.loginCallback = Block_copy(doneBlock);
}

- (void)logout
{
    [sinaWeiboEngine logOut];
}

- (void)sendRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(WBRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields
                     doneCallback:(processDoneWithDictBlock)callback
{
    SinaRequest * sinaRequest = [[SinaRequest alloc] initWithEngine: self.sinaWeiboEngine
                                                         methodName:methodName
                                                         httpMethod:httpMethod
                                                             params:params
                                                       postDataType:postDataType
                                                   httpHeaderFields:httpHeaderFields
                                                       doneCallback:callback];
    [self addRequest:sinaRequest];
    [sinaRequest release];
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
                           postDataType:kWBRequestPostDataTypeMultipart
                       httpHeaderFields:nil
                           doneCallback:callback];
    }
    else
    {
        [self sendRequestWithMethodName:@"statuses/update.json"
                             httpMethod:@"POST"
                                 params:params
                           postDataType:kWBRequestPostDataTypeNormal
                       httpHeaderFields:nil
                           doneCallback:callback];
    }

}

- (void)getInfoOfUser:(NSString*)uid doneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];

    [params setObject:uid forKey:@"uid"];

    [self sendRequestWithMethodName:@"users/show.json"
                         httpMethod:@"GET"
                             params:params
                       postDataType:kWBRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)getMyUidWithDoneCallback:(processDoneWithDictBlock)callback
{
    [self sendRequestWithMethodName:@"account/get_uid.json"
                         httpMethod:@"GET"
                             params:nil
                       postDataType:kWBRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

#pragma mark SINA engine delegates

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    [super doNotifyLoginStatus:LOGIN_STATUS_ALREADY_LOGIN];
}

// Log in successfully.
- (void)engineDidLogIn:(WBEngine *)engine
{
    [super doNotifyLoginStatus:LOGIN_STATUS_SUCCESS];
}

// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    [super doNotifyLoginStatus:LOGIN_STATUS_SERVER_BASE + error.code];
}

// Log out successfully.
- (void)engineDidLogOut:(WBEngine *)engine
{

}

// When you use the WBEngine's request methods,
// you may receive the following four callbacks.
- (void)engineNotAuthorized:(WBEngine *)engine
{

}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{

}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
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

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    NSLog(@"requestDidFailWithError: %@", error);

    [self doNotifyProcessStatus:error.code andData:nil];
}

@end
