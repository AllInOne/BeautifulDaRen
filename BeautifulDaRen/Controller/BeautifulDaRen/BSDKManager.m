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
#import "ViewConstants.h"

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

- (NSMutableDictionary*)getInitializedDictionaryOfCapability:(NSInteger)capability;

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

- (NSMutableDictionary*)getInitializedDictionaryOfCapability:(NSInteger)capability
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:capability];
    
    NSString * sessionKey = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_X_SESSION_KEY];
    
    if (sessionKey) {
        [params setObject:sessionKey forKey:K_BSDK_X_SESSION_KEY];
    }
    return params;
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
    [params setObject:city forKey:K_BSDK_CITY];

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
        
        [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:K_BSDK_X_SESSION_KEY] forKey:USERDEFAULT_X_SESSION_KEY];
        
        doneBlock(status, data);
    };
    
//    [self isSessionValidWithDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//        NSLog(@"##################### %@", data);
//    }];
    
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:5];
    
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
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULT_X_SESSION_KEY];
        
        doneBlock(status, data);
    };

    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:5];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_LOGOUT forKey:K_BSDK_ACTION];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:logoutCallbackShim];
}

- (void)isSessionValidWithDoneCallback:(processDoneWithDictBlock)doneBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETSESSIONID forKey:K_BSDK_ACTION];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:doneBlock];
}

- (void)searchUsersByUsername:(NSString*)username
                     pageSize:(NSInteger)pageSize
                    pageIndex:(NSInteger)pageIndex
              andDoneCallback:(processDoneWithDictBlock)doneBlock
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:username forKey:K_BSDK_USERNAMEKEYWORDS];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:doneBlock];
}

- (void)changePasswordByUsername:(NSString*)username
                     oldPassword:(NSString*)oldPassword
                   toNewPassword:(NSString*)newpassword
                 andDoneCallback:(processDoneWithDictBlock)doneBlock
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:7];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_CHANGEPASSWORD forKey:K_BSDK_ACTION];
    [params setObject:username forKey:K_BSDK_USERNAME];
    [params setObject:newpassword forKey:K_BSDK_PASSWORD];
    [params setObject:newpassword forKey:K_BSDK_REPASSWORD];
    [params setObject:oldPassword forKey:K_BSDK_OLDPASSWORD];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:doneBlock];
}

- (void)getUserInforByUserId:(NSString*)userId andDoneCallback:(processDoneWithDictBlock)doneBlock
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETINFO forKey:K_BSDK_ACTION];
    if (userId) {
        [params setObject:userId forKey:K_BSDK_USERID];
    }

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:doneBlock];
}

- (void)getFavUsersByBlogId:(NSString*) blogId
                   pageSize:(NSInteger)pageSize
                  pageIndex:(NSInteger)pageIndex
            andDoneCallback:(processDoneWithDictBlock)doneBlock
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:blogId forKey:K_BSDK_FAVBLOGUID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:doneBlock];
}

- (void)getUserInforByName:(NSString*) name andDoneCallback:(processDoneWithDictBlock)doneBlock
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETINFO forKey:K_BSDK_ACTION];
    if (name) {
        [params setObject:name forKey:K_BSDK_USERNAME];
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
//    [self addRequest:bSDKWeiboRequest];
    [bSDKWeiboRequest start];
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
    NSDictionary * errorDict = [NSDictionary dictionaryWithObjectsAndKeys:[error localizedDescription], K_BSDK_RESPONSE_MESSAGE, K_BSDK_RESPONSE_STATUS_FAILED, K_BSDK_RESPONSE_STATUS, nil];

    [self doNotifyProcessStatus:error.code andData:errorDict];
}

#pragma mark Weibo related APIs

