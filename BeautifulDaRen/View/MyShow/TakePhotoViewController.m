//
//  FirstViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TakePhotoViewController.h"

@implementation TakePhotoViewController

@synthesize delegate;
@synthesize imagePickerController;
@synthesize takePictureButton;
@synthesize cancelButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:
//                                                    [[NSBundle mainBundle] pathForResource:@"tick"
//                                                                                    ofType:@"aiff"]],
//                                         &tickSound);
//        
        self.imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
        self.imagePickerController.delegate = self;
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:
//                                                [[NSBundle mainBundle] pathForResource:@"tick"
//                                                                                ofType:@"aiff"]],
//                                     &tickSound);
    
//    self.imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
//    self.imagePickerController.delegate = self;
//
//    if ([UIImagePickerController isSourceTypeAvailable:self.imagePickerController.sourceType])
//    {
//        [self setupImagePicker:UIImagePickerControllerSourceTypeCamera];
//        [self presentModalViewController:self.imagePickerController animated:YES];
//    }
}

- (void)viewDidUnload
{
    self.imagePickerController = nil;
    self.takePictureButton = nil;
    self.cancelButton = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [self.imagePickerController release];
    [self.takePictureButton release];
    [self.cancelButton release];
    
    AudioServicesDisposeSystemSoundID(tickSound);
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    [self.imagePickerController setSourceType:sourceType];
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        self.imagePickerController.showsCameraControls = NO;
        
        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
        {
            CGRect defaultFrame = self.imagePickerController.cameraOverlayView.frame;
            CGRect newFrame = CGRectMake(0.0,
                                        430.0,
                                        CGRectGetWidth(defaultFrame),
                                        44.0);
            self.view.frame = newFrame;
            [self.imagePickerController.cameraOverlayView addSubview:self.view];
        }
    }

}

- (IBAction)takePhoto:(id)sender
{
    [self.imagePickerController takePicture];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender
{
    // dismiss the camera
    [self.delegate didFinishWithCamera];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // give the taken picture to our delegate
    if (self.delegate)
        [self.delegate didTakePicture:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate didFinishWithCamera];    // tell our delegate we are finished with the picker
}

@end
















