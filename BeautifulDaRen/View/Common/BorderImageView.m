#import "BorderImageView.h"
#import <QuartzCore/QuartzCore.h>


@implementation BorderImageView
@synthesize index = _index;
- (id)initWithFrame:(CGRect)frame andView:(UIView*)view needNotification:(BOOL)isNeed
{
    self = [super initWithFrame:frame];
    if(self)
    {
        view.frame = CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4);
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

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4);
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
        view.frame = CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4);
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
