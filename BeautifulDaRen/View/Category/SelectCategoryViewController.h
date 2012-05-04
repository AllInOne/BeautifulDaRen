//
//  SelectCategoryViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCategoryProtocol <NSObject>
- (void)onCategorySelected:(NSString*)category;
@end

@interface SelectCategoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) IBOutlet UITableView * categoryListTableView;
@property (nonatomic, assign) id<SelectCategoryProtocol> delegate;
@end
