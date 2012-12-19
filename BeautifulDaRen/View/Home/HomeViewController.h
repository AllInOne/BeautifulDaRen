//
//  FirstViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsViewController.h"
#import "AdsPageViewProtocol.h"

@interface HomeViewController : UIViewController<AdsPageViewProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UIView * popUpView;
@property (nonatomic, retain) IBOutlet UITableView * popUpTableView;

- (IBAction)onLoginBtnSelected:(UIButton*)sender;
- (IBAction)onRegisterBtnSelected:(UIButton*)sender;

@end
