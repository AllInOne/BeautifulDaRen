//
//  RadioButtonDelegate.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/10/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RadioButtonDelegate <NSObject>
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId;
@end
