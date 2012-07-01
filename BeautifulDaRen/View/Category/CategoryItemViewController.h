//
//  CategoryItemViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryItemViewControllerProtocol

- (void)onCheckBoxPressed:(UIButton*)sender;
@end

@interface CategoryItemViewController : UIViewController

@property (nonatomic, assign) id<CategoryItemViewControllerProtocol> delegate;

@property (nonatomic, retain)  UIImageView * radioImage;
@property (nonatomic, retain)  UIButton * cellButton;
@property (nonatomic, retain)  UILabel * textLable;

@end
