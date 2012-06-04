//
//  SinaSDKManager.h
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ControllerConstants.h"
#import "BSDKEngine.h"
#import "BaseManager.h"

@interface BSDKManager : BaseManager <BSDKEngineDelegate>

@property (strong, nonatomic) BSDKEngine *BSDKWeiboEngine;

+ (BSDKManager*) sharedManager;

- (BOOL)isLogin;

- (void)setRootviewController:(UIViewController*)rootViewController;

- (void)loginWithDoneCallback:(loginDoneBlock)doneBlock;

- (void)sendRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(BSDKRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields
                     doneCallback:(processDoneWithDictBlock)callback;

// Send a Weibo, to which you can attach an image.
- (void)sendWeiBoWithText:(NSString *)text image:(UIImage *)image doneCallback:(processDoneWithDictBlock)callback;
@end
