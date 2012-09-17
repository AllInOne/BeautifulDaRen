
#import <Foundation/Foundation.h>

#import "BSDKRequest.h"

@class BSDKEngine;

@protocol BSDKEngineDelegate <NSObject>

@optional

// If you try to log in with logIn or logInUsingUserID method, and
// there is already some authorization info in the Keychain,
// this method will be invoked.
// You may or may not be allowed to continue your authorization,
// which depends on the value of isUserExclusive.
- (void)engineAlreadyLoggedIn:(BSDKEngine *)engine;

// Log in successfully.
- (void)engineDidLogIn:(BSDKEngine *)engine;

// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)engine:(BSDKEngine *)engine didFailToLogInWithError:(NSError *)error;

// Log out successfully.
- (void)engineDidLogOut:(BSDKEngine *)engine;

// When you use the WBEngine's request methods,
// you may receive the following four callbacks.
- (void)engineNotAuthorized:(BSDKEngine *)engine;
- (void)engineAuthorizeExpired:(BSDKEngine *)engine;

- (void)engine:(BSDKEngine *)engine requestDidFailWithError:(NSError *)error;
- (void)engine:(BSDKEngine *)engine requestDidSucceedWithResult:(id)result;

@end

@interface BSDKEngine : NSObject <BSDKRequestDelegate>
{
    NSString        *appKey;
    NSString        *appSecret;
    
    NSString        *userID;
    NSString        *accessToken;
    NSTimeInterval  expireTime;
    
    NSString        *redirectURI;
    
    // Determine whether user must log out before another logging in.
    BOOL            isUserExclusive;
    
    BSDKRequest       *request;
    
    id<BSDKEngineDelegate> delegate;
    
    UIViewController *rootViewController;
}

@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) NSString *appSecret;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, assign) NSTimeInterval expireTime;
@property (nonatomic, retain) NSString *redirectURI;
@property (nonatomic, assign) BOOL isUserExclusive;
@property (nonatomic, retain) BSDKRequest *request;
@property (nonatomic, assign) id<BSDKEngineDelegate> delegate;
@property (nonatomic, assign) UIViewController *rootViewController;

// Initialize an instance with the AppKey and the AppSecret you have for your client.
- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;

// Log in using OAuth Web authorization.
// If succeed, engineDidLogIn will be called.
- (void)logIn;

// Log in using OAuth Client authorization.
// If succeed, engineDidLogIn will be called.
- (void)logInUsingUserID:(NSString *)theUserID password:(NSString *)thePassword;

// Log out.
// If succeed, engineDidLogOut will be called.
- (void)logOut;

// Check if user has logged in, or the authorization is expired.
- (BOOL)isLoggedIn;
- (BOOL)isAuthorizeExpired;

// @methodName: The interface you are trying to visit, exp, "statuses/public_timeline.json" for the newest timeline.
// See 
// http://open.weibo.com/wiki/API%E6%96%87%E6%A1%A3_V2
// for more details.
// @httpMethod: "GET" or "POST".
// @params: A dictionary that contains your request parameters.
// @postDataType: "GET" for kWBRequestPostDataTypeNone, "POST" for kWBRequestPostDataTypeNormal or kWBRequestPostDataTypeMultipart.
// @httpHeaderFields: A dictionary that contains HTTP header information.
- (void)loadRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(BSDKRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields;

// Send a Weibo, to which you can attach an image.
- (void)sendWeiBoWithText:(NSString *)text image:(UIImage *)image;

@end
