//
//  LoginViewController.h
//  BeautifulDaRen
//
//  Created by gang liu on 4/20/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;


-(IBAction)onSinaLoginButtonPressed:(id)sender;
-(IBAction)onTencentLoginButtonPressed:(id)sender;
@end
