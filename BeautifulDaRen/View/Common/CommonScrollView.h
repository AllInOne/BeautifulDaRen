//
//  CommonScrollView.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommonScrollViewProtocol <NSObject>

// The item index of data parameter of method initWithNibName:bundle:data:andDelegate: is selected
- (void)onItemSelected:(int)index;
@end

@interface CommonScrollView : UIViewController

// Init the scroll view, data contains the image urls, and delegate to notify caller which item is selected.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data: (NSArray *)data andDelegate:(id<CommonScrollViewProtocol>) delegate;

@property (nonatomic, assign) id<CommonScrollViewProtocol> delegate;

@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;

-(IBAction)onScrollItemClicked:(id)sender;
@end
