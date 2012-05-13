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
                                         CGRectGetHeight(defaultFrame) -
                                         self.view.frame.size.height - 10.0,
                                         CGRectGetWidth(defaultFrame),
                                         self.view.frame.size.height + 10.0);
            self.view.frame = newFrame;
            [self.imagePickerController.cameraOverlayView addSubview:self.view];
        }
    }
    else
    {
        
    }
}

- (IBAction)takePhoto:(id)sender
{
    [self.imagePickerController takePicture];
}

- (IBAction)done:(id)sender
{
    // dismiss the camera
    //[self.delegate didFinishWithCamera];
    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
//    {
//        self.galleryPhotoViewController = nil;
//        self.galleryPhotoViewController = [[[TakePhotoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//        
//        [self.galleryPhotoViewController setupImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
//        [self presentModalViewController:self.galleryPhotoViewController.imagePickerController animated:YES];
//        [self.galleryPhotoViewController.imagePickerController setDelegate:self];
//        self.currentSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
    WeiboForwardCommentViewController *forwardViewContoller = 
    [[[WeiboForwardCommentViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    forwardViewContoller.forwardMode = YES;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: forwardViewContoller];
    
    [self presentModalViewController:navController animated:YES];
    
    [navController release];
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
        [self.delegate didTakePicture:image sourceType:self.currentSourceType];

    if (self.currentSourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [self.galleryPhotoViewController dismissModalViewControllerAnimated:NO];
        self.galleryPhotoViewController = nil;
        self.currentSourceType = UIImagePickerControllerSourceTypeCamera;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.currentSourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self dismissModalViewControllerAnimated:YES];
        self.currentSourceType = UIImagePickerControllerSourceTypeCamera;
        [self.imagePickerController reloadInputViews];
    }
    else
    {
        [self.delegate didFinishWithCamera];    
    }

}

@end
















