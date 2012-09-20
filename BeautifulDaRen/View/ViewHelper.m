//
//  ViewHelper.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/26/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ViewHelper.h"
#import "BSDKDefines.h"
#import "ButtonViewCell.h"
#import "ViewConstants.h"
#import "NSAttributedString+Attributes.h"
#import "UIImageView+WebCache.h"

#define BACK_BUTTON_LABEL_X_OFFSET  (5.0)

#define BUBBLE_AVATAR_SIZE  (32.0)


@interface BUIFont : NSObject

@property (retain, nonatomic) UIFont* font14;

+(BUIFont*)sharedFont;

@end

static BUIFont * instance;

@implementation BUIFont
@synthesize font14 = _font14;
-(UIFont*)font14
{
    if (_font14 == nil) {
        _font14 = [UIFont systemFontOfSize:14];
    }
    return _font14;
}


+(BUIFont*)sharedFont
{
    @synchronized([BUIFont class]) {
        if (!instance) {
            instance = [[BUIFont alloc] init];
        }
    }
    return instance;
}

@end

static dispatch_queue_t background_cacheQueue = NULL;

#pragma mark - C interface
static dispatch_queue_t getImageDownloadQueue() {
    if (background_cacheQueue == NULL){
        background_cacheQueue = dispatch_queue_create("ImageDownloaderQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return background_cacheQueue;
}

@implementation ViewHelper

+ (dispatch_queue_t) getImageDownloadQueue {
    return getImageDownloadQueue();
}

+(void)showSimpleMessage:(NSString*)message withTitle:(NSString*)title withButtonText:(NSString*)buttonText
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:buttonText
                                          otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

+(UITableViewCell*) getLoginWithExtenalViewCellInTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonViewCell"];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ButtonViewCell" owner:self options:nil] objectAtIndex:6];
    }

    // sina weibo
    ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"login_with_sina_weibo", @"You are not user, please register");
    ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"sina_logo"]; 
    // tencent weibo
    ((ButtonViewCell*)cell).buttonRightText.text = NSLocalizedString(@"login_with_tencent_qq", @"You are not user, please register");
    ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"tencent_logo"]; 

    return cell;
}

+ (CGFloat)getHeightOfText: (NSString*)text ByFontSize:(CGFloat)fontSize contentWidth:(CGFloat)width
{
    CGSize constraint = CGSizeMake(width, 20000.0f);
    
    CGSize size = [text
                   sizeWithFont:[UIFont systemFontOfSize: fontSize] constrainedToSize: constraint];
    
    return size.height;
}

+ (CGFloat)getWidthOfText:(NSString*)text ByFontSize:(CGFloat)fontSize
{
    CGSize constraint = CGSizeMake(20000.0f, 50.0f);
    
    CGSize size = [text
                   sizeWithFont:[UIFont systemFontOfSize: fontSize] constrainedToSize: constraint];
    
    return size.width;
}


+ (UIBarButtonItem*)getBarItemOfTarget:(id)target action:(SEL)action title:(NSString*)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_button"] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button.titleLabel setFont:[[BUIFont sharedFont] font14]];
    
    CGFloat width = [ViewHelper getWidthOfText:title ByFontSize:14];

    button.frame = CGRectMake(0, 0, width+20, 30);
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (UIBarButtonItem*)getBackBarItemOfTarget:(id)target action:(SEL)action title:(NSString*)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, BACK_BUTTON_LABEL_X_OFFSET, 0, 0);
    button.titleLabel.frame = CGRectMake(button.titleLabel.frame.origin.x + 10, button.titleLabel.frame.origin.y, CGRectGetWidth(button.titleLabel.frame), CGRectGetHeight(button.titleLabel.frame));
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button.titleLabel setFont:[[BUIFont sharedFont] font14]];
    
    button.frame = CGRectMake(0, 0, 50, 30);
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (UIBarButtonItem*) getLeftBarItemOfImageName:(NSString*)image rectSize:(CGRect)rectSize
{
    UIImageView * imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:image]] autorelease];
    imageView.frame =rectSize;
    return [[[UIBarButtonItem alloc] initWithCustomView:imageView] autorelease];
}

