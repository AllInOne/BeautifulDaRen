//
//  AppDelegate.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaitOverlay;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
@private
    WaitOverlay* _waitOverlay;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IBOutlet UITabBarController *rootViewController;

@end
