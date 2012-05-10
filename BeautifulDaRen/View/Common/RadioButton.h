//
//  RadioButton.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/10/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButton : UIView {
    NSString *_groupId;
    NSUInteger _index;
    UIButton *_button;
}
@property(nonatomic,retain)NSString *groupId;
@property(nonatomic,assign)NSUInteger index;

-(id)initWithGroupId:(NSString*)groupId index:(NSUInteger)index;
+(void)addObserverForGroupId:(NSString*)groupId observer:(id)observer;
@end
