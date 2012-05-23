//
//  FirstViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "ViewConstants.h"
#import "ViewHelper.h"
#import "WeiboForwardCommentViewController.h"

@interface TakePhotoViewController ()
@property (nonatomic, retain)  TakePhotoViewController * galleryPhotoViewController;
@property (nonatomic, assign)  UIImagePickerControllerSourceType currentSourceType; 

- (void)setToolbar;
@end

@implementation TakePhotoViewController

@synthesize delegate;
@synthesize imagePickerController;
@synthesize galleryPhotoViewController = _galleryPhotoViewController;
@synthesize currentSourceType = _currentSourceType;
@synthesize toolbarView = _toolbarView;


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
    self.toolbarView = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [self.imagePickerController release];
    [self.toolbarView release];
    
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

- (void)onGalleryBartButtonPressed {
    [self.delegate didChangeToGalleryMode];
    self.imagePickerController.cameraOverlayView = nil;
}

- (void)onCameraBarButtonPressed {
    [self.imagePickerController takePicture]; 
}

- (void)onAvatarBartButtonPressed {
    
}

- (void)setToolbar
{
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *galleryBarButton = [ViewHelper getBarItemOfTarget:self action:@selector(onGalleryBartButtonPressed) title:@"相册"];
    
    UIBarButtonItem *cameraBarButton = [ViewHelper getCameraBarItemOftarget:self action:@selector(onCameraBarButtonPressed)];
    
    UIBarButtonItem *avatarBarButton = [ViewHelper getBarItemOfTarget:self action:@selector(onAvatarBartButtonPressed) title:@"头像"];

    
    NSArray *barItems = [[NSArray alloc]initWithObjects:galleryBarButton, 
                         flexible,
                         cameraBarButton,
                         flexible,
                         avatarBarButton,
                         nil];
    
    self.toolbarView.items= barItems;
    
    [flexible release];
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
            self.toolbarView.frame = newFrame;
            UIImageView * tabBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_toolbar_background"]];
            tabBarBg.frame = CGRectMake(0, 0, 320, 55);
            tabBarBg.contentMode = UIViewContentModeScaleToFill;
            if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
                [self.toolbarView  insertSubview:tabBarBg atIndex:0];
            }
            else
            {
                [self.toolbarView  insertSubview:tabBarBg atIndex:1];            
            }
            [self setToolbar];
            [tabBarBg release];
            [self.imagePickerController.cameraOverlayView addSubview:self.toolbarView];
        }
    }
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
















