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

#define ADS_CELL_HEIGHT             (67)
#define USER_INFOR_CELL_HEIGHT      (80)

#define CONTENT_MARGIN              (5.0)


#define NAVIGATION_LEFT_LOGO_WIDTH (114.0)
#define NAVIGATION_LEFT_LOGO_HEIGHT (29.0)

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

#define APPDELEGATE ((AppDelegate*)([UIApplication sharedApplication].delegate))

#define APPDELEGATE_ROOTVIEW_CONTROLLER ((AppDelegate*)([UIApplication sharedApplication].delegate)).rootViewController

#define SYSTEM_VERSION_LESS_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#endif
