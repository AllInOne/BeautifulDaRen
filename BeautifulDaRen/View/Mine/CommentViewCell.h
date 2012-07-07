//
//  CommentViewCell.h
//  BeautifulDaRen
//
//  Created by jerry.li on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView * authorAvatar;
@property (nonatomic, retain) IBOutlet UIImageView * authorVMark;
@property (nonatomic, retain) IBOutlet UILabel * authorName;
@property (nonatomic, retain) IBOutlet UILabel * timestamp;
@property (nonatomic, retain) IBOutlet UILabel * commentContent;

@property (nonatomic, retain) IBOutlet UIView * originalWeiboView;
@property (nonatomic, retain) IBOutlet UIView * originalWeiboBgView;
@property (nonatomic, retain) IBOutlet UIImageView * originalAuthorAvatar;
@property (nonatomic, retain) IBOutlet UIImageView * originalAuthorVMark;
@property (nonatomic, retain) IBOutlet UILabel * originalAuthorName;
@property (nonatomic, retain) IBOutlet UIImageView * originalImage;
@property (nonatomic, retain) IBOutlet UILabel * originalBrand;
@property (nonatomic, retain) IBOutlet UILabel * originalMerchant;
@property (nonatomic, retain) IBOutlet UILabel * originalContent;
@property (nonatomic, retain) IBOutlet UIButton * originalPriceButton;

- (void)setData:(NSDictionary*)data;
- (CGFloat)getCellHeightByData:(NSDictionary*)data;

@end
