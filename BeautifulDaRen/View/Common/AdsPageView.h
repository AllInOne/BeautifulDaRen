//
//  AdsPageView.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

@interface AdsPageView : UIViewController

// Use two images for animations
@property (nonatomic, retain) IBOutlet UIImageView * firstAdsImageView;
@property (nonatomic, retain) IBOutlet UIImageView * secondsAdsImageView;
@property (nonatomic, retain) IBOutlet UIPageControl * adsPageController;

@property (nonatomic, retain) NSMutableArray* pages;
@property (nonatomic, retain) UIView *pageView;
@property (nonatomic, assign) int previousPage;


-(void)transitionPage:(int)from toPage:(int)to;
-(CATransition *) getAnimation:(NSString *) direction;

@end
