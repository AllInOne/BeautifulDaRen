//
//  SelectCategoryViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCategoryProtocol <NSObject>
- (void)onCategorySelected:(NSArray*)categories;
@end

@interface SelectCategoryViewController : UIViewController
@property (nonatomic, assign) id<SelectCategoryProtocol> delegate;
@property (nonatomic, retain) NSArray * categoryListData;

@property (nonatomic, retain) IBOutlet UIScrollView * contentScrollView;

-(IBAction)onCheckBoxPressed:(UIButton*)sender;
@end
