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
#define K_BSDK_CATEGORY_SNS @"sns"

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

#define K_BSDK_ACTION_GETCLASSLIST @"GetClassList"
#define K_BSDK_ACTION_GETCLASSBYID @"GetClassById"

#define K_BSDK_ACTION_FOLLOW @"PayAttention"
#define K_BSDK_ACTION_UNFOLLOW @"CancelAttention"
#define K_BSDK_ACTION_GETFOLLOWLIST @"GetAttentionList"

#define K_BSDK_ACTION_GETFANLIST @"GetFansList"
#define K_BSDK_ACTION_SENDPRIVATEMSG @"SendPrivateMsg"
#define K_BSDK_ACTION_GETSENDEDPRIVATEMSG @"GetSendedPrivateMsg"

#define K_BSDK_ACTION_SENDCOMMENT @"SendComment"

#define K_BSDK_ACTION_GETCOMMENTLIST @"GetCommentList"

#define K_BSDK_PAGEINDEX @"Page"
#define K_BSDK_PAGESIZE @"PageSize"

#define K_BSDK_FOLLOWUSERNAME @"AttentionUserName"
#define K_BSDK_USERNAME @"UserName"
#define K_BSDK_USERCOUNT @"UserCount"
#define K_BSDK_FANSUSERNAME @"FansUserName"

#define K_BSDK_PASSWORD @"PassWord"

#define K_BSDK_REPASSWORD @"RePassWord"

#define K_BSDK_CHECKCODE @"checkCode"

#define K_BSDK_EMAIL @"Email"

#define K_BSDK_City @"City"

#define K_BSDK_SHOPMERCHANT @"ShopMerchant"
#define K_BSDK_BRANDSERVICE @"BrandService"
#define K_BSDK_PRICE @"Price"
#define K_BSDK_CONTENT @"Content"
#define K_BSDK_PICTURE @"Pic"
#define K_BSDK_LATITUDE @"PosX"
#define K_BSDK_LONGITUDE @"PosY"

#define K_BSDK_CREATETIME @"CreateTime"

#define K_BSDK_KEYWORD @"KeyWords"

#define K_BSDK_UID @"id"

#define K_BSDK_BLOGUID @"BlogId"

#define K_BSDK_CLASSLIST @"ClassList"

#define K_BSDK_CLASSNAME @"classname"

#define K_BSDK_RESPONSE_STATUS @"status"
#define K_BSDK_RESPONSE_STATUS_OK @"y"
#define K_BSDK_RESPONSE_STATUS_FAILED @"n"

#define K_BSDK_RESPONSE_MESSAGE @"msg"

#define K_BSDK_RESPONSE_BLOGLIST @"BlogList"
#define K_BSDK_RESPONSE_USERLIST @"UserList"

#define K_BSDK_IS_RESPONSE_OK(res) ([[res objectForKey:K_BSDK_RESPONSE_STATUS] isEqual:K_BSDK_RESPONSE_STATUS_OK])
#define K_BSDK_GET_RESPONSE_MESSAGE(res) ([res objectForKey:K_BSDK_RESPONSE_MESSAGE])

#endif