+ (UIBarButtonItem*) getCameraBarItemOftarget:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setBackgroundImage:[UIImage imageNamed:@"camera_btn.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"camera_icon_big.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 40);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (UIBarButtonItem*)getRightBarItemOfTarget1:(id)target1 action1:(SEL)action1 title1:(NSString*)title1 target2:(id)target2 action2:(SEL)action2 title2:(NSString*)title2
{
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:[UIImage imageNamed:@"nav_button"] forState:UIControlStateNormal];
    [button1 setTitle:title1 forState:UIControlStateNormal];
    [button1 addTarget:target1 action:action1 forControlEvents:UIControlEventTouchUpInside];
    
    [button1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    button1.frame = CGRectMake(0, 0, 50, 30);
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundImage:[UIImage imageNamed:@"nav_button"] forState:UIControlStateNormal];
    [button2 setTitle:title2 forState:UIControlStateNormal];
    [button2 addTarget:target2 action:action2 forControlEvents:UIControlEventTouchUpInside];
    
    [button2.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    button2.frame = CGRectMake(60, 0, 50, 30);
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
    [view addSubview:button1];
    [view addSubview:button2];
    
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    [view release];
    return [barButtonItem autorelease];
}

+ (UIBarButtonItem*)getToolBarItemOfImageName:(NSString*)imageName target:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = CGRectMake(0, 0, 22, 35);

    button.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (NSMutableAttributedString *) getGridViewCellForContactInformationWithName:(NSString*)name detail:(NSString*)detail
{
    NSString * tempString = [NSString stringWithFormat:@"%@%@", name, detail];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:tempString];
    [attrStr setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [attrStr setTextColor:[UIColor colorWithRed:(204.0f/255.0f) green:(88.0f/255.0f) blue:(151.0f/255.0f) alpha:1.0f] range:NSMakeRange([name length], [detail length])];
    [attrStr setTextColor:[UIColor darkGrayColor] range:NSMakeRange(0, [name length])];
    return [attrStr autorelease];
}

+ (CGFloat)getRatioHeightOfImage:(UIImage*)image ratioWidth:(CGFloat)ratioWidth
{
    CGFloat ratio = ratioWidth / image.size.width;
    return ratio * image.size.height;
}

+ (void) handleKeyboardDidShow:(NSNotification*)aNotification
                      rootView:(UIView*)rootView
                     inputView:(UIView *)inputView
                    scrollView:(UIScrollView*)scrollView {
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect contentRect = rootView.frame;
    contentRect.size.height -= keyboardSize.height;
    CGPoint inputViewLeftTopPoint = [inputView convertPoint:inputView.frame.origin toView:rootView];
    CGPoint inputViewLeftBottomPoint = CGPointMake(inputViewLeftTopPoint.x, inputViewLeftTopPoint.y + inputView.frame.size.height);
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    if (!CGRectContainsPoint(contentRect, inputViewLeftBottomPoint)) {
        // get the height to bottom of the input view.
        CGFloat inputViewHeightToBottom = rootView.frame.size.height - inputViewLeftBottomPoint.y;
        // get the scroll height, and when scroll this height will make the input view visible.
        CGFloat scrollHeight = keyboardSize.height - inputViewHeightToBottom + scrollView.contentOffset.y;
        CGPoint scrollPoint = CGPointMake(0.0, scrollHeight);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

+ (void) handleKeyboardWillBeHidden:(UIScrollView*)scrollView {
    // set the tableview normal.
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

+ (NSString *)intervalSinceNow: (NSString *) theDate 
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        
    }
    [date release];
    return timeString;
}

+ (BOOL)isSelf:(NSString *)userId
{
    NSDictionary * myDict = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
    return [userId isEqual:[myDict objectForKey:K_BSDK_UID]];
}

+ (NSString*)getMyUserId
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] objectForKey:K_BSDK_UID];
}

+ (NSString*)getMyCity
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] objectForKey:K_BSDK_CITY];
}

+ (NSString*)getUserDefaultAvatarImageByData:(NSDictionary*)userInfo
{
    if ([[userInfo objectForKey:K_BSDK_GENDER] isEqualToString:K_BSDK_GENDER_FEMALE]) {
        return @"her_default_avatar";
    }
    else
    {
        return @"his_default_avatar";
    }
}

