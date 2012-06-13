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

@interface SelectCategoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) IBOutlet UITableView * categoryListTableView;
@property (nonatomic, assign) id<SelectCategoryProtocol> delegate;
@property (nonatomic, retain) NSArray * categoryListData;

@property (nonatomic, retain) IBOutlet UILabel * category1;
@property (nonatomic, retain) IBOutlet UILabel * category2;
@property (nonatomic, retain) IBOutlet UILabel * category3;
@property (nonatomic, retain) IBOutlet UILabel * category4;
@property (nonatomic, retain) IBOutlet UILabel * category5;
@property (nonatomic, retain) IBOutlet UILabel * category6;
@property (nonatomic, retain) IBOutlet UILabel * category7;
@property (nonatomic, retain) IBOutlet UILabel * category8;

-(IBAction)onCheckBoxPressed:(UIButton*)sender;
@end
