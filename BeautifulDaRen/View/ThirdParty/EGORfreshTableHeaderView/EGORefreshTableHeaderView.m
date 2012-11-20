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
 * File     :   $Id: //depot/ds/projects/MSSS/pivot_1.x/apps/Pivot/Pivot/View/ThirdParty/EGORefreshTableHeaderView/EGORefreshTableHeaderView.m#1 $
 * Purpose  :   TBD
 ***********************************************************************/

#import "EGORefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:160.0/255.0 green:173.0/255.0 blue:182.0/255.0 alpha:1.0]

@implementation EGORefreshTableHeaderView

@synthesize state=_state;
@synthesize bottomBorderThickness;
@synthesize bottomBorderColor=_bottomBorderColor;

static NSDateFormatter *refreshFormatter;

+ (void)initialize
{
  refreshFormatter = [[NSDateFormatter alloc] init];
  [refreshFormatter setDateStyle:NSDateFormatterShortStyle];
  [refreshFormatter setTimeStyle:NSDateFormatterShortStyle];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
        lastUpdatedLabel.textColor = TEXT_COLOR;
        lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        lastUpdatedLabel.backgroundColor = [UIColor clearColor];
        lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:lastUpdatedLabel];
        [lastUpdatedLabel release];

        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 43.0f, self.frame.size.width, 20.0f)];
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        statusLabel.textColor = TEXT_COLOR;
        statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = UITextAlignmentCenter;
        [self setState:EGOOPullRefreshNormal];
        [self addSubview:statusLabel];
        [statusLabel release];

        arrowImage = [[CALayer alloc] init];
        arrowImage.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
        arrowImage.contentsGravity = kCAGravityResizeAspect;
        arrowImage.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
        [[self layer] addSublayer:arrowImage];
        [arrowImage release];

        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(25.0f, frame.size.height - 45.0f, 20.0f, 20.0f);
        activityView.hidesWhenStopped = YES;
        [self addSubview:activityView];
        [activityView release];
    }

    return self;
}

// Draw a bottom border effect.
- (void)drawRect:(CGRect)rect{
	if (self.bottomBorderThickness == 0.0f) return;
	CGFloat strokeOffset = self.bottomBorderThickness / 2.0f;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawPath(context,  kCGPathFillStroke);
  UIColor *strokeColor = (self.bottomBorderColor)? self.bottomBorderColor : BORDER_COLOR;
	[strokeColor setStroke];
	CGContextSetLineWidth(context, self.bottomBorderThickness);
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0.0f, self.bounds.size.height - strokeOffset);
	CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - strokeOffset);
	CGContextStrokePath(context);
}

- (void)setLastRefreshDate:(NSDate*)date
{
  if (!date) {
    [lastUpdatedLabel setText:NSLocalizedString(@"Never Updated", @"No Last Update Date text")];
    return;
  }

	lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [refreshFormatter stringFromDate:date]];
}

- (void)setCurrentDate {
	lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [refreshFormatter stringFromDate:[NSDate date]]];
}

- (void)setState:(EGOPullRefreshState)aState{
	switch (aState) {
      case EGOOPullRefreshPulling: {
          statusLabel.text = @"松开可以刷新...";
          [CATransaction begin];
          [CATransaction setAnimationDuration:.18];
          arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
          [CATransaction commit];

          break;
      }
      case EGOOPullRefreshNormal: {
          if (_state == EGOOPullRefreshPulling) {
              [CATransaction begin];
              [CATransaction setAnimationDuration:.18];
              arrowImage.transform = CATransform3DIdentity;
              [CATransaction commit];
          }

          statusLabel.text = @"下拉可以刷新...";
          [activityView stopAnimating];
          [CATransaction begin];
          [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
          arrowImage.hidden = NO;
          arrowImage.transform = CATransform3DIdentity;
          [CATransaction commit];

          break;
      }
      case EGOOPullRefreshLoading: {
          statusLabel.text = @"亲,正在加载,请等一下哦...";
          [activityView startAnimating];
          [CATransaction begin];
          [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
          arrowImage.hidden = YES;
          [CATransaction commit];

          break;
      }
      case EGOOPullRefreshUpToDate: {
          statusLabel.text = @"Up-to-date.";
          [activityView stopAnimating];
          [CATransaction begin];
          [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
          arrowImage.hidden = YES;
          [CATransaction commit];

          break;
      }
      default:
          break;
	}

	_state = aState;
}

- (void)dealloc {
    [_bottomBorderColor release];
    activityView = nil;
    statusLabel = nil;
    arrowImage = nil;
    lastUpdatedLabel = nil;

    [super dealloc];
}

@end
