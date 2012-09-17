//
//  RegisterViewController.h
//  BeautifulDaRen
//
//  Created by gang liu on 4/26/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonPressDelegate.h"
#import "SelectCityViewController.h"

@interface RegisterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,ButtonPressDelegate,SelectCityProtocol>

@end
