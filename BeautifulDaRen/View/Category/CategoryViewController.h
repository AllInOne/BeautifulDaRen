//
//  FirstViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdsPageView.h"
#import "CategoryContentViewController.h"

@interface CategoryViewController : UIViewController

@property (nonatomic, retain) AdsPageView * adsPageView;
@property (nonatomic, retain) CategoryContentViewController * categoryContentView;
@end
