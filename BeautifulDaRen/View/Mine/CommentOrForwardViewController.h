//
//  CommentOrForwardViewController.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/20/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>

enum
{
    CommentOrForwardViewControllerType_COMMENT = 0,
    CommentOrForwardViewControllerType_FORWARD
};

@interface CommentOrForwardViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger)type;

@end
