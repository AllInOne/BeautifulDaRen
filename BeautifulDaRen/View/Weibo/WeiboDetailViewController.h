//
//  WeiboDetailViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboDetailViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIScrollView * detailScrollView;
@property (nonatomic, retain) NSString * userId;

@property (nonatomic, retain) IBOutlet UILabel  * contentLabel;

@property (nonatomic, retain) IBOutlet UIButton * forwardedButton;
@property (nonatomic, retain) IBOutlet UIButton * commentButton;
@property (nonatomic, retain) IBOutlet UIButton * favourateButton;

-(IBAction)onCommentListButtonPressed:(id)sender;

@end
