/***********************************************************************
 *
 * Copyright (C) 2001-2012 Myriad Group AG. All Rights Reserved.
 *
 * File     :   $Id: //depot/ds/projects/MSSS/pivot_1.x/apps/Pivot/Pivot/View/ThirdParty/EGORefreshTableHeaderView/PullToRefreshTableViewControllerDelegate.h#1 $
 * Purpose  :   TBD
 ***********************************************************************/

#ifndef PIVOT_PULLTOREFRESHTABLEVIECONTROLLERDELEGATE_H
#define PIVOT_PULLTOREFRESHTABLEVIECONTROLLERDELEGATE_H

#import <Foundation/Foundation.h>

/**
 * @brief Protocol to make a notification of that Refreshing has started.
 *
 * Note: Only the object which use PullToRefreshTableViewController in aggregated
 * manner needs to implement this protocol.
 */
@protocol PullToRefreshTableViewControllerDelegate <NSObject>

@required
/**
 * @brief Notify the delegate that UI has changed to refreshing status.
 *
 * Note: After the delegate finishes the refreshing, it must call
 * stopRefreshAnimation method of PullToRefreshTableViewController
 * to restore the UI.
 */
- (void)didStartRefreshing;


@end



#endif
