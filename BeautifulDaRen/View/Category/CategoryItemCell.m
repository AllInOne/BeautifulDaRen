//
//  CategoryItemCell.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryItemCell.h"

@implementation CategoryItemCell

@synthesize categoryScrollItem = _categoryScrollItem;

- (void)dealloc {
    [_categoryScrollItem release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // TODO: test code
        NSArray * images = [NSArray arrayWithObjects:
                            @"1",                    
                            @"2",                        
                            @"3",                      
                            @"2",
                            @"3",
                            @"2",
                            @"3",
                            @"2",
                            @"3",
                            nil];
        _categoryScrollItem = [[CommonScrollView alloc] initWithNibName:@"CommonScrollView" bundle:nil data:images andDelegate:self];
        [self addSubview:_categoryScrollItem.view];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)onItemSelected:(int)index
{
    NSLog(@"Category %d selected", index);
}

@end
