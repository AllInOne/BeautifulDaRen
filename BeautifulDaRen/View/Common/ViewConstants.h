//
//  Header.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#ifndef BeautifulDaRen_ViewConstants_Header_h
#define BeautifulDaRen_ViewConstants_Header_h

#define ADS_CELL_WIDTH              (320)
#define ADS_CELL_HEIGHT             (67)
#define ADS_PAGE_CONTROLLER_DOT_WIDTH             (5)

#define USER_INFOR_CELL_HEIGHT      (80)

#define TEXT_VIEW_MAX_CHARACTOR_NUMBER    140

#define CONTENT_MARGIN              (5.0)


#define NAVIGATION_LEFT_LOGO_WIDTH (90.0)
#define NAVIGATION_LEFT_LOGO_HEIGHT (27.0)

#define SCROLL_ITEM_MARGIN      (11.0)
#define SCROLL_ITEM_WIDTH       (66.0)
#define SCROLL_ITEM_HEIGHT      (66.0)

#define CATEGORY_TITLE_FONT_HEIGHT  (14.0f)
#define CATEGORY_TITLE_MARGIN  (14.0f)
#define CATEGORY_ITEM_HEIGHT  (CATEGORY_TITLE_FONT_HEIGHT + CATEGORY_TITLE_MARGIN + SCROLL_ITEM_HEIGHT)

#define KEY_CATEGORY_TITLE      @"CATEGORY_TITLE"
#define KEY_CATEGORY_ITEMS      @"CATEGORY_ITEMS"

#define SCREEN_WIDTH                ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)

#define VERTICAL_SCROLL_VIEW_BOUNCE_SIZE (50.0)

#define TOOL_BAR_HEIGHT             (44.0)
#define NAVIGATION_BAR_HEIGHT       (44.0)
#define TAB_BAR_HEIGHT              (50.0)
#define STATUS_BAR_HEIGHT           (20.0)
#define TEXT_VIEW_MARGE_HEIGHT      (20.0)
// The height of the screen user could use. (Whole screen height minus navigation bar and tab bar)
#define USER_WINDOW_HEIGHT          (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT)

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)


#define APPDELEGATE ((AppDelegate*)([UIApplication sharedApplication].delegate))

#define APPDELEGATE_ROOTVIEW_CONTROLLER ((AppDelegate*)([UIApplication sharedApplication].delegate)).rootViewController

#define SYSTEM_VERSION_LESS_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define K_NOTIFICATION_SHOWWAITOVERLAY @"K_NOTIFICATION_SHOWWAITOVERLAY"
#define K_NOTIFICATION_HIDEWAITOVERLAY @"K_NOTIFICATION_HIDEWAITOVERLAY"
#define K_NOTIFICATION_LOGIN_SUCCESS @"K_NOTIFICATION_LOGIN_SUCCESS"
#define K_NOTIFICATION_LOGINOUT_SUCCESS @"K_NOTIFICATION_LOGINOUT_SUCCESS"
#define K_NOTIFICATION_SHOULD_LOGIN @"K_NOTIFICATION_SHOULD_LOGIN"

#define USERDEFAULT_LOCAL_ACCOUNT_INFO @"USERDEFAULT_LOCAL_ACCOUNT_INFO"
#define USERDEFAULT_IS_AUTO_LOGIN @"USERDEFAULT_IS_AUTO_LOGIN"
#define USERDEFAULT_AUTO_LOGIN_ACCOUNT_NAME @"USERDEFAULT_AUTO_LOGIN_ACCOUNT_NAME"
#define USERDEFAULT_AUTO_LOGIN_ACCOUNT_PASSWORD @"USERDEFAULT_AUTO_LOGIN_ACCOUNT_PASSWORD"
#define USERDEFAULT_CATEGORY @"USERDEFAULT_CATEGORY"

#define USERDEFAULT_SINA_USER_UID @"USERDEFAULT_SINA_USER_UID"


// TODO: remove them and use defines in BSDKDefines.h
#define KEY_ACCOUNT_USER_NAME           @"UserName"
#define KEY_ACCOUNT_EMAIL               @"Email"
#define KEY_ACCOUNT_LEVEL               @"Levels"
#define KEY_ACCOUNT_ID                  @"id"
#define KEY_ACCOUNT_USER_ID             @"UserId"
#define KEY_ACCOUNT_POINT               @"Points"
#define KEY_ACCOUNT_CITY                @"City"
#define KEY_ACCOUNT_PHONE               @"Tel"
#define KEY_ACCOUNT_ADDRESS             @"Address"
#define KEY_ACCOUNT_GENDER              @"Sex"
#define KEY_ACCOUNT_INTRO               @"Intro"
#define KEY_ACCOUNT_BLOG_COUNT          @"BlogNum"
#define KEY_ACCOUNT_FAVORITE_COUNT      @"FavNum"
#define KEY_ACCOUNT_AT_COUNT            @"AtNum"
#define KEY_ACCOUNT_COMMENT_COUNT       @"CommentNum"
#define KEY_ACCOUNT_FANS_COUNT          @"FansNum"
#define KEY_ACCOUNT_FOLLOW_COUNT        @"AttentionNum"

#define GET_CURRENT_USER_INFO_BY_KEY(key)  [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:key]

#define TAG_ALERTVIEW_CLEAR_LOCATION    0
#define TAG_ALERTVIEW_BACK_CONFIRM    1

#define ACTIONSHEET_IMAGE_PICKER 1

#define IMAGE_PICKER_CAMERA       NSLocalizedString(@"take_photo", @"take_photo")
#define IMAGE_PICKER_LIBRARY      NSLocalizedString(@"album", @"album")
#define IMAGE_PICKER_DELETE       NSLocalizedString(@"delete_selected_photos", @"delete_selected_photos")

#define ACTIONSHEET_COMMENT_LIST 2

#define COMMENT_LIST_VIEW_PROFILE       NSLocalizedString(@"view_profile", @"view_profile")
#define COMMENT_LIST_POST_COMMNET       NSLocalizedString(@"post_comment", @"post_comment")
#define COMMENT_LIST_REPLY_COMMNET       NSLocalizedString(@"reply_comment", @"reply_comment")

#endif
