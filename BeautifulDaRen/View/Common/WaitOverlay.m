//
//  WaitOverlay.m
//  Pivot
//
//  Created by Miguel Angel Quinones on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/** \addtogroup VIEW
 *  @{
 */

#import "WaitOverlay.h"
#import "ViewConstants.h"

@implementation WaitOverlay

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_activityView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityView startAnimating];
        _activityView.autoresizingMask = UIViewAutoresizingNone;
        self.autoresizingMask = UIViewAutoresizingNone;
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(showOverlay)
                                                     name:K_NOTIFICATION_SHOWWAITOVERLAY 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(hideOverlay)
                                                     name:K_NOTIFICATION_HIDEWAITOVERLAY 
                                                   object:nil];
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0.5];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _activityView.center = self.center;
    [self addSubview:_activityView];
}

- (void)showOverlay { 
    UIWindow* appWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    appWindow.userInteractionEnabled = NO;
    [appWindow addSubview:self];
}

- (void)hideOverlay {
    UIWindow* appWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    appWindow.userInteractionEnabled = YES;
    [self removeFromSuperview];
}

@end

/** @}*/