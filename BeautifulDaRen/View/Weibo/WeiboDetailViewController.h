//
//  WeiboDetailViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboForwardCommentViewController.h"

/// There are two ways to use WeiboDetailViewController
/// 1. set the weiboData before present the view
/// 2. set the weiboId before present the view.

/// If all of them are presented, weiboId will not be used.

@interface WeiboDetailViewController : UIViewController <ForwardCommentViewControllerProtocol>

@property (nonatomic, retain) IBOutlet UIScrollView * detailScrollView;
@property (nonatomic, retain) NSString * userId;

@property (nonatomic, retain) IBOutlet UILabel  * contentLabel;
@property (nonatomic, retain) IBOutlet UILabel  * timestampLabel;
@property (nonatomic, retain) IBOutlet UILabel  * usernameLabel;

@property (nonatomic, retain) IBOutlet UIButton * forwardedButton;
@property (nonatomic, retain) IBOutlet UIButton * commentButton;
@property (nonatomic, retain) IBOutlet UIButton * favourateButton;

@property (nonatomic, retain) IBOutlet UIButton * priceButton;
@property (nonatomic, retain) IBOutlet UILabel * merchantLable;
@property (nonatomic, retain) IBOutlet UILabel * brandLable;

@property (nonatomic, retain) IBOutlet UIImageView * avatarImageView;
@property (nonatomic, retain) IBOutlet UIImageView * weiboAttachedImageView;
@property (nonatomic, retain) IBOutlet UIButton * weiboAttachedImageButton;

-(IBAction)onCommentListButtonPressed:(UIButton*)sender;
-(IBAction)onForwardButtonPressed:(UIButton*)sender;

/// Only one of them should be presented
@property (nonatomic, retain) NSDictionary * weiboData;
@property (nonatomic, retain) NSString * weiboId;

-(IBAction)onImageButtonPressed:(id)sender;

-(IBAction)onBrandButtonPressed:(id)sender;
-(IBAction)onBusinessButtonPressed:(id)sender;
@end
