//
//  WeiboComposerViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsSelectionViewControllerDelegate.h"

@class WeiboForwardCommentViewController;

@protocol ForwardCommentViewControllerProtocol
-(void)onConfirmed:(WeiboForwardCommentViewController*)view;
@end

@interface WeiboForwardCommentViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    FriendsSelectionViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UITextView * weiboContentTextView;
@property (nonatomic, retain) IBOutlet UIView * footerView;
@property (nonatomic, retain) IBOutlet UILabel * checkBoxText;
@property (nonatomic, retain) IBOutlet UIButton * checkBoxButton;
@property (nonatomic, retain) IBOutlet UIButton * atButton;
// The mode of the controller, YES == forward mode, NO = comment mode;
@property (nonatomic, assign) BOOL forwardMode;
@property (nonatomic, assign) BOOL isCheckBoxChecked;

@property (nonatomic, assign) id<ForwardCommentViewControllerProtocol> delegate; 

- (IBAction)onAtFriendPressed:(id)sender;
- (IBAction)onCheckBoxPressed:(id)sender;

- (IBAction)onForward2SinaPressed:(id)sender;
- (IBAction)onForward2TencentPressed:(id)sender;
@end