+ (BOOL) isDigitsString:(NSString*)str
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [str rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

+ (BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


+ (callBackBlock)getIndicatorViewBlockWithFrame:(CGRect)frame inView:(UIView*)superView
{
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0, 10, CGRectGetWidth(activityIndicator.frame), CGRectGetHeight(activityIndicator.frame));
    [activityIndicator startAnimating];
    
    NSString * text = NSLocalizedString(@"fetching", @"fetching");
    CGFloat textWidth = [ViewHelper getWidthOfText:text ByFontSize:13.0f];
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,5, textWidth, 30)];
    textLabel.text = text;
    [textLabel setTextColor:[UIColor grayColor]];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setFont:[UIFont systemFontOfSize:13.0f]];
    
    UIView * indicatorView = [[UIView alloc] initWithFrame:frame];
    [indicatorView setBackgroundColor:[UIColor clearColor]];
    
    [indicatorView addSubview:activityIndicator];
    [indicatorView addSubview:textLabel];
    
    [superView addSubview:indicatorView];

    [textLabel release];
    [activityIndicator release];
    [indicatorView release];
    
    callBackBlock callback = ^(void)
    {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [textLabel removeFromSuperview];
        [indicatorView removeFromSuperview];
    };

    return Block_copy(callback);
}


+ (UIView *)bubbleView:(NSString *)text from:(NSDictionary*)user atTime:(NSString*)timestamp {
    // build single chat bubble cell with given text
    BOOL fromSelf = [ViewHelper isSelf:[user objectForKey:K_BSDK_UID]];
    
    NSLog(@"bubbleView is self : %d", fromSelf);
    
    //根据气泡箭头的方向选择不同气泡图片
    
    UIImage *bubble = nil;
    if (fromSelf) {
        bubble = [UIImage imageNamed:@"private_letter_background_right"];
    }
    else
    {
        bubble = [UIImage imageNamed:@"private_letter_background_left"];
    }
    
    //对气泡图片进行拉伸
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0]];

    UIFont *font = [UIFont systemFontOfSize:12];
    //获取文字所占的大小
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];

    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(21.0f, 14.0f, size.width+10, size.height+10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = UILineBreakModeCharacterWrap;
    bubbleText.text = text;
    
    UIView *returnView = [[UIView alloc] init];
    returnView.backgroundColor = [UIColor clearColor];
    if(fromSelf)
    {
        bubbleImageView.frame = CGRectMake(80.0f, 30.0f, 200.0f, size.height+40.0f);
        bubbleText.frame = CGRectMake(101.0f, 40.0f, size.width+10, size.height+10);
        returnView.frame = CGRectMake(180.0f, 130.0f, 240.0f, size.height+70.0f);
    }
    else
    {
        bubbleImageView.frame = CGRectMake(40.0f, 30.0f, 200.0f, size.height+40.0f);
        bubbleText.frame = CGRectMake(61.0f, 40.0f, size.width+10, size.height+10);
        returnView.frame = CGRectMake(0.0f, 30.0f, 240.0f, size.height+70.0f);
    }
    
    UILabel * timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 15)];
    bubbleText.backgroundColor = [UIColor clearColor];
    timeLable.textAlignment = UITextAlignmentCenter;
    timeLable.font = font;
    timeLable.numberOfLines = 0;
    timeLable.textColor = [UIColor purpleColor];
    timeLable.lineBreakMode = UILineBreakModeCharacterWrap;
    timeLable.text = [ViewHelper intervalSinceNow:timestamp];
    
    UIImageView * avatar = [[UIImageView alloc] init];
    if (fromSelf) {
        avatar.frame = CGRectMake(280.0 + 5.0, 30.0, BUBBLE_AVATAR_SIZE, BUBBLE_AVATAR_SIZE);
    }
    else
    {
        avatar.frame = CGRectMake(5.0, 30.0, BUBBLE_AVATAR_SIZE, BUBBLE_AVATAR_SIZE);
    }
    
    NSString * avatarImageUrl = [user objectForKey:K_BSDK_PICTURE_65];
    if (avatarImageUrl && [avatarImageUrl length]) {
        [avatar setImageWithURL:[NSURL URLWithString:avatarImageUrl] placeholderImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:user]]];
    }
    else
    {
        [avatar setImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:user]]];
    }

    [returnView addSubview:bubbleImageView];
    [returnView addSubview:avatar];
    [returnView addSubview:bubbleText];
    [returnView addSubview:timeLable];
    
    [avatar release];
    [bubbleImageView release];
    [bubbleText release];
    [timeLable release];

    return [returnView autorelease];
}

@end
