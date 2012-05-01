//
//  FriendsSelectionViewControllerDelegate.h
//  Pivot
//
//  Created by Krzysztof Siejkowski on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

/** \addtogroup VIEW
 *  @{
 */

#import <Foundation/Foundation.h>

@protocol FriendsSelectionViewControllerDelegate <NSObject>

@optional
- (void)didFinishContactSelectionWithContacts:(NSString *)friendId;
- (void)didCancelContactSelection;

@end

/** @} */