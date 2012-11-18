/***********************************************************************
 *
 * Created by Devin Doty on 10/14/09October14.
 * Copyright 2009 enormego. All rights reserved.
 * Refrence from: https://github.com/enormego/EGOTableViewPullRefresh
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * File     :   $Id: //depot/ds/projects/MSSS/pivot_1.x/apps/Pivot/Pivot/View/ThirdParty/EGORefreshTableHeaderView/EGORefreshTableHeaderView.h#1 $
 * Purpose  :   TBD
 ***********************************************************************/

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/**
 Different Pull Status.
 */
typedef enum {
	EGOOPullRefreshNormal = 0, // Initial status with a downward arrow and "Release to refresh..." text.
	EGOOPullRefreshPulling,    // Status of prepare to refresh with a upward arrow and "Pull down to refresh..." text.
	EGOOPullRefreshLoading,    // Status of refreshing with an activity indicator animation and "Loading..." text.
	EGOOPullRefreshUpToDate,   // Status of finishing with ""Up-to-date." text.
}EGOPullRefreshState;

@interface EGORefreshTableHeaderView : UIView {	
	UILabel *lastUpdatedLabel;
	UILabel *statusLabel;
	CALayer *arrowImage;
	UIActivityIndicatorView *activityView;
}

@property(nonatomic,assign) EGOPullRefreshState state;
@property(nonatomic,retain) UIColor *bottomBorderColor;
@property(nonatomic,assign) CGFloat bottomBorderThickness;

- (void)setLastRefreshDate:(NSDate*)date;
- (void)setCurrentDate;
- (void)setState:(EGOPullRefreshState)aState;

@end
