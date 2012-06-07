//
//  BSDKDefines.h
//  BeautifulDaRen
//
//  Created by jerry.li on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef BeautifulDaRen_BSDKDefines_h
#define BeautifulDaRen_BSDKDefines_h

//TEST USERNAME TO BE REMOVED!!!!!!!
#define K_BSDK_TEST_USERNAME @"121asdfasdf"

#define K_BSDK_CATEGORY @"cat"
#define K_BSDK_CATEGORY_USER @"user"
#define K_BSDK_CATEGORY_BLOG @"blog"

#define K_BSDK_ACTION @"action"
#define K_BSDK_ACTION_ADD @"Add"
#define K_BSDK_ACTION_LOGIN @"LoginCheck"
#define K_BSDK_ACTION_LOGOUT @"LogOut"
#define K_BSDK_ACTION_GETINFO @"GetInfo"
#define K_BSDK_ACTION_CHANGEPASSWORD @"ChangePassWord"
#define K_BSDK_ACTION_SEARCH @"Search"
#define K_BSDK_ACTION_GETLIST @"GetList"
#define K_BSDK_ACTION_VERIFY @"Verify"
#define K_BSDK_ACTION_DELETE @"Del"
#define K_BSDK_ACTION_PERIPHERAL @"Peripheral"

#define K_BSDK_USERNAME @"UserName"

#define K_BSDK_PASSWORD @"PassWord"

#define K_BSDK_REPASSWORD @"RePassWord"

#define K_BSDK_CHECKCODE @"checkCode"

#define K_BSDK_EMAIL @"Email"

#define K_BSDK_City @"City"

#define K_BSDK_SHOPMERCHANT @"ShopMerchant"
#define K_BSDK_BRANDSERVICE @"BrandService"
#define K_BSDK_PRICE @"Price"
#define K_BSDK_CONTENT @"Content"
#define K_BSDK_PICTURE @"Picture"
#define K_BSDK_LATITUDE @"PosX"
#define K_BSDK_LONGITUDE @"PoxY"

#define K_BSDK_CREATETIME @"CreateTime"

#define K_BSDK_UID @"id"

#define K_BSDK_RESPONSE_STATUS @"status"
#define K_BSDK_RESPONSE_STATUS_OK @"y"
#define K_BSDK_RESPONSE_STATUS_FAILED @"n"

#define K_BSDK_RESPONSE_MESSAGE @"msg"

#define K_BSDK_RESPONSE_BLOGLIST @"BlogList"

#define K_BSDK_IS_RESPONSE_OK(res) ([[res objectForKey:K_BSDK_RESPONSE_STATUS] isEqual:K_BSDK_RESPONSE_STATUS_OK])
#define K_BSDK_GET_RESPONSE_MESSAGE(res) ([res objectForKey:K_BSDK_RESPONSE_MESSAGE])

#endif
