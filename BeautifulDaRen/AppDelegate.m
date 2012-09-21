//
//  AppDelegate.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "RootTabViewController.h"
#import "WaitOverlay.h"
#import "ViewConstants.h"
#import "BSDKManager.h"
#import "iToast.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootViewController = _rootViewController;

- (void)dealloc
{
    [_window release];
    [_rootViewController release];
    [_waitOverlay release];
    [_imagePickerController release];

    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    [self.window addSubview:_rootViewController.view];
    [self.window makeKeyAndVisible];

    [_waitOverlay release];
    _waitOverlay = [[WaitOverlay alloc]initWithFrame:self.window.frame];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /*
     Sent to the delegate when the application successfully registers with Apple Push Service (APS).
     */

    NSMutableString * deviceTokenString = [NSMutableString stringWithCapacity:([deviceToken length] * 2)];
    const unsigned char * dataBuffer = (const unsigned char *)[deviceToken bytes];
    for (int i = 0; i < [deviceToken length]; i++) {
        [deviceTokenString appendFormat:@"%02lx", (unsigned long)dataBuffer[i]];
    }
    NSLog(@"device token:%@",deviceToken);
    [[BSDKManager sharedManager] sendDeviceToken:deviceTokenString andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        if(AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
        {
        } else {
            [[iToast makeText:@"系统注册通知服务失败!"] show];
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_MINE_NEW_INFO
                                                        object:self
                                                      userInfo:userInfo];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (UIImagePickerController *)getImagePicker
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
    }

    return _imagePickerController;
}

@end
