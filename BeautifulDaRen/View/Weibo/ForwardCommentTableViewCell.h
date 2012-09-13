//
//  ForwardCommentTableViewCell.h
//  BeautifulDaRen
//
//  Created by jerry.li on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForwardCommentTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel * username;
@property (nonatomic, retain) IBOutlet UILabel * timestamp;
@property (nonatomic, retain) IBOutlet UIImageView * userAvatar;
@property (nonatomic, retain) IBOutlet UILabel * content;

@end
