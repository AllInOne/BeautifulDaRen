//
//  MineEditingViewController.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/10/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonPressDelegate.h"
#import "SegmentDelegate.h"
#import "SelectCityViewController.h"

@interface MineEditingViewController
: UITableViewController <UITableViewDelegate, UITableViewDataSource, ButtonPressDelegate, SegmentDelegate, SelectCityProtocol>

@end
