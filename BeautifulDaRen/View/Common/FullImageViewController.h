/***********************************************************************
 *
 * Copyright (C) 2001-2012 Myriad Group AG. All Rights Reserved.
 *
 * File     :   $Id: //depot/ds/projects/MSSS/pivot/apps/Pivot/Pivot/View/FullImageViewController.h#1 $
 * Purpose  :   TBD
 ***********************************************************************/

#import <UIKit/UIKit.h>

@interface FullImageViewController : UIViewController<UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIView *imageParentView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (retain, nonatomic) IBOutlet UILabel *indicatorLabel;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;
@property (nonatomic, retain) UITapGestureRecognizer *singleTap;
@property (nonatomic, retain) UITapGestureRecognizer *doubleTap;
@property (nonatomic) BOOL frozenSingleTap;
@property (nonatomic, retain) NSTimer* timerHideNavBar;
@property (nonatomic, retain) UIImage * imageData;

/**
 * @brief Download and display the image with original size.
 *
 * @param parentNav UINavigationController* that would present
 *          the image modally.
 * @param contactId NSString* be used to download the image.
 * 
 * @return nil
 */
+ (void)showImage:(UIImage* )image inNavigationController:(UINavigationController* )parentNav;

@end
