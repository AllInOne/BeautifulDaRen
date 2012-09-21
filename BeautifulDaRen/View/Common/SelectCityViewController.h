//
//  SelectCityViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCityProtocol <NSObject>
- (void)onCitySelected:(NSString*)city;
@end

@interface SelectCityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView * cityListTableView;
@property (retain, nonatomic) id<SelectCityProtocol> delegate;
@end
