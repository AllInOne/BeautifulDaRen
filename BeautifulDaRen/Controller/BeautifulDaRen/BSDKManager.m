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
#import "BSDKDefines.h"


static BSDKManager *sharedInstance;

@interface BSDKManager ()
// callback of user
@property (nonatomic, assign) processDoneWithDictBlock loginCallback;
@property (nonatomic, assign) BOOL isAlreadyLogin;

- (void)sendRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(BSDKRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields
                     doneCallback:(processDoneWithDictBlock)callback;
@end

@implementation BSDKManager

@synthesize BSDKWeiboEngine;
@synthesize loginCallback = _loginCallback;
@synthesize isAlreadyLogin = _isAlreadyLogin;

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
        self.isAlreadyLogin = NO;
    }
    
    return self;
}

- (void)dealloc
{
    [BSDKWeiboEngine release];
    Block_release(_loginCallback);
    [super dealloc];
}

- (BOOL)isLogin
{
    return [self isAlreadyLogin];
}

- (void)setRootviewController:(UIViewController*)rootViewController
{
    [BSDKWeiboEngine setRootViewController:rootViewController];   
}

- (void)signUpWithUsername:(NSString*) username password:(NSString*)password email:(NSString*)email city:(NSString*)city andDoneCallback:(processDoneWithDictBlock)doneBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:8];
    
    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_ADD forKey:K_BSDK_ACTION];
    [params setObject:username forKey:K_BSDK_USERNAME];
    [params setObject:password forKey:K_BSDK_PASSWORD];
    [params setObject:password forKey:K_BSDK_REPASSWORD];
    [params setObject:email forKey:K_BSDK_EMAIL];
    [params setObject:city forKey:K_BSDK_City];
    
    processDoneWithDictBlock signupCallbackShim = ^(AIO_STATUS status, NSDictionary * data)
    {
        if ((status == AIO_STATUS_SUCCESS) && K_BSDK_IS_RESPONSE_OK(data))
        {
            self.isAlreadyLogin = YES;
        }
        
        doneBlock(status, data);
    };
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:signupCallbackShim];
}

- (void)loginWithUsername:(NSString*) username password:(NSString*)password andDoneCallback:(processDoneWithDictBlock)doneBlock;
{
    if (self.isLogin) {
        NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:@"已经登陆！",K_BSDK_RESPONSE_MESSAGE, nil];
        doneBlock(AIO_STATUS_BAD_STATE, data);
        
        return;
    }

    processDoneWithDictBlock loginCallbackShim = ^(AIO_STATUS status, NSDictionary * data)
    {
        if ((status == AIO_STATUS_SUCCESS) && K_BSDK_IS_RESPONSE_OK(data))
        {
            self.isAlreadyLogin = YES;
        }
        
        doneBlock(status, data);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_LOGIN forKey:K_BSDK_ACTION];
    [params setObject:username forKey:K_BSDK_USERNAME];
    [params setObject:password forKey:K_BSDK_PASSWORD];

    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:loginCallbackShim];
}

- (void)logoutWithDoneCallback:(processDoneWithDictBlock)doneBlock
{
    processDoneWithDictBlock logoutCallbackShim = ^(AIO_STATUS status, NSDictionary * data)
    {
        if ((status == AIO_STATUS_SUCCESS) && K_BSDK_IS_RESPONSE_OK(data))
        {
            self.isAlreadyLogin = NO;
        }
        
        doneBlock(status, data);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_LOGOUT forKey:K_BSDK_ACTION];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:logoutCallbackShim];
}

- (void)searchUsersByUsername:(NSString*) username andDoneCallback:(processDoneWithDictBlock)doneBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_SEARCH forKey:K_BSDK_ACTION];
    [params setObject:username forKey:K_BSDK_USERNAME];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:doneBlock];
}

- (void)changePasswordByUsername:(NSString*) username toNewPassword:(NSString*)newpassword andDoneCallback:(processDoneWithDictBlock)doneBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_CHANGEPASSWORD forKey:K_BSDK_ACTION];
    [params setObject:username forKey:K_BSDK_USERNAME];
    [params setObject:newpassword forKey:K_BSDK_PASSWORD];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:doneBlock];
}

- (void)getUserInforByUsername:(NSString*) username andDoneCallback:(processDoneWithDictBlock)doneBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETINFO forKey:K_BSDK_ACTION];
    if (username) {
        [params setObject:username forKey:K_BSDK_USERNAME];
    }
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:doneBlock];
}

- (void)sendRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(BSDKRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields
                     doneCallback:(processDoneWithDictBlock)callback
{
    BSDKWeiboRequest * bSDKWeiboRequest = [[BSDKWeiboRequest alloc] initWithEngine: self.BSDKWeiboEngine
                                                                        methodName:methodName
                                                                        httpMethod:httpMethod
                                                                            params:params
                                                                      postDataType:postDataType
                                                                  httpHeaderFields:httpHeaderFields
                                                                      doneCallback:callback];
    [self addRequest:bSDKWeiboRequest];
    [bSDKWeiboRequest release];
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
    NSLog(@"WSDK requestDidSucceed!");
    NSLog(@"WSDK data: %@!", result);
    
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

#pragma mark Weibo related APIs

- (void)getWeiboClassesWithDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETCLASSLIST forKey:K_BSDK_ACTION];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
    
}

