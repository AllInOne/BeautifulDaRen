//
//  FirstViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "ViewConstants.h"
#import "WeiboForwardCommentViewController.h"

@interface TakePhotoViewController ()
@property (nonatomic, retain)  TakePhotoViewController * galleryPhotoViewController;
@property (nonatomic, assign)  UIImagePickerControllerSourceType currentSourceType; 
@end

@implementation TakePhotoViewController

@synthesize delegate;
@synthesize imagePickerController;
@synthesize takePictureButton;
@synthesize cancelButton;
@synthesize galleryPhotoViewController = _galleryPhotoViewController;
@synthesize currentSourceType = _currentSourceType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
        self.imagePickerController.delegate = self;
        self.currentSourceType = UIImagePickerControllerSourceTypeCamera;
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
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//
//    if (self.currentSourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
//        self.imagePickerController.cameraOverlayView = nil;
//    }
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
    self.currentSourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        self.imagePickerController.showsCameraControls = NO;

        CGRect defaultFrame = self.imagePickerController.cameraOverlayView.frame;
        CGRect newFrame = CGRectMake(0.0,
                                     SCREEN_HEIGHT -
                                     TOOL_BAR_HEIGHT - 10.0,
                                     CGRectGetWidth(defaultFrame),
                                     TOOL_BAR_HEIGHT + 10.0);
        self.view.frame = newFrame;
        
        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
        {

            [self.imagePickerController.cameraOverlayView addSubview:self.view];
        }
    }
}

- (IBAction)takePhoto:(id)sender
{
    [self.imagePickerController takePicture];
}

- (IBAction)done:(id)sender
{
    // dismiss the camera
//    [self.delegate didFinishWithCamera];
    [self.delegate didChangeToGalleryMode];
    self.imagePickerController.cameraOverlayView = nil;
    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
//    {
//        self.galleryPhotoViewController = nil;
//        self.galleryPhotoViewController = [[[TakePhotoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//        
//        [self.galleryPhotoViewController setupImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
//        [self presentModalViewController:self.galleryPhotoViewController.imagePickerController animated:YES];
//        [self.galleryPhotoViewController.imagePickerController setDelegate:self];
//        self.currentSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        
//        // reomve and readd the overlay to work around a display issue
////        self.imagePickerController.cameraOverlayView = nil;
//    }

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

    if (self.currentSourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [self.galleryPhotoViewController dismissModalViewControllerAnimated:NO];
        self.galleryPhotoViewController = nil;
        self.currentSourceType = UIImagePickerControllerSourceTypeCamera;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    if (self.currentSourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self dismissModalViewControllerAnimated:YES];
    }
    [self.delegate didFinishWithCamera]; 
}

@end
















