//
//  CommentViewCell.m
//  BeautifulDaRen
//
//  Created by jerry.li on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentViewCell.h"
#import "BSDKDefines.h"
#import "ViewHelper.h"
#import "ViewConstants.h"
#import "UIImageView+WebCache.h"

#define FONT_SIZE           (14.0f)
#define CELL_CONTENT_WIDTH  (300.0f)
#define CELL_CONTENT_HEIGHT  (135.0f)
#define CELL_CONTENT_Y_OFFSET  (20.0f)

#define CELL_CONTENT_MARGIN  (10)

@interface CommentViewCell ()
- (void)setAvatarImageView:(UIImageView*)imageView byUserInfo:(NSDictionary*)userInfo;
@end

@implementation CommentViewCell

@synthesize originalBrand = _originalBrand;
@synthesize originalImage = _originalImage;
@synthesize originalContent = _originalContent;
@synthesize originalMerchant = _originalMerchant;
@synthesize originalWeiboView = _originalWeiboView;
@synthesize originalAuthorAvatar = _originalAuthorAvatar;
@synthesize originalAuthorName = _originalAuthorName;
@synthesize originalWeiboBgView = _originalWeiboBgView;
@synthesize originalAuthorVMark = _originalAuthorVMark;

@synthesize authorName = _authorName;
@synthesize authorAvatar = _authorAvatar;
@synthesize authorVMark = _authorVMark;
@synthesize timestamp = _timestamp;
@synthesize commentContent = _commentContent;
@synthesize originalPriceButton = _originalPriceButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setData:(NSDictionary*)data
{
    NSDictionary * originalBlogInfo = [data objectForKey:K_BSDK_BLOGINFO];
    if (originalBlogInfo == nil) {
        originalBlogInfo = [data objectForKey:K_BSDK_RETWEET_STATUS];
    }
    NSDictionary * authorInfo = [data objectForKey:K_BSDK_USERINFO];
    
    NSDictionary * originalUserInfo = [originalBlogInfo objectForKey:K_BSDK_USERINFO];
    
    //self.authorAvatar
    self.authorName.text = [authorInfo objectForKey:K_BSDK_USERNAME];
    NSString * title = [NSString stringWithFormat:@"¥ %@",[originalBlogInfo objectForKey:K_BSDK_PRICE]];
    
    NSString * isVerify = [authorInfo objectForKey:K_BSDK_ISVERIFY];
    if (isVerify && [isVerify isEqual:@"1"]) {
        [self.authorVMark setImage:[UIImage imageNamed:@"v_mark_big"]];
        [self.authorVMark setHidden:NO];
    }
    else
    {
        [self.authorVMark setHidden:YES];
    }
    
    [self.originalPriceButton setTitle:title forState:UIControlStateNormal];
    self.originalPriceButton.frame = CGRectMake(CGRectGetMinX(self.originalPriceButton.frame), 
                                        CGRectGetMinY(self.originalPriceButton.frame), 
                                        [ViewHelper getWidthOfText:title ByFontSize:self.originalPriceButton.titleLabel.font.pointSize]+10,
                                        CGRectGetHeight(self.originalPriceButton.frame));

    self.originalPriceButton.center = CGPointMake(self.originalImage.center.x, CGRectGetMinY(self.originalPriceButton.frame));
    self.timestamp.text = [ViewHelper intervalSinceNow:[data objectForKey:K_BSDK_CREATETIME]];
    
//    self.originalAuthorAvatar
    self.originalBrand.text = [originalBlogInfo objectForKey:K_BSDK_BRANDSERVICE];
    self.originalMerchant.text = [originalBlogInfo objectForKey:K_BSDK_SHOPMERCHANT];
    self.originalContent.text = [originalBlogInfo objectForKey:K_BSDK_CONTENT];
    self.originalAuthorName.text = [originalUserInfo objectForKey:K_BSDK_USERNAME];

    [self.originalImage setImageWithURL:[NSURL URLWithString:[originalBlogInfo objectForKey:K_BSDK_PICTURE_102]]];
    
    isVerify = [originalUserInfo objectForKey:K_BSDK_ISVERIFY];
    if (isVerify && [isVerify isEqual:@"1"]) {
        [self.originalAuthorVMark setImage:[UIImage imageNamed:@"v_mark_small"]];
        [self.originalAuthorVMark setHidden:NO];
    }
    else
    {
        [self.originalAuthorVMark setHidden:YES];
    }
    
    [self setAvatarImageView:self.originalAuthorAvatar byUserInfo:originalUserInfo];
    [self setAvatarImageView:self.authorAvatar byUserInfo:authorInfo];

    self.commentContent.text = [data objectForKey:K_BSDK_CONTENT];
    
    
    CGFloat commentHeight = [ViewHelper getHeightOfText:self.commentContent.text ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH];
    
    self.commentContent.frame = CGRectMake(CGRectGetMinX(self.commentContent.frame), 
                                           CGRectGetMinY(self.commentContent.frame),
                                           CGRectGetWidth(self.commentContent.frame), 
                                           commentHeight);
    
    self.originalWeiboView.frame = CGRectMake((SCREEN_WIDTH - CELL_CONTENT_WIDTH) /2,
                                               CGRectGetMaxY(self.commentContent.frame) + CELL_CONTENT_MARGIN, 
                                               CELL_CONTENT_WIDTH, 
                                               CELL_CONTENT_HEIGHT);
    self.originalWeiboBgView.frame = CGRectMake(0,
                                                0, 
                                                CELL_CONTENT_WIDTH, 
                                                CELL_CONTENT_HEIGHT);
    
    
}

- (CGFloat)getCellHeightByData:(NSDictionary*)data
{
    self.commentContent.text = [data objectForKey:K_BSDK_CONTENT];
    CGFloat commentHeight = [ViewHelper getHeightOfText:self.commentContent.text ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH];
    
    self.commentContent.frame = CGRectMake(CGRectGetMinX(self.commentContent.frame), 
                                           CGRectGetMinY(self.commentContent.frame),
                                           CGRectGetWidth(self.commentContent.frame), 
                                           commentHeight);
    self.originalWeiboView.frame = CGRectMake((SCREEN_WIDTH - CELL_CONTENT_WIDTH) /2,
                                              CGRectGetMaxY(self.commentContent.frame) + CELL_CONTENT_MARGIN, 
                                              CELL_CONTENT_WIDTH, 
                                              CELL_CONTENT_HEIGHT);
    
    return CGRectGetMaxY(self.originalWeiboView.frame) + CELL_CONTENT_MARGIN;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setAvatarImageView:(UIImageView*)imageView byUserInfo:(NSDictionary*)userInfo
{
    NSString * userAvatarUrl = [userInfo objectForKey:K_BSDK_PICTURE_65];
    if (userAvatarUrl && [userAvatarUrl length]) {
        [imageView setImageWithURL:[NSURL URLWithString:userAvatarUrl] placeholderImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:userInfo]]];
    }
    else
    {
        [imageView setImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:userInfo]]];
    }
}

@end
