/***********************************************************************
 *
 * Copyright (C) 2001-2012 Myriad Group AG. All Rights Reserved.
 *
 * File     :   $Id: //depot/ds/projects/MSSS/pivot/apps/Pivot/Pivot/View/FullImageViewController.m#1 $
 * Purpose  :   TBD
 ***********************************************************************/

#import <QuartzCore/QuartzCore.h>
#import "FullImageViewController.h"
#import "DataManager.h"
#import "ViewConstants.h"
#import "ViewHelper.h"
#import "UIImageView+WebCache.h"

@interface FullImageViewController ()
- (IBAction)onClickSaveButton:(id)sender;
- (IBAction)onClickReturnButton:(id)sender;
- (void)didFinishSaveImage:(UIImage *)image withError:(NSError *)error contextInfo:(void *)contextInfo;
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleTimerHideNavBar:(NSTimer*)theTimer;
- (void)clearHideNavBarTimer;
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
- (void)resetHideNavBarTimer;
- (void)setImage:(UIImage* )newImage;

@property (nonatomic, assign) CGSize imageSize;
@end

@implementation FullImageViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize imageParentView = _imageParentView;
@synthesize indicator = _indicator;
@synthesize indicatorLabel = _indicatorLabel;
@synthesize rightBarButton = _rightBarButton;
@synthesize leftBarButton = _leftBarButton;
@synthesize singleTap = _singleTap;
@synthesize doubleTap = _doubleTap;
@synthesize frozenSingleTap;
@synthesize timerHideNavBar = _timerHideNavBar;
@synthesize imageData = _imageData;
@synthesize imageUrl = _imageUrl;
@synthesize imageSize = _imageSize;

+ (void)showImageUrl:(NSString* )imageUrl size:(CGSize)size inNavigationController:(UINavigationController* )parentNav
{
    FullImageViewController* fullImageViewController = [[FullImageViewController alloc] initWithNibName:nil bundle:nil];
    
    [fullImageViewController setImageUrl:imageUrl];
    [fullImageViewController setImageSize:size];
    
    UINavigationController * navController= [[UINavigationController alloc] initWithRootViewController:fullImageViewController];
    [parentNav presentModalViewController:navController animated:YES];
    [navController release];
    [fullImageViewController release];
}

+ (void)showImage:(UIImage* )image inNavigationController:(UINavigationController* )parentNav {
    
    FullImageViewController* fullImageViewController = [[FullImageViewController alloc] initWithNibName:nil bundle:nil];

    [fullImageViewController setImageData:image];
    
    UINavigationController * navController= [[UINavigationController alloc] initWithRootViewController:fullImageViewController];
    [parentNav presentModalViewController:navController animated:YES];
    [navController release];
    [fullImageViewController release];
}

- (void)dealloc
{
    [_timerHideNavBar invalidate];
    [self.scrollView removeGestureRecognizer:self.singleTap];
    [self.scrollView removeGestureRecognizer:self.doubleTap];
    
    [_timerHideNavBar release];
    [_singleTap release];
    [_doubleTap release];
    [_scrollView release];
    [_imageView release];
    [_indicator release];
    [_indicatorLabel release];
    [_rightBarButton release];
    [_leftBarButton release];
    [_imageParentView release];
    [_imageData release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = NSLocalizedString(@"picture", @"picture");
    
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onClickReturnButton:) title:NSLocalizedString(@"go_back", @"go_back")]];
    
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onClickSaveButton:) title:NSLocalizedString(@"save", @"save")]];   
    
    self.frozenSingleTap = NO;
    
    [self setImage:self.imageData];
    
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.scrollView addGestureRecognizer:_singleTap];
    
    _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:_doubleTap];
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)onClickSaveButton:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(didFinishSaveImage:withError:contextInfo:), nil);
}

- (void)onClickReturnButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didFinishSaveImage:(UIImage *)image withError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        
    }
    else {

    }
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (!self.frozenSingleTap) {
        
        [self clearHideNavBarTimer];
        
        self.frozenSingleTap = YES;

        [UIView animateWithDuration:0.5
                         animations:^{
                             if (self.navigationController.navigationBar.alpha == 1.0) {
                                 self.navigationController.navigationBar.alpha = 0.0;
                             }
                             else {
                                 self.navigationController.navigationBar.alpha = 1.0;
                             }
                         } completion:^(BOOL finished) {
                             self.frozenSingleTap = NO;
                             
                             if (self.navigationController.navigationBar.alpha == 1.0) {
                                 [self resetHideNavBarTimer];
                             }
                         }];
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    [UIView animateWithDuration:0.5 animations:^{
        float newScale = 0.0f;
        if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
            newScale = self.scrollView.minimumZoomScale;
        }
        else {
            newScale = self.scrollView.maximumZoomScale;
        }
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }];
}

- (void)handleTimerHideNavBar:(NSTimer*)theTimer {
    [UIView animateWithDuration:0.5
                     animations:^{
                         if (self.navigationController.navigationBar.alpha == 1.0) {
                             self.navigationController.navigationBar.alpha = 0.0;
                         }
                         else {
                             self.navigationController.navigationBar.alpha = 1.0;
                         }
    }]; 
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


- (void)clearHideNavBarTimer {
    [self.timerHideNavBar invalidate];
    self.timerHideNavBar = nil;
}

- (void)resetHideNavBarTimer {
    if (self.timerHideNavBar) {
        [self clearHideNavBarTimer];
    }

    self.timerHideNavBar = [NSTimer timerWithTimeInterval:5.0
                                                   target:self
                                                 selector:@selector(handleTimerHideNavBar:)
                                                 userInfo:nil
                                                  repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timerHideNavBar forMode:NSDefaultRunLoopMode];
}

// Make sure the image's size is fit to the scrollview's.
//
- (void)setImage:(UIImage* )newImage {

    float widthScale = 0.0f;
    float heightScale = 0.0f;
    if (newImage) {
        self.imageView.image = newImage;
        [self.imageView sizeToFit];
        widthScale = self.imageView.frame.size.width / self.scrollView.frame.size.width;
        heightScale = self.imageView.frame.size.height / self.scrollView.frame.size.height;
    }
    else
    {
        [self.imageView setImageWithURL:[NSURL URLWithString:self.imageUrl]];
        self.imageView.frame = CGRectMake(0.0f, 
                                          0.0f, 
                                          self.imageSize.width, 
                                          self.imageSize.height);        
        widthScale = self.imageSize.width / self.scrollView.frame.size.width;
        heightScale = self.imageSize.height / self.scrollView.frame.size.height;
    }


    float compressScale = fmaxf(widthScale, heightScale);
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, 
                                      self.imageView.frame.origin.y, 
                                      self.imageView.frame.size.width / compressScale, 
                                      self.imageView.frame.size.height / compressScale);

    self.imageView.center = self.imageParentView.center;
    self.scrollView.contentSize = self.scrollView.frame.size;
    self.scrollView.minimumZoomScale = fminf(1.0, compressScale);
    self.scrollView.maximumZoomScale = fmaxf(1.0, compressScale);

    self.indicator.hidden = YES;
    [self.indicator stopAnimating];

    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    
    [self resetHideNavBarTimer];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageParentView;
}

- (void)viewDidUnload {
    [self setImageParentView:nil];
    [super viewDidUnload];
}
@end
