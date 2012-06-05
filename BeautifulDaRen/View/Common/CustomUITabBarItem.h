//
//  CustomUITabBarItem.h
//  BeautifulDaRen
//
//  Created by jerry.li on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomUITabBarItem : UITabBarItem {  
    UIImage *customHighlightedImage;  
    UIImage *customNormalImage;  
}  

@property (nonatomic, retain) UIImage *customHighlightedImage;  
@property (nonatomic, retain) UIImage *customNormalImage;  

- (id)initWithTitle:(NSString *)title 
        normalImage:(UIImage *)normalImage 
   highlightedImage:(UIImage *)highlightedImage 
                tag:(NSInteger)tag;

@end
