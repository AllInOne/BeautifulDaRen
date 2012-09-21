//
//  FriendsViewController.h
//  Pivot
//
//  Created by Krzysztof Siejkowski on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

/** \addtogroup VIEW
 *  @{
 */

#import <UIKit/UIKit.h>
#import "FriendsSelectionViewControllerDelegate.h"

@interface FriendsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>

@property(assign, nonatomic) id<FriendsSelectionViewControllerDelegate> delegate;
@property(retain,nonatomic) IBOutlet UITableView *tableView;
@property(retain,nonatomic) NSMutableDictionary *sections;
@property(retain,nonatomic) NSArray *sectionsArray;
@property(retain,nonatomic) NSMutableArray *filteredContacts;
@property(retain,nonatomic) UISearchDisplayController *searchController;

@property (nonatomic, retain) NSArray * friendsList;
@end

/** @} */
