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
- (void)didFinishWithCamera;
@end

@interface TakePhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
@private
    SystemSoundID tickSound;
    UIImagePickerController *imagePickerController;
}

@property (nonatomic, assign) id <TakePhotoControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

- (IBAction)done:(id)sender;
- (IBAction)takePhoto:(id)sender;
@end
