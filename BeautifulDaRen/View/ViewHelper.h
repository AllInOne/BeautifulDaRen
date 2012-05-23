//
//  ViewHelper.h
//  BeautifulDaRen
//
//  Created by gang liu on 4/26/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewHelper : NSObject

+(void)showSimpleMessage:(NSString*)message withTitle:(NSString*)title withButtonText:(NSString*)buttonText;

+(UITableViewCell*) getLoginWithExtenalViewCellInTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getWidthOfText:(NSString*)text ByFontSize:(CGFloat)fontSize;

+ (CGFloat)getHeightOfText: (NSString*)text ByFontSize:(CGFloat)fontSize contentWidth:(CGFloat)width;

+ (UIBarButtonItem*)getBackBarItemOfTarget:(id)target action:(SEL)action title:(NSString*)title;

+ (UIBarButtonItem*)getBarItemOfTarget:(id)target action:(SEL)action title:(NSString*)title;

+ (UIBarButtonItem*)getLeftBarItemOfImageName:(NSString*)image rectSize:(CGRect)rectSize;

+ (UIBarButtonItem*)getRightBarItemOfTarget1:(id)target1 action1:(SEL)action1 title1:(NSString*)title1 target2:(id)target2 action2:(SEL)action2 title2:(NSString*)title2;

+ (UIBarButtonItem*)getToolBarItemOfImageName:(NSString*)image target:(id)target action:(SEL)action;

+ (UIImage*) getBubbleImageWithWidth:(NSInteger)width height:(NSInteger)height;

+ (UIBarButtonItem*) getCameraBarItem;
@end
