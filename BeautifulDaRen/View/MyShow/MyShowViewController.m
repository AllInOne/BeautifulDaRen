//
//  MyShowViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyShowViewController.h"
#import "ViewConstants.h"
#import "PhotoConfirmViewController.h"
#import "WeiboComposerViewController.h"
#import "UIImage+Scale.h"

@interface MyShowViewController ()
@property (nonatomic, assign) UIImagePickerControllerSourceType currentType;
@property (nonatomic, assign) BOOL shouldShowSelf;
@end

@implementation MyShowViewController

@synthesize takePhotoViewController = _takePhotoViewController;
@synthesize selectPhotoViewController = _selectPhotoViewController;
@synthesize currentType = _currentType;
@synthesize shouldShowSelf = _shouldShowSelf;

- (void)dealloc
{
    [_takePhotoViewController release];
    [_selectPhotoViewController release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.takePhotoViewController =
        [[[TakePhotoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        self.currentType = UIImagePickerControllerSourceTypeCamera;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.takePhotoViewController =
    [[[TakePhotoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    [self.takePhotoViewController setDelegate:self];
    self.currentType = UIImagePickerControllerSourceTypeCamera;
    self.shouldShowSelf = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UIImagePickerController isSourceTypeAvailable:self.currentType] && self.shouldShowSelf)
    {
        if (self.currentType == UIImagePickerControllerSourceTypeCamera) {
            [self.takePhotoViewController setupImagePicker:self.currentType];
            [self presentModalViewController:self.takePhotoViewController.imagePickerController animated:YES];
            self.shouldShowSelf = NO;
            //[self.takePhotoViewController.imagePickerController release];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _takePhotoViewController = nil;
    _selectPhotoViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark TakePhotoControllerDelegate

- (void)didTakePicture:(UIImage *)picture
{
    self.shouldShowSelf = NO;
    WeiboComposerViewController *weiboComposerViewControlller = 
    [[WeiboComposerViewController alloc] initWithNibName:nil bundle:nil];
    
    weiboComposerViewControlller.selectedImage = [picture scaleToSize:CGSizeMake(320.0, picture.size.height * 320.0/picture.size.width)];

    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboComposerViewControlller];
    
    [self dismissModalViewControllerAnimated:NO];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    [navController release];
    [weiboComposerViewControlller release];
    
    [self.tabBarController setSelectedIndex:0];
    self.currentType = UIImagePickerControllerSourceTypeCamera;
    self.shouldShowSelf = YES;
}

- (void)didFinishWithCamera
{
    [self.tabBarController setSelectedIndex:0];
    self.currentType = UIImagePickerControllerSourceTypeCamera;
    self.shouldShowSelf = YES;
}

- (void)didChangeToGalleryMode
{
    self.currentType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.shouldShowSelf = NO;
    
    if (_selectPhotoViewController == nil) {
        self.selectPhotoViewController =
        [[[TakePhotoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        
        [self.selectPhotoViewController setDelegate:self];
    }
    
    [self dismissModalViewControllerAnimated:NO];
    
    [self.selectPhotoViewController setupImagePicker:self.currentType];
    [self.parentViewController presentModalViewController:self.selectPhotoViewController.imagePickerController animated:YES];
    //[self.takePhotoViewController.imagePickerController release];
}
@end
