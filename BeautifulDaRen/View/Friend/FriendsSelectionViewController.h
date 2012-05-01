//
//  FriendsSelectionViewController.h
//  Pivot
//
//  Created by Krzysztof Siejkowski on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

/** \addtogroup VIEW
 *  @{
 */

#import <UIKit/UIKit.h>
#include "FriendsSelectionViewControllerDelegate.h"

@interface FriendsSelectionViewController : UIViewController <FriendsSelectionViewControllerDelegate>

@property(retain, nonatomic) NSMutableArray *selectedContacts;
@property(assign, nonatomic) id<FriendsSelectionViewControllerDelegate> delegate;
- (void)preloadView;

@end

/** @} */