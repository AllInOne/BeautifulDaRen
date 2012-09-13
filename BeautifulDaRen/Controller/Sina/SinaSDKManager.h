//
//  SinaSDKManager.h
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ControllerConstants.h"
#import "WBEngine.h"
#import "BaseManager.h"

@interface SinaSDKManager : BaseManager <WBEngineDelegate>

@property (strong, nonatomic) WBEngine *sinaWeiboEngine;

+ (SinaSDKManager*) sharedManager;

- (BOOL)isLogin;

- (void)logout;

- (void)setRootviewController:(UIViewController*)rootViewController;

- (void)loginWithDoneCallback:(loginDoneBlock)doneBlock;

- (void)getInfoOfUser:(NSString*)uid doneCallback:(processDoneWithDictBlock)callback;

- (void)getMyUidWithDoneCallback:(processDoneWithDictBlock)callback;

- (void)sendRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(WBRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields
                     doneCallback:(processDoneWithDictBlock)callback;

- (NSString*)getDisplayStringOfCityCode:(NSString*)code;

// Send a Weibo, to which you can attach an image.
- (void)sendWeiBoWithText:(NSString *)text image:(UIImage *)image doneCallback:(processDoneWithDictBlock)callback;
@end
