//
//  SinaSDKManager.h
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ControllerConstants.h"
#import "BaseManager.h"
#import "TencentOAuth.h"

@interface QZoneSDKManager : BaseManager <TencentSessionDelegate>

+ (QZoneSDKManager*) sharedManager;

- (void)loginWithDoneCallback:(loginDoneBlock)doneBlock;

// Send a Weibo, to which you can attach an image.
- (void)sendWeiBoWithText:(NSString *)text image:(UIImage *)image doneCallback:(processDoneWithDictBlock)callback;
@end
