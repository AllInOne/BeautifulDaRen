//
//  WeiboComposerViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboComposerViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton * cameraButton;
@property (nonatomic, retain) IBOutlet UITextView * weiboContentTextView;
@property (nonatomic, retain) IBOutlet UITextField * maketTextView;
@property (nonatomic, retain) IBOutlet UITextField * brandTextView;
@property (nonatomic, retain) IBOutlet UIView * footerView;

@end
