//
//  CategorySelectViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryItemViewController.h"

@protocol SelectCategoryProtocol <NSObject>
- (void)onCategorySelected:(NSArray*)categories;
@end

@interface CategorySelectViewController : UIViewController<CategoryItemViewControllerProtocol>

@property (nonatomic, assign) id<SelectCategoryProtocol> delegate;
@property (nonatomic, retain) NSArray * categoryListData;

@property (nonatomic, retain) NSString * initialSelectedCategoryId;

@property (nonatomic, retain) IBOutlet UIScrollView * contentScrollView;

@end