- (void)getWeiboClassesWithDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];

    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETCLASSLIST forKey:K_BSDK_ACTION];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)getFriendsWeiboListByUserId:(NSString*)userId
                           pageSize:(NSInteger)pageSize
                          pageIndex:(NSInteger)pageIndex
                    andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    if (userId)
    {
        [params setObject:userId forKey:K_BSDK_FANSUSERID];
    }

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)getWeiboListByUserId:(NSString*)userId
                      pageSize:(NSInteger)pageSize
                     pageIndex:(NSInteger)pageIndex
               andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];

    if (userId)
    {
        [params setObject:userId forKey:K_BSDK_USERID];
        [params setObject:K_BSDK_RESPONSE_STATUS_OK forKey:K_BSDK_SHOWFORWARD];
    }

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)getFavWeiboListByUserId:(NSString*)userId
                      pageSize:(NSInteger)pageSize
                     pageIndex:(NSInteger)pageIndex
               andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];

    [params setObject:userId forKey:K_BSDK_FAVUSERID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)getAtWeiboListByUserId:(NSString*)userId
                      pageSize:(NSInteger)pageSize
                     pageIndex:(NSInteger)pageIndex
               andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:7];

    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];

    [params setObject:userId forKey:K_BSDK_ATUSERID];
    [params setObject:K_BSDK_RESPONSE_STATUS_OK forKey:K_BSDK_SHOWFORWARD];

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
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETLIST forKey:K_BSDK_ACTION];
    [params setObject:key forKey:K_BSDK_KEYWORDS];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];

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
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:classId forKey:K_BSDK_CLASSID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)sendWeiboWithText:(NSString *)text
                    image:(UIImage *)image
                     shop:(NSString*)shop
                    brand:(NSString*)branch
                    price:(NSInteger)price
                 category:(NSString*)category
              poslatitude:(float)latitude
             posLongitude:(float)longitude
             doneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:11];
    
    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_ADD forKey:K_BSDK_ACTION];

    [params setObject:text forKey:K_BSDK_CONTENT];
    [params setObject:shop forKey:K_BSDK_SHOPMERCHANT];
    [params setObject:branch forKey:K_BSDK_BRANDSERVICE];
    [params setObject:[NSNumber numberWithInt:price] forKey:K_BSDK_PRICE];
    if (category) {
        [params setObject:category forKey:K_BSDK_CLASSID];
    }

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

- (void)rePostWeiboById:(NSString*)blogId
               WithText:(NSString*)content
            andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:5];

    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_ADD forKey:K_BSDK_ACTION];

    [params setObject:content forKey:K_BSDK_CONTENT];
    [params setObject:blogId forKey:K_BSDK_FORWARDBLOGUID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)getWeiboById:(NSString*)classId
     andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];

    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETINFO forKey:K_BSDK_ACTION];

    [params setObject:classId forKey:K_BSDK_BLOGUID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)deleteWeibo:(NSString *)weiboId
    andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];

    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_DELETE forKey:K_BSDK_ACTION];

    [params setObject:weiboId forKey:K_BSDK_BLOGUID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

#pragma mark User related methods
- (void)followUser:(NSInteger)userId
   andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];

    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_FOLLOW forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", userId] forKey:K_BSDK_USERID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)unFollowUser:(NSInteger)userId
     andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];

    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_UNFOLLOW forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", userId] forKey:K_BSDK_USERID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)modifyUser:(NSString*)userId
              name:(NSString*)name
            gender:(NSString*)gender
             email:(NSString*)email
              city:(NSString*)city
               tel:(NSString*)tel
           address:(NSString*)address
       description:(NSString*)description
            avatar:(UIImage*)avatar
   andDoneCallback:(processDoneWithDictBlock)doneBlock
{

    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:12];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_MODIFY forKey:K_BSDK_ACTION];

    [params setObject:userId forKey:K_BSDK_MODIFYUSERID];

    if (name) {
        [params setObject:name forKey:K_BSDK_USERNAME];
    }

    if (email) {
        [params setObject:email forKey:K_BSDK_EMAIL];
    }

    if (city) {
        [params setObject:city forKey:K_BSDK_CITY];
    }

    if (tel) {
        [params setObject:tel forKey:K_BSDK_TEL];
    }

    if (address) {
        [params setObject:address forKey:K_BSDK_ADDRESS];
    }

    if (gender)
    {
        [params setObject:gender forKey:K_BSDK_GENDER];
    }

    if (description)
    {
        [params setObject:description forKey:K_BSDK_INTRO];
    }

    if (avatar)
    {
		[params setObject:avatar forKey:K_BSDK_PICTURE];

        [self sendRequestWithMethodName:@"statuses/upload.json"
                             httpMethod:@"POST"
                                 params:params
                           postDataType:kBSDKRequestPostDataTypeMultipart
                       httpHeaderFields:nil
                           doneCallback:doneBlock];
    }
    else
    {
        [self sendRequestWithMethodName:@"statuses/update.json"
                             httpMethod:@"POST"
                                 params:params
                           postDataType:kBSDKRequestPostDataTypeNormal
                       httpHeaderFields:nil
                           doneCallback:doneBlock];
    }
}

