//
//  ForwardCommentListViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForwardCommentListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView * forwardOrCommentListTableView;

@end
