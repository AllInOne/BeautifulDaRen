//
//  PrivateLetterViewController.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/17/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateLetterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView * privateLetterTableView;

@property (nonatomic, retain) IBOutlet UIView * footerView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * loadingActivityIndicator;
@property (nonatomic, retain) IBOutlet UIButton * footerButton;

@end
