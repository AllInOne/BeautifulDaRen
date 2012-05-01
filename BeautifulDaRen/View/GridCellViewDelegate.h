//
//  GridCellViewDelegate.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GridCellView;

/**
 * @brief Protocol to pass the user interaction events from GridCellView.
 *
 * All the user interaction events must be handled via this protocol.
 */
@protocol GridCellViewDelegate <NSObject>

/**
 * @brief Event method launched when the GridCellView was pressed.
 *
 * This method will be called on the delegate each time the GridCellView is pressed.
 * It will not be called if there is a long press or any other gesture detected.
 * It is up to the delegate to interprete and handle the event. The method only indicates
 * the event, it is not taking the internal state of the GridCell in the account.
 * 
 * This method is required.
 *
 * @param[in] sender GridCellView object that was pressed.
 */
- (void)didPressGridCell:(GridCellView *)sender;

@optional
// TODO
@end
