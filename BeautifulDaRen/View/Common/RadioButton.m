//
//  RadioButton.m
//  RadioButton
//
//  Created by ohkawa on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RadioButton.h"

@interface RadioButton()

-(void)defaultInit;
-(void)otherButtonSelected:(id)sender;
-(void)handleButtonTap:(id)sender;
@end

@implementation RadioButton
@synthesize button = _button;
@synthesize textLabel = _textLabel;
@synthesize groupId=_groupId;
@synthesize index=_index;

static const NSUInteger kWidth=300;
static const NSUInteger kRadioButtonWidth=22;
static const NSUInteger kRadioButtonHeight=22;

static NSMutableArray *rb_instances=nil;
static NSMutableDictionary *rb_observers=nil;

#pragma mark - Observer

+(void)addObserverForGroupId:(NSString*)groupId observer:(id)observer{
    if(!rb_observers){
        rb_observers = [[NSMutableDictionary alloc] init];
    }

    if ([groupId length] > 0 && observer) {
        [rb_observers setObject:observer forKey:groupId];
        // Make it weak reference
        [observer release];
    }
}

#pragma mark - Manage Instances

+(void)registerInstance:(RadioButton*)radioButton{
    if(!rb_instances){
        rb_instances = [[NSMutableArray alloc] init];
    }

    [rb_instances addObject:radioButton];
    // Make it weak reference
    [radioButton release];
}

#pragma mark - Class level handler

+(void)buttonSelected:(RadioButton*)radioButton{

    // Notify observers
    if (rb_observers) {
        id observer= [rb_observers objectForKey:radioButton.groupId];

        if(observer && [observer respondsToSelector:@selector(radioButtonSelectedAtIndex:inGroup:)]){
            [observer radioButtonSelectedAtIndex:radioButton.index inGroup:radioButton.groupId];
        }
    }

    // Unselect the other radio buttons
    if (rb_instances) {
        for (int i = 0; i < [rb_instances count]; i++) {
            RadioButton *button = [rb_instances objectAtIndex:i];
            if (![button isEqual:radioButton]) {
                [button otherButtonSelected:radioButton];
            }
        }
    }
}

#pragma mark - Object Lifecycle

-(id)initWithGroupId:(NSString*)groupId text:(NSString*)text index:(NSUInteger)index{
    self = [self init];
    if (self) {
        self.groupId = groupId;
        self.index = index;
        self.textLabel.text = text;
    }
    return  self;
}

- (id)init{
    self = [super init];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (void)dealloc
{
    [_groupId release];
    [_button release];
    [super dealloc];
}

#pragma mark - Tap handling

-(void)handleButtonTap:(id)sender{
    [self.button setSelected:YES];
    [RadioButton buttonSelected:self];
}

-(void)otherButtonSelected:(id)sender{
    // Called when other radio button instance got selected
    if(self.button.selected){
        [self.button setSelected:NO];
    }
}

#pragma mark - RadioButton init

-(void)defaultInit{
    // Setup container view
    self.frame = CGRectMake(0, 0, kWidth, kRadioButtonHeight);

    // Customize UIButton
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0,kRadioButtonWidth, kRadioButtonHeight);
    self.button.adjustsImageWhenHighlighted = NO;

    [self.button setImage:[UIImage imageNamed:@"radio_btn_unselected"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"radio_btn_selected"] forState:UIControlStateSelected];

    [self.button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];

    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(kRadioButtonWidth + 5, 0, kWidth - kRadioButtonWidth - 5, kRadioButtonHeight)];
    self.textLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:self.button];
    [self addSubview:self.textLabel];

    [RadioButton registerInstance:self];
}

@end
