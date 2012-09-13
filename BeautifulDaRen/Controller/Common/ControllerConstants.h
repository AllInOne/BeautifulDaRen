//
//  ControllerConstants.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    LOGIN_STATUS_SUCCESS,
    LOGIN_STATUS_ALREADY_LOGIN,
    LOGIN_STATUS_USER_CANCEL,
    LOGIN_STATUS_FAILED,
    LOGIN_STATUS_SERVER_BASE = 100
}LOGIN_STATUS;

typedef enum
{
    AIO_STATUS_SUCCESS,
    AIO_STATUS_OUT_OF_MEMORY,
    AIO_STATUS_BAD_STATE,
    AIO_STATUS_INVALID_PARAMETOR,
    AIO_STATUS_NOT_SIGNED_IN,
    AIO_STATUS_NOT_FOUND
}AIO_STATUS;

typedef void(^callBackBlock)(void);
typedef void(^loginDoneBlock)(LOGIN_STATUS status);
typedef void(^processDoneBlock)(AIO_STATUS status);
typedef void(^processDoneWithDictBlock)(AIO_STATUS status, NSDictionary * data);
typedef void(^processDoneWithArrayBlock)(AIO_STATUS status, NSArray * data);

@protocol RequestProtocol <NSObject>
@required
- (void)start;
- (void)doneWithStatus: (AIO_STATUS)status andData: (NSDictionary*)data;
@end