- (void)getHotUsersByCity:(NSString*)city
                 userType:(NSString*)type
                 pageSize:(NSInteger)pageSize
                pageIndex:(NSInteger)pageIndex
          andDoneCallback:(processDoneWithDictBlock)doneBlock
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:7];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];

    [params setObject:city forKey:K_BSDK_CITY];
    [params setObject:type forKey:K_BSDK_USERTYPE];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:doneBlock];
}

#pragma mark  message related API
- (void)addFavourateForWeibo:(NSString*)blogId
             andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];

    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_ADDFAV forKey:K_BSDK_ACTION];
    [params setObject:blogId forKey:K_BSDK_BLOGUID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)removeFavourateForWeibo:(NSString*)blogId
             andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];

    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_REMOVEFAV forKey:K_BSDK_ACTION];
    [params setObject:blogId forKey:K_BSDK_BLOGUID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)sendComment:(NSString*)comment
            toWeibo:(NSString*)blogId
          toComment:(NSString*)commentId
    andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_SENDCOMMENT forKey:K_BSDK_ACTION];
    [params setObject:comment forKey:K_BSDK_CONTENT];
    [params setObject:blogId forKey:K_BSDK_BLOGUID];
    if(commentId)
    {
        [params setObject:commentId forKey:K_BSDK_COMMENTUID];
    }
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)getCommentListOfWeibo:(NSString*)blogId
                     pageSize:(NSInteger)pageSize
                    pageIndex:(NSInteger)pageIndex
              andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETCOMMENTLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:blogId forKey:K_BSDK_BLOGUID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)getCommentListOfUser:(NSString*)userId
                     pageSize:(NSInteger)pageSize
                    pageIndex:(NSInteger)pageIndex
              andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:7];

    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETCOMMENTLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:userId forKey:K_BSDK_USERID];
    [params setObject:K_BSDK_RESPONSE_STATUS_OK forKey:K_BSDK_SHOWFORWARD];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)removeFan:(NSString*)userId
  andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];

    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_REMOVEFANS forKey:K_BSDK_ACTION];
    [params setObject:userId forKey:K_BSDK_FANSUSERID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

#pragma mark Social related API

- (void)getFollowList:(NSString*)userId
             pageSize:(NSInteger)pageSize
            pageIndex:(NSInteger)pageIndex
      andDoneCallback:(processDoneWithDictBlock)callback;
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETFOLLOWLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:userId forKey:K_BSDK_USERID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)getFollowerList:(NSInteger)userId
               pageSize:(NSInteger)pageSize
              pageIndex:(NSInteger)pageIndex
        andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETFANLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:[NSString stringWithFormat:@"%d", userId] forKey:K_BSDK_USERID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)getAdsByCity:(NSString*)city
                type:(NSInteger)type
     andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:5];

    [params setObject:K_BSDK_CATEGORY_AD forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETADDS forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", type] forKey:K_BSDK_ADSTYPE];
    if (city) {
        [params setObject:city forKey:K_BSDK_CITY];
    }

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)getHelpAndCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:3];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETHELP forKey:K_BSDK_ACTION];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)geAgreementAndCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:3];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETAGREEMENT forKey:K_BSDK_ACTION];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)findPasswordOfUserName:(NSString *)userName
                         email:(NSString *)email
                   andCallBack:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:5];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_FORGET_PASSWORD forKey:K_BSDK_ACTION];
    [params setObject:userName forKey:K_BSDK_USERNAME];
    [params setObject:email forKey:K_BSDK_EMAIL];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)loginSinaUserId:(NSString *)userId
               userName:(NSString *)userName
                    sex:(NSString *)sex
                   city:(NSString *)city
                  email:(NSString *)email
            andCallBack:(processDoneWithDictBlock)callback
{
    if (self.isLogin) {
        NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:@"已经登陆！",K_BSDK_RESPONSE_MESSAGE, nil];
        callback(AIO_STATUS_BAD_STATE, data);

        return;
    }

    processDoneWithDictBlock loginCallbackShim = ^(AIO_STATUS status, NSDictionary * data)
    {
        if ((status == AIO_STATUS_SUCCESS) && K_BSDK_IS_RESPONSE_OK(data))
        {
            self.isAlreadyLogin = YES;
        }

        callback(status, data);
    };

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:7];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_SINAUSERLOGIN forKey:K_BSDK_ACTION];

    if (userId)
    {
        [params setObject:userId forKey:K_BSDK_SINA_USER_ID];
    }
    if (userName)
    {
        [params setObject:userName forKey:K_BSDK_SINA_USER_NAME];
    }
    if (sex)
    {
        [params setObject:sex forKey:K_BSDK_SINA_SEX];
    }
    if (city)
    {
        [params setObject:city forKey:K_BSDK_SINA_CITY];
    }

