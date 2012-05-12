/**************************************************************************************************************
 *
 * Copyright (C) 2011-2012 Myriad Group AG. All Rights Reserved.
 *
 * File     :   $Id: //depot/ds/projects/MSSS/pivot/apps/Pivot/Pivot/Controller/DataManager.h#104 $
 *
 ***********************************************************************/

/** \addtogroup CONTROLLER
 *  @{
 */
#import <AudioToolbox/AudioToolbox.h>

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "UpdateViewControllerProtocol.h"
#import "DataManagerCallbacks.h"
#import "DataConstants.h"

/**
 @brief Main query and data gathering point for the application. Abstracts access to database and other sdk/server access.
 */
@interface DataManager : NSObject{
@private
    id<UpdateViewControllerProtocol> delegate;

    NSError *errorDataRetrieval; // SDK failed
}

/**
 Reference to the view controller so that it can reflect the data change.
 */
@property (nonatomic, assign) id<UpdateViewControllerProtocol> delegate;

/**
 @brief Data Manager instance
 
 @return shared instance
 */
+ (DataManager*) sharedManager;

/**
 @brief Call to trigger the necessary mechanisms in low memory scenario
 */
- (void)handleLowMemory;

/**
 @brief save local user stored data in the database.
 
 @param finishBlock Code to execute when the process was finished
 */
- (void)saveLocalUserWithFinishBlock:(ProcessFinishBlock)finishBlock;

@end
/** @} */
