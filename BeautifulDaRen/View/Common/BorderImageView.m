#import "BorderImageView.h"
#import <QuartzCore/QuartzCore.h>

#define IMAGE_FRAME_MARGIN 1

@implementation BorderImageView
@synthesize index = _index;
- (id)initWithFrame:(CGRect)frame andView:(UIView*)view needNotification:(BOOL)isNeed
{
    self = [super initWithFrame:frame];
    if(self)
    {
        view.frame = CGRectMake(IMAGE_FRAME_MARGIN, IMAGE_FRAME_MARGIN, frame.size.width - 2 * IMAGE_FRAME_MARGIN, frame.size.height - 2 * IMAGE_FRAME_MARGIN);
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1;
        [self addSubview:view];
        
        if (isNeed) {
            UIButton * actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [actionButton setFrame:frame];
            [actionButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:actionButton];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image needNotification:(BOOL)isNeed
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(IMAGE_FRAME_MARGIN, IMAGE_FRAME_MARGIN, frame.size.width - 2 * IMAGE_FRAME_MARGIN, frame.size.height - 2 * IMAGE_FRAME_MARGIN);
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1;
        [self addSubview:imageView];  
        [imageView release];
        
        if (isNeed) {
            UIButton * actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [actionButton setFrame:frame];
            [actionButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:actionButton];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(IMAGE_FRAME_MARGIN, IMAGE_FRAME_MARGIN, frame.size.width - 2 * IMAGE_FRAME_MARGIN, frame.size.height - 2 * IMAGE_FRAME_MARGIN);
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1;
        [self addSubview:imageView];  
        [imageView release];

        UIButton * actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [actionButton setFrame:frame];
        [actionButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andView:(UIView*)view
{
    self = [super initWithFrame:frame];
    if(self)
    {
        view.frame = CGRectMake(IMAGE_FRAME_MARGIN, IMAGE_FRAME_MARGIN, frame.size.width - 2 * IMAGE_FRAME_MARGIN, frame.size.height - 2 * IMAGE_FRAME_MARGIN);
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1;
        [self addSubview:view];
        
        UIButton * actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [actionButton setFrame:frame];
        [actionButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionButton];
    }
    return self;
}

-(void)onButtonClicked:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"borderImageViewSelected"
                                                        object:self
                                                      userInfo:nil];
}

@end
