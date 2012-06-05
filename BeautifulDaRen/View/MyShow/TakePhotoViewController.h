//
//  FirstViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol TakePhotoControllerDelegate
- (void)didTakePicture:(UIImage *)picture;
- (void)didChangeToGalleryMode;
- (void)didFinishWithCamera;
@end

@interface TakePhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) id <TakePhotoControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;

@property (nonatomic, retain) IBOutlet UIToolbar * toolbarView;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

@end
