//
//  CustomUITabBarItem.m
//  BeautifulDaRen
//
//  Created by jerry.li on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomUITabBarItem.h"

@implementation CustomUITabBarItem

@synthesize customHighlightedImage;
@synthesize customNormalImage;

- (id)initWithTitle:(NSString *)title
        normalImage:(UIImage *)normalImage
   highlightedImage:(UIImage *)highlightedImage
                tag:(NSInteger)tag{
    self = [super init];
    if (self) {
        [self initWithTitle:title
                      image:nil
                        tag:tag];
        [self setCustomNormalImage:normalImage];
        [self setCustomHighlightedImage:highlightedImage];
    }

    return self;
}

- (void) dealloc
{
    [customHighlightedImage release];
    customHighlightedImage=nil;
    [customNormalImage release];
    customNormalImage=nil;
    [super dealloc];
}

-(UIImage *) selectedImage
{
    return self.customHighlightedImage;
}

-(UIImage *) unselectedImage
{
    return self.customNormalImage;
}

@end
