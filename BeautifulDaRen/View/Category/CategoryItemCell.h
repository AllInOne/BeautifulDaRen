//
//  CategoryItemCell.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonScrollView.h"

@interface CategoryItemCell : UITableViewCell <CommonScrollViewProtocol>

@property (nonatomic, retain) CommonScrollView * categoryScrollItem;
@property (nonatomic, retain) UILabel * categoryTitle;

/**
 @brief Init the Category item with data.
 
 @param dataDict the data of the category, it has the keys below:
                 KEY_CATEGORY_TITLE
                 KEY_CATEGORY_ITEMS

 @return YES if success, otherwise NO.
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andData: (NSDictionary *)dataDict;

@end
