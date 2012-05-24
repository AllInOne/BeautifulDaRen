//
//  WeiboComposerViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsSelectionViewControllerDelegate.h"

@interface WeiboForwardCommentViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    FriendsSelectionViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UITextView * weiboContentTextView;
@property (nonatomic, retain) IBOutlet UIView * footerView;
@property (nonatomic, retain) IBOutlet UILabel * checkBoxText;
@property (nonatomic, retain) IBOutlet UIButton * checkBoxButton;
// The mode of the controller, YES == forward mode, NO = comment mode;
@property (nonatomic, assign) BOOL forwardMode;

- (IBAction)onAtFriendPressed:(id)sender;
- (IBAction)onCheckBoxPressed:(id)sender;

- (IBAction)onForward2SinaPressed:(id)sender;
- (IBAction)onForward2TencentPressed:(id)sender;
@end
