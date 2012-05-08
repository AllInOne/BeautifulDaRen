//
//  MyShowViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakePhotoViewController.h"

@interface MyShowViewController : UIViewController <TakePhotoControllerDelegate>

@property (nonatomic, retain) TakePhotoViewController *takePhotoViewController;

@end
