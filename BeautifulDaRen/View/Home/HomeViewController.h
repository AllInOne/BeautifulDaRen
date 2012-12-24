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
@property (nonatomic, retain) IBOutlet UIButton * backgroundButton;

- (IBAction)onLoginBtnSelected:(UIButton*)sender;
- (IBAction)onRegisterBtnSelected:(UIButton*)sender;

- (IBAction)onBackgroundBtnSelected:(UIButton*)sender;

@end
