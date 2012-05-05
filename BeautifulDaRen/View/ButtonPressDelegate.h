//
//  ButtonPressDelegate.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/4/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ButtonPressDelegate <NSObject>

- (void) didButtonPressed:(UIButton*)button  inView:(UIView *) view;

@end
