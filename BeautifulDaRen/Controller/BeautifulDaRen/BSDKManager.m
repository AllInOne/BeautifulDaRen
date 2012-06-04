//
//  SinaSDKManager.m
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BSDKManager.h"
#import "AppDelegate.h"

@interface BSDKManager ()

@end


static BSDKManager *sharedInstance;

@implementation BSDKManager

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
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)loginWithDoneCallback:(loginDoneBlock)doneBlock
{
    Block_release(self.loginCallback);
    self.loginCallback = nil;

    self.loginCallback = Block_copy(doneBlock);
}

- (void)sendWeiBoWithText:(NSString *)text image:(UIImage *)image doneCallback:(processDoneWithDictBlock)callback
{

}

/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin {
	// 登录成功
    [super doNotifyLoginStatus:LOGIN_STATUS_SUCCESS];
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
	if (cancelled){
		[super doNotifyLoginStatus:LOGIN_STATUS_USER_CANCEL];
	}
	else {
		[super doNotifyLoginStatus:LOGIN_STATUS_FAILED];
	}
	
}

/**
 * Called when the notNewWork.
 */
-(void)tencentDidNotNetWork
{

}

@end
