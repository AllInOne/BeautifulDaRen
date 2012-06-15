//
//  CommonViewController.h
//  BeautifulDaRen
//
//  Created by gang liu on 6/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonPressDelegate.h"

enum
{
    FriendListViewController_TYPE_MY_FOLLOW = 0,
    FriendListViewController_TYPE_MY_FANS,
    FriendListViewController_TYPE_MY_BLACKLIST,
    FriendListViewController_TYPE_FRIEND_FOLLOW,
    FriendListViewController_TYPE_FRIEND_FANS
};

@interface FriendListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, ButtonPressDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger)type;
@end
