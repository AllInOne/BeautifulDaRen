//
//  SegmentControl.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/30/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SegmentControl : UIView

- (id) initWithFrame:(CGRect)frame leftText:(NSString *)leftText rightText:(NSString*)rightText selectedIndex:(NSInteger)index;
@property (retain, nonatomic) IBOutlet UIButton * firstButton;
@property (retain, nonatomic) IBOutlet UIButton * secondButton;
@end
