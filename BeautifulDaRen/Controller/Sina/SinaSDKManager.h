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

- (void)loginWithDoneCallback:(loginDoneBlock)doneBlock;

- (void)sendRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(WBRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields
                     doneCallback:(processDoneWithDictBlock)callback;
@end