//
//  ForwardCommentListViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForwardCommentListViewController.h"
#import "comment.h"
#import "ViewHelper.h"
#import "ForwardCommentTableViewCell.h"

#define FONT_SIZE           (14.0f)
#define CELL_CONTENT_WIDTH  (240.0f)
#define CELL_CONTENT_Y_OFFSET  (40.0f)
#define CELL_MIN_HEIGHT     (60.0f)


@interface ForwardCommentListViewController ()

@property (nonatomic, retain) NSMutableArray * forwardOrCommentList;
- (void)loadComments;
@end

@implementation ForwardCommentListViewController

@synthesize forwardOrCommentListTableView = _forwardOrCommentListTableView;
@synthesize forwardOrCommentList = _forwardOrCommentList;

- (void)dealloc
{
    [_forwardOrCommentList release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setBackgroundImage:[UIImage imageNamed:@"顶部按钮50x29.png"] forState:UIControlStateNormal];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(onBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        backButton.frame = CGRectMake(0, 0, 50, 30);
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.forwardOrCommentListTableView setDelegate:self];
    [self.forwardOrCommentListTableView setDataSource:self];
    [self loadComments];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* UITableViewDelegate/UITableViewDataSource delegate methods */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * forwardCommentCellIdentifier = @"ForwardCommentTableViewCell";

    ForwardCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:forwardCommentCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:forwardCommentCellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    Comment * comment = [self.forwardOrCommentList objectAtIndex:[indexPath row]];
    cell.username.text = comment.userName;
    [cell.userAvatar setImage:[UIImage imageNamed:@"avatar_icon"]];
    cell.timestamp.text = comment.age;
    cell.content.text = comment.content;
    
    CGFloat contentHeight = [ViewHelper getHeightOfText:comment.content ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH];
    
    cell.content.frame = CGRectMake(cell.content.frame.origin.x, CELL_CONTENT_Y_OFFSET, cell.content.frame.size.width, contentHeight);
    
    [cell.content setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.forwardOrCommentList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Comment * comment = [self.forwardOrCommentList objectAtIndex:[indexPath row]];
    CGFloat contentHeight = [ViewHelper getHeightOfText:comment.content ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH];
    
    contentHeight += CELL_CONTENT_Y_OFFSET;
    
    return MAX(contentHeight, CELL_MIN_HEIGHT);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO:
}
                                 
#pragma mark private methods                                 
- (void)loadComments
{
    NSArray * userNames = [NSArray arrayWithObjects:@"阿丘",@"你不在",
                             @"多余的人",@"一丝雪",@"思密达",@"叶子",
                             @"窗外的雨",@"丘比特",@"阿丘",@"一丝雪",@"你不在",@"窗外的雨", @"一丝雪", nil];
    NSArray * ages = [NSArray arrayWithObjects:@"1分钟前",@"2分钟前",
                           @"4分钟前",@"11分钟前",@"21分钟前",@"30分钟前",
                           @"50分钟前",@"1小时前",@"2小时前",@"2小时前",@"5小时前",@"1天前", @"3天前", nil];
    
    NSArray * commentContents = [NSArray arrayWithObjects:@"@叶子 好的，感谢",@"这个其实不错哦",
                             @"",@"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...",@"测试的内容",@"good bay",@"一切都是浮云",@"好",
                                 @"你有多久没被人追冻结的心才化成水爱不管是与非你为何那么的完美为何要闯进我世界偏偏你好得无怨言抱你想掉眼泪每一滴都那么珍贵你给我的爱绝对整夜的高兴不想睡你让我心在空中飞飞多久我都不想坠",@"xxxxxxxxxxxxxx",@"",@"转给你看看", @"好久没联系了！", nil];
    
    NSInteger count = [userNames count];
    _forwardOrCommentList = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        Comment * item = [[[Comment alloc] init] autorelease];
        item.userName = [userNames objectAtIndex:i];
        item.content = [commentContents objectAtIndex:i];
        item.age = [ages objectAtIndex:i];
        
        [_forwardOrCommentList addObject:item];
    }
}

@end
