//
//  AtMeViewCell.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/14/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "AtMeViewCell.h"
#import "BSDKDefines.h"
#import "ViewHelper.h"
#import "ViewConstants.h"
#import "UIImageView+WebCache.h"

@implementation AtMeViewCell
@synthesize friendImageView;
@synthesize itemImageView;
@synthesize friendNameLabel;
@synthesize timeLabel;
@synthesize shopNameLabel;
@synthesize brandLabel;
@synthesize costButton;
@synthesize descriptionLabel;
@synthesize vMarkImageView;
@synthesize cancelBuyButton;
@synthesize buyStatusLabel;
@synthesize buyStatusView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary*)data
{
    NSDictionary * userDict = [data objectForKey:K_BSDK_USERINFO];

    friendNameLabel.text = [userDict objectForKey:K_BSDK_USERNAME];
    shopNameLabel.text = [data objectForKey:K_BSDK_SHOPMERCHANT];
    brandLabel.text = [data objectForKey:K_BSDK_BRANDSERVICE];

    NSString * avatarImageUrl = [userDict objectForKey:K_BSDK_PICTURE_65];
    if (avatarImageUrl && [avatarImageUrl length]) {
        [friendImageView setImageWithURL:[NSURL URLWithString:avatarImageUrl] placeholderImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:userDict]]];
    }
    else
    {
        [friendImageView setImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:userDict]]];
    }

    descriptionLabel.text = [data objectForKey:K_BSDK_CONTENT];

    timeLabel.text = [ViewHelper intervalSinceNow:[data objectForKey:K_BSDK_CREATETIME]];

    [itemImageView setImageWithURL:[NSURL URLWithString:[data objectForKey:K_BSDK_PICTURE_102]]];

    NSString * isVerify = [userDict objectForKey:K_BSDK_ISVERIFY];
    if (isVerify && [isVerify isEqual:@"1"]) {
        [self.vMarkImageView setImage:[UIImage imageNamed:@"v_mark_small"]];
        [self.vMarkImageView setHidden:NO];
    }
    else
    {
        [self.vMarkImageView setHidden:YES];
    }

    NSString * title = [NSString stringWithFormat:@"¥ %@",[data objectForKey:K_BSDK_PRICE]];
    [self.costButton setTitle:title forState:UIControlStateNormal];
    self.costButton.frame = CGRectMake(CGRectGetMinX(self.costButton.frame),
                                                CGRectGetMinY(self.costButton.frame),
                                                [ViewHelper getWidthOfText:title ByFontSize:self.costButton.titleLabel.font.pointSize]+10,
                                                CGRectGetHeight(self.costButton.frame));
    self.costButton.center = CGPointMake(itemImageView.center.x, CGRectGetMinY(self.costButton.frame));
}

- (CGFloat)getCellHeight
{
    return 120.0f;
}

@end