//    [params setObject:email forKey:K_BSDK_SINA_EMAIL];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:loginCallbackShim];

}

- (void)addNoteToUserId:(NSString *)noteUserId
               noteName:(NSString *)noteName
            andCallBack:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_ADDNOTENAME forKey:K_BSDK_ACTION];
    NSDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
    [params setObject:[userDict valueForKey:K_BSDK_UID] forKey:K_BSDK_USERID];
    [params setObject:noteUserId forKey:K_BSDK_NOTE_USER_ID];
    [params setObject:noteName forKey:K_BSDK_NOTE_NAME];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)sendPrivateMsgToUser:(NSString*)userId
                     content:(NSString*)content
             andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];

    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_SENDPRIVATEMSG forKey:K_BSDK_ACTION];
    [params setObject:content forKey:K_BSDK_CONTENT];
    [params setObject:userId forKey:K_BSDK_RECEIVEUSERID];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)getPrivateMsgUserListByType:(K_BSDK_PRIVATEMSG_USER_TYPE)type
                           pageSize:(NSInteger)pageSize
                          pageIndex:(NSInteger)pageIndex
                    andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:6];
    
    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETPRIVATEUSERLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:[NSString stringWithFormat:@"%d", type] forKey:K_BSDK_USERTYPE];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];

}

- (void)getPrivateMsgListOfUser:(NSString*)userId
                           type:(K_BSDK_PRIVATEMSG_MSG_TYPE)type
                       pageSize:(NSInteger)pageSize
                      pageIndex:(NSInteger)pageIndex
                andDoneCallback:(processDoneWithDictBlock)callback
{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:7];

    [params setObject:K_BSDK_CATEGORY_SNS forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GETPRIVATEMSGLIST forKey:K_BSDK_ACTION];
    [params setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:K_BSDK_PAGEINDEX];
    [params setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:K_BSDK_PAGESIZE];
    [params setObject:userId forKey:K_BSDK_RELATEDUSERID];
    [params setObject:[NSString stringWithFormat:@"%d", type] forKey:K_BSDK_MSGTYPE];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)sendDeviceToken:(NSString *)deviceToken
        andDoneCallback:(processDoneWithDictBlock)callback {

    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:7];

    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_BINDDEVICETOKEN forKey:K_BSDK_ACTION];
    [params setObject:deviceToken forKey:K_BSDK_DEVICETOKEN];

    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)getPushContent:(processDoneWithDictBlock)callback {
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];
    
    [params setObject:K_BSDK_CATEGORY_USER forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_GET_PUSH forKey:K_BSDK_ACTION];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)orderItem:(NSString *)blogId
  andDoneCallback:(processDoneWithDictBlock)callback{
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];
    
    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_BUY forKey:K_BSDK_ACTION];
    
    [params setObject:blogId forKey:K_BSDK_BLOGUID];
    
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)getOrderItemsListForUser:(NSString *)userId
                 andDoneCallback:(processDoneWithDictBlock)callback {
    
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];
    
    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_BUY_LIST forKey:K_BSDK_ACTION];
    
    [params setObject:userId forKey:K_BSDK_USERID];
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)getOrderItemsListForBlog:(NSString *)blogId
                 andDoneCallback:(processDoneWithDictBlock)callback {

    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];
    
    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_BUY_LIST forKey:K_BSDK_ACTION];
    
    [params setObject:blogId forKey:K_BSDK_BLOGUID];
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

- (void)cancelOrder:(NSString *)orderId
    andDoneCallback:(processDoneWithDictBlock)callback {
    NSMutableDictionary *params = [self getInitializedDictionaryOfCapability:4];

    [params setObject:K_BSDK_CATEGORY_BLOG forKey:K_BSDK_CATEGORY];
    [params setObject:K_BSDK_ACTION_CANCEL_BUY forKey:K_BSDK_ACTION];

    [params setObject:orderId forKey:K_BSDK_ORDER_ID];
    [self sendRequestWithMethodName:nil
                         httpMethod:@"POST"
                             params:params
                       postDataType:kBSDKRequestPostDataTypeNormal
                   httpHeaderFields:nil
                       doneCallback:callback];
}

@end
