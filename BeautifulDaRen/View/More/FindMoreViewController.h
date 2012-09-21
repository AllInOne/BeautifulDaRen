//
//  FindMoreViewController.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/8/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonScrollView.h"
#import "ButtonPressDelegate.h"
#import "WaterFlowView.h"

@interface FindMoreViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate, WaterFlowViewDelegate, WaterFlowViewDatasource, CommonScrollViewProtocol, ButtonPressDelegate>

@end
