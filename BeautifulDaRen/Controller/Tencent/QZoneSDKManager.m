//
//  SinaSDKManager.m
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QZoneSDKManager.h"
#import "AppDelegate.h"

@interface QZoneSDKManager ()
@property (nonatomic, retain) TencentOAuth * tencentOAuth;
@property (nonatomic, retain) NSMutableArray* permissions; 

@end


static QZoneSDKManager *sharedInstance;

@implementation QZoneSDKManager

@synthesize tencentOAuth = _tencentOAuth;
@synthesize permissions = _permissions;

+ (QZoneSDKManager*) sharedManager {
    @synchronized([QZoneSDKManager class]) {
        if (!sharedInstance) {
            sharedInstance = [[QZoneSDKManager alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _permissions =  [[NSArray arrayWithObjects:
                          @"get_user_info",@"add_share", @"add_topic",@"add_one_blog", @"list_album", 
                          @"upload_pic",@"list_photo", @"add_album", @"check_page_fans",nil] retain];
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"100628456"
                                                andDelegate:self];
        _tencentOAuth.redirectURI = @"www.qq.com";
    }
    
    return self;
}

- (void)dealloc
{
    [_tencentOAuth release];
    [_permissions release];
    [super dealloc];
}

- (void)loginWithDoneCallback:(loginDoneBlock)doneBlock
{
    Block_release(self.loginCallback);
    self.loginCallback = nil;
    
    [_tencentOAuth authorize:_permissions inSafari:NO];
    
    
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