- (void)getFriendsWeiboListByUsername:(NSString*)username
                             pageSize:(NSInteger)pageSize 
                            pageIndex:(NSInteger)pageIndex 
                      andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETLIST forKey:K_BSDK_ACTION];
    if (username)
    {
        [params setObject:username forKey:K_BSDK_FOLLOWUSERNAME];
    }
    
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)getWeiboListByUsername:(NSString*)username
                      pageSize:(NSInteger)pageSize 
                     pageIndex:(NSInteger)pageIndex 
               andDoneCallback:(processDoneWithDictBlock)callback
{
    //    if (!self.isLogin) {
    //        callback(AIO_STATUS_NOT_SIGNED_IN, nil);
    //        return;
    //    }
    
//    processDoneWithDictBlock loginCallbackShim = ^(AIO_STATUS status, NSDictionary * data)
//    {
//        callback(status, [data objectForKey:K_BSDK_RESPONSE_BLOGLIST]);
//    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    if (username)
    {
        [params setObject:username forKey:K_BSDK_USERNAME];
    }

    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
    
}
- (void)searchWeiboByKeyword:(NSString*)key
                    pageSize:(NSInteger)pageSize 
                   pageIndex:(NSInteger)pageIndex 
             andDoneCallback:(processDoneWithDictBlock)callback
{
    //    if (!self.isLogin) {
    //        callback(AIO_STATUS_NOT_SIGNED_IN, nil);
    //        return;
    //    }
    
//    processDoneWithDictBlock loginCallbackShim = ^(AIO_STATUS status, NSDictionary * data)
//    {
//        callback(status, [data objectForKey:K_BSDK_RESPONSE_BLOGLIST]);
//    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_SEARCH forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:key forKey:K_BSDK_KEYWORD];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)getWeiboListByClassId:(NSString*)classId
                      pageSize:(NSInteger)pageSize 
                     pageIndex:(NSInteger)pageIndex 
               andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:classId forKey:K_BSDK_UID];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
    
}

- (void)sendWeiBoWithText:(NSString *)text 
                    image:(UIImage *)image 
                     shop:(NSString*)shop
                    brand:(NSString*)branch
                    price:(NSInteger)price
              poslatitude:(float)latitude
             posLongitude:(float)longitude
             doneCallback:(processDoneWithDictBlock)callback
{
    //    if (!self.isLogin) {
    //        callback(AIO_STATUS_NOT_SIGNED_IN, nil);
    //        return;
    //    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_ADD forKey:K_BSDK_ACTION];
    
    // SEND WEIBO DO NOT NEED USERNAME, ONLY FOR TEST, TOBE REMOVED.
//    [params setObject:K_BSDK_TEST_USERNAME forKey:K_BSDK_USERNAME];
    
    [params setObject:text forKey:K_BSDK_CONTENT];
    [params setObject:shop forKey:K_BSDK_SHOPMERCHANT];
    [params setObject:branch forKey:K_BSDK_BRANDSERVICE];
    [params setObject:[NSNumber numberWithInt:price] forKey:K_BSDK_PRICE];
    [params setObject:[NSNumber numberWithFloat:latitude] forKey:K_BSDK_LATITUDE];
    [params setObject:[NSNumber numberWithFloat:longitude] forKey:K_BSDK_LONGITUDE];
    
    if (image)
    {
		[params setObject:image forKey:K_BSDK_PICTURE];
        
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


#pragma mark User related methods
- (void)followUser:(NSString*)username
   andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_FOLLOW forKey:K_BSDK_ACTION];
    [params setObject:username forKey:K_BSDK_USERNAME];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)unFollowUser:(NSString*)username
     andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_UNFOLLOW forKey:K_BSDK_ACTION];
    [params setObject:username forKey:K_BSDK_USERNAME];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

#pragma mark  message related API
- (void)sendComment:(NSString*)comment
            toWeibo:(NSString*)blogId
    andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_SENDCOMMENT forKey:K_BSDK_ACTION];
    [params setObject:comment forKey:K_BSDK_CONTENT];
    [params setObject:blogId forKey:K_BSDK_BLOGUID];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

#pragma mark Social related API

- (void)getFollowList:(NSString*)username
             pageSize:(NSInteger)pageSize 
            pageIndex:(NSInteger)pageIndex 
      andDoneCallback:(processDoneWithDictBlock)callback;
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETFOLLOWLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:username forKey:K_BSDK_USERNAME];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
    
}

- (void)getFollowerList:(NSString*)username
               pageSize:(NSInteger)pageSize 
              pageIndex:(NSInteger)pageIndex 
        andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETFANLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:username forKey:K_BSDK_USERNAME];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST" 
                             params:params 
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
    
}

@end
