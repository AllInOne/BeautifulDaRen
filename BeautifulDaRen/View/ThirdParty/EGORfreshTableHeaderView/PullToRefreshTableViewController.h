/***********************************************************************
 *
 * Created by Jesse Collis on 1/07/10.
 * Copyright 2010 JC Multimedia Design. All Rights Reserved.
 * Refrence from: https://github.com/enormego/EGOTableViewPullRefresh
 *
 * File     :   $Id: //depot/ds/projects/MSSS/pivot_1.x/apps/Pivot/Pivot/View/ThirdParty/EGORefreshTableHeaderView/PullToRefreshTableViewController.h#1 $
 * Purpose  :   TBD
 ***********************************************************************/

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface PullToRefreshTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	EGORefreshTableHeaderView *refreshHeaderView;
}

@property (nonatomic, assign) id aggregatedDelegate;

// Usage:
// In derived class, please override the didStartRefreshing
// method to fresh data. And call super class method
// stopRefreshing when you finish to restore the UI.
- (void)didStartRefreshing;
- (void)stopRefreshAnimation;

@end
