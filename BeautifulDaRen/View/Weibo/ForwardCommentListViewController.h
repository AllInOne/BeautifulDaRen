//
//  ForwardCommentListViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboForwardCommentViewController.h"

@interface ForwardCommentListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ForwardCommentViewControllerProtocol, UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UITableView * forwardOrCommentListTableView;
@property (nonatomic, retain) IBOutlet UIView * footView;
@property (nonatomic, retain) IBOutlet UIButton * footViewButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * footViewActivityIndicator;

@property (nonatomic, retain) NSString * relatedBlogId;
@end
