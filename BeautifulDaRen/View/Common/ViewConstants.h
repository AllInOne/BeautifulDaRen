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

#define ADS_CELL_HEIGHT             (136)
#define USER_INFOR_CELL_HEIGHT      (80)


#define NAVIGATION_LEFT_LOGO_WIDTH (114.0)
#define NAVIGATION_LEFT_LOGO_HEIGHT (29.0)

#define SCROLL_ITEM_MARGIN      (10.0)
#define SCROLL_ITEM_WIDTH       (60.0)
#define SCROLL_ITEM_HEIGHT      (60.0)

#define CATEGORY_TITLE_FONT_HEIGHT  (14.0f)
#define CATEGORY_TITLE_MARGIN  (14.0f)
#define CATEGORY_ITEM_HEIGHT  (CATEGORY_TITLE_FONT_HEIGHT + CATEGORY_TITLE_MARGIN + SCROLL_ITEM_HEIGHT)

#define KEY_CATEGORY_TITLE      @"CATEGORY_TITLE"
#define KEY_CATEGORY_ITEMS      @"CATEGORY_ITEMS"

#define APPDELEGATE_ROOTVIEW_CONTROLLER ((AppDelegate*)([UIApplication sharedApplication].delegate)).rootViewController

#define SYSTEM_VERSION_LESS_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#endif
