/***********************************************************************
 *
 * Created by Jesse Collis on 1/07/10.
 * Copyright 2010 JC Multimedia Design. All Rights Reserved.
 * Refrence from: https://github.com/enormego/EGOTableViewPullRefresh
 *
 * File     :   $Id: //depot/ds/projects/MSSS/pivot_1.x/apps/Pivot/Pivot/View/ThirdParty/EGORefreshTableHeaderView/PullToRefreshTableViewController.m#1 $
 * Purpose  :   TBD
 ***********************************************************************/

#import "PullToRefreshTableViewController.h"
#import "EGORefreshTableHeaderView.h"

@implementation PullToRefreshTableViewController

@synthesize aggregatedDelegate=_aggregatedDelegate;

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    if (refreshHeaderView == nil) {
        refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height)];
        refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        refreshHeaderView.bottomBorderThickness = 1.0;
        [self.tableView addSubview:refreshHeaderView];
        self.tableView.showsVerticalScrollIndicator = YES;
        [refreshHeaderView release];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {	
    if (scrollView.isDragging) {
        if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
            [refreshHeaderView setState:EGOOPullRefreshNormal];
        } else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
            [refreshHeaderView setState:EGOOPullRefreshPulling];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= - 65.0f && refreshHeaderView.state == EGOOPullRefreshPulling) {
        if (self.aggregatedDelegate) {
            [self.aggregatedDelegate didStartRefreshing];
        }
        else {
            [self didStartRefreshing];
        }
        
        [refreshHeaderView setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark refreshHeaderView Methods
- (void)didStartRefreshing {
}

- (void)stopRefreshAnimation {
    if(refreshHeaderView.state > EGOOPullRefreshNormal) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        [self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [UIView commitAnimations];

        if(refreshHeaderView.state == EGOOPullRefreshLoading) {
            [refreshHeaderView setCurrentDate];
        }

        [refreshHeaderView setState:EGOOPullRefreshNormal];
    }
}

- (void)dealloc {
    [refreshHeaderView release];
    refreshHeaderView=nil;

    [super dealloc];
}

@end

