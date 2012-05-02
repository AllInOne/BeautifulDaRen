//
//  FirstViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsViewController.h"


@interface HomeViewController : UIViewController

@property (retain, nonatomic) ItemsViewController* itemsViewController;

- (IBAction)onLoginBtnSelected:(UIButton*)sender;
- (IBAction)onRegisterBtnSelected:(UIButton*)sender;

@end
