//
//  BSDKDefines.h
//  BeautifulDaRen
//
//  Created by jerry.li on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef BeautifulDaRen_BSDKDefines_h
#define BeautifulDaRen_BSDKDefines_h

#define K_BSDK_CATEGORY @"cat"
#define K_BSDK_CATEGORY_USER @"user"
#define K_BSDK_CATEGORY_BLOG @"blog"

#define K_BSDK_ACTION @"action"
#define K_BSDK_ACTION_ADD @"Add"
#define K_BSDK_ACTION_LOGIN @"LoginCheck"
#define K_BSDK_ACTION_GETINFO @"GetInfo"
#define K_BSDK_ACTION_CHANGEPASSWORD @"ChangePassWord"
#define K_BSDK_ACTION_SEARCH @"Search"
#define K_BSDK_ACTION_GETLIST @"Getlist"
#define K_BSDK_ACTION_VERIFY @"Verify"
#define K_BSDK_ACTION_DELETE @"Del"
#define K_BSDK_ACTION_PERIPHERAL @"Peripheral"

#define K_BSDK_USERNAME @"UserName"

#define K_BSDK_PASSWORD @"PassWord"

#define K_BSDK_REPASSWORD @"RePassWord"

#define K_BSDK_CHECKCODE @"checkCode"

#define K_BSDK_EMAIL @"Email"

#define K_BSDK_City @"City"


#define K_BSDK_RESPONSE_STATUS @"status"
#define K_BSDK_RESPONSE_STATUS_OK @"y"
#define K_BSDK_RESPONSE_STATUS_FAILED @"n"

#define K_BSDK_RESPONSE_MESSAGE @"msg"

#define K_BSDK_IS_RESPONSE_OK(res) ([[res objectForKey:K_BSDK_RESPONSE_STATUS] isEqual:K_BSDK_RESPONSE_STATUS_OK])
#define K_BSDK_GET_RESPONSE_MESSAGE(res) ([res objectForKey:K_BSDK_RESPONSE_MESSAGE])

#endif
