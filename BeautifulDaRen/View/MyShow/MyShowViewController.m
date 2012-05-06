//
//  MyShowViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyShowViewController.h"

@implementation MyShowViewController

@synthesize takePhotoViewController = _takePhotoViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.takePhotoViewController =
        [[[TakePhotoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
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
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self.takePhotoViewController setupImagePicker:UIImagePickerControllerSourceTypeCamera];
        [self presentModalViewController:self.takePhotoViewController.imagePickerController animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
