//
//  AdsPageView.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

@protocol AdsPageViewProtocol <NSObject>
- (void)onAdsPageViewClosed;
@end

@interface AdsPageView : UIViewController

@property (nonatomic, retain) IBOutlet UIPageControl * adsPageController;
@property (nonatomic, retain) IBOutlet UIButton * adsButton;
@property (nonatomic, assign) id<AdsPageViewProtocol> delegate;

-(IBAction)onAdsPressed:(id)sender;
-(IBAction)onAdsPageClosedPressed:(id)sender;
@end
