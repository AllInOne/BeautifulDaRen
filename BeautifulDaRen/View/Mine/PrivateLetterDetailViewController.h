//
//  PrivateLetterDetailViewController.h
//  BeautifulDaRen
//
//  Created by Jerry Lee on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateLetterDetailViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) NSString * userId;

@property (nonatomic, retain) IBOutlet UIScrollView * contentScrollView;
@property (nonatomic, retain) IBOutlet UIView * footerView;

@property (nonatomic, retain) IBOutlet UITextField * privateLetterComposerView;

-(IBAction)onSendButtonPressed:(id)sender;

@end
