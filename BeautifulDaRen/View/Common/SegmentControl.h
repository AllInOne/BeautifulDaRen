//
//  SegmentControl.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/30/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentDelegate.h"

@interface SegmentControl : UIView

@property (retain, nonatomic) id<SegmentDelegate> delegate;

- (id) initWithFrame:(CGRect)frame leftText:(NSString *)leftText rightText:(NSString*)rightText selectedIndex:(NSInteger)index;

@end
