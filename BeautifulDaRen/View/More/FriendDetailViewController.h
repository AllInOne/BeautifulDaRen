//
//  FriendDetailViewController.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/21/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonPressDelegate.h"

@interface FriendDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ButtonPressDelegate, UIActionSheetDelegate>
-(id)initWithDictionary:(NSDictionary*)dictionary;
-(id)initWithFriendId:(NSString*)friendId;
@end
