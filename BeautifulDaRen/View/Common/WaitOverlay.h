//
//  WaitOverlay.h
//  Pivot
//
//  Created by Miguel Angel Quinones on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/** \addtogroup VIEW
 *  @{
 */

#import <UIKit/UIKit.h>

@interface WaitOverlay : UIView {
 @private
    UIActivityIndicatorView* _activityView;
}

- (void)showOverlay;
- (void)hideOverlay;

@end

/** @}*/
