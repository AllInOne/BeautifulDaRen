//
//  WeiboComposerViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsSelectionViewControllerDelegate.h"
#import "CategorySelectViewController.h"
#import "TakePhotoViewController.h"

@interface WeiboComposerViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    FriendsSelectionViewControllerDelegate,
    SelectCategoryProtocol,TakePhotoControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UIImage * selectedImage;

@property (nonatomic, retain) IBOutlet UITextView * weiboContentTextView;
@property (nonatomic, retain) IBOutlet UITextField * maketTextView;
@property (nonatomic, retain) IBOutlet UITextField * brandTextView;
@property (nonatomic, retain) IBOutlet UITextField * priceTextView;
@property (nonatomic, retain) IBOutlet UITextField * weiboContentBgTextFiled;
@property (nonatomic, retain) IBOutlet UIView * footerView;

@property (nonatomic, retain) IBOutlet UIButton * attachedImageBgButton;

@property (nonatomic, retain) IBOutlet UIButton * locationButton;
@property (nonatomic, retain) UIActivityIndicatorView * locationLoadingView;
@property (nonatomic, retain) IBOutlet UIButton * atButton;
@property (nonatomic, retain) IBOutlet UIButton * categoryButton;

@property (nonatomic, retain) IBOutlet UIScrollView * contentScrollView;

@property (nonatomic, retain) IBOutlet UIButton * sinaButton;
@property (nonatomic, retain) IBOutlet UIImageView * sinaShareImageView;

- (IBAction)onImagePickerPressed:(id)sender;
- (IBAction)onPickedImagePressed:(id)sender;

- (IBAction)onAtFriendPressed:(id)sender;
- (IBAction)onLocationPressed:(id)sender;
- (IBAction)onTraderPressed:(id)sender;
- (IBAction)onCategoryPressed:(id)sender;
- (IBAction)onSinaPressed:(id)sender;
@end
