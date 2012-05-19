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
#import "DataConstants.h"
#import "ForwardCommentTableViewCell.h"
#import "DataManager.h"

#define FONT_SIZE           (14.0f)
#define CELL_CONTENT_WIDTH  (240.0f)
#define CELL_CONTENT_Y_OFFSET  (40.0f)
#define CELL_MIN_HEIGHT     (60.0f)


@interface ForwardCommentListViewController ()

@property (nonatomic, retain) NSArray * forwardOrCommentList;

-(void)refreshData;
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
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:@"返回"]];
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

-(void)refreshData
{
    if(_forwardOrCommentList)
    {
        [_forwardOrCommentList release];
    }
    
    _forwardOrCommentList = [[[DataManager sharedManager] getCommentOfLocalIdentityWithLimit:9 finishBlock:^(NSError *error) {
        NSLog(@"get comment from DB with error:%@",error);
    }] copy];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.forwardOrCommentListTableView setDelegate:self];
    [self.forwardOrCommentListTableView setDataSource:self];
    [self loadComments];
    // Do any additional setup after loading the view from its nib.
    
    [self refreshData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self refreshData];
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

#pragma mark Scroll view
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self refreshData];
}

/* UITableViewDelegate/UITableViewDataSource delegate methods */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * forwardCommentCellIdentifier = @"ForwardCommentTableViewCell";

    ForwardCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:forwardCommentCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:forwardCommentCellIdentifier owner:self options:nil] objectAtIndex:0];
    }

    Comment * comment = [self.forwardOrCommentList objectAtIndex:[indexPath row]];
    cell.username.text = comment.personName;
    [cell.userAvatar setImage:[UIImage imageNamed:@"avatar_icon"]];
    cell.timestamp.text = @"1分钟";
    cell.content.text = comment.detail;
    
    CGFloat contentHeight = [ViewHelper getHeightOfText:comment.detail ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH];
    
    cell.content.frame = CGRectMake(cell.content.frame.origin.x, CELL_CONTENT_Y_OFFSET, cell.content.frame.size.width, contentHeight);
    
    [cell.content setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_forwardOrCommentList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Comment * comment = [self.forwardOrCommentList objectAtIndex:[indexPath row]];
    CGFloat contentHeight = [ViewHelper getHeightOfText:comment.detail ByFontSize:FONT_SIZE contentWidth:CELL_CONTENT_WIDTH];
    
    contentHeight += CELL_CONTENT_Y_OFFSET;
    
    return MAX(contentHeight, CELL_MIN_HEIGHT);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO:
}
                                 
#pragma mark private methods                                 
- (void)loadComments
{
//    NSArray * userNames = [NSArray arrayWithObjects:@"阿丘",@"你不在",
//                             @"多余的人",@"一丝雪",@"思密达",@"叶子",
//                             @"窗外的雨",@"丘比特",@"阿丘",@"一丝雪",@"你不在",@"窗外的雨", @"一丝雪", nil];
//    NSArray * ages = [NSArray arrayWithObjects:@"1分钟前",@"2分钟前",
//                           @"4分钟前",@"11分钟前",@"21分钟前",@"30分钟前",
//                           @"50分钟前",@"1小时前",@"2小时前",@"2小时前",@"5小时前",@"1天前", @"3天前", nil];
//    
//    NSArray * commentContents = [NSArray arrayWithObjects:@"@叶子 好的，感谢",@"这个其实不错哦",
//                             @"",@"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...",@"测试的内容",@"good bay",@"一切都是浮云",@"好",
//                                 @"你有多久没被人追冻结的心才化成水爱不管是与非你为何那么的完美为何要闯进我世界偏偏你好得无怨言抱你想掉眼泪每一滴都那么珍贵你给我的爱绝对整夜的高兴不想睡你让我心在空中飞飞多久我都不想坠",@"xxxxxxxxxxxxxx",@"",@"转给你看看", @"好久没联系了！", nil];
    
    NSDictionary * dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_001",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_001", COMMENT_PERSON_ID,
                            @"安丘", COMMENT_PERSON_NAME,
                            @"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_002",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_002", COMMENT_PERSON_ID,
                            @"多余的人", COMMENT_PERSON_NAME,
                            @"转给你看看", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_003",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_003", COMMENT_PERSON_ID,
                            @"一丝雪", COMMENT_PERSON_NAME,
                            @"你有多久没被人追冻结的心才化成水爱不管是与非你为何那么的完美为何要闯进我世界偏偏你好得无怨言抱你想掉眼泪每一滴都那么珍贵你给我的爱绝对整夜的高兴不想睡你让我心在空中飞飞多久我都不想坠", COMMENT_DETAIL,
                            @"WEIBO_ID_002", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_004",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_001", COMMENT_PERSON_ID,
                            @"安丘", COMMENT_PERSON_NAME,
                            @"1234567", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_005",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_001", COMMENT_PERSON_ID,
                            @"思密达", COMMENT_PERSON_NAME,
                            @"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_006",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_001", COMMENT_PERSON_ID,
                            @"安丘", COMMENT_PERSON_NAME,
                            @"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict7 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_007",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_001", COMMENT_PERSON_ID,
                            @"安丘", COMMENT_PERSON_NAME,
                            @"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict8 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_008",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_001", COMMENT_PERSON_ID,
                            @"安丘", COMMENT_PERSON_NAME,
                            @"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict9 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_009",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_003", COMMENT_PERSON_ID,
                            @"一丝雪", COMMENT_PERSON_NAME,
                            @"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...", COMMENT_DETAIL,
                            @"WEIBO_ID_002", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
//    _forwardOrCommentList = [[NSMutableArray alloc] initWithObjects:dict1,dict2,dict3,dict4,dict5,dict6,dict7,dict8,dict9, nil];
    ProcessFinishBlock block = ^(NSError *error)
    {
        if(error)
        {
            NSLog(@"save comment error: %@", error);
        }
        else
        {
            NSLog(@"save comment ok");
        }
    };
    [[DataManager sharedManager] saveCommentWithDictionary:dict1 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict2 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict3 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict4 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict5 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict6 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict7 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict8 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict9 finishBlock:block];
}

@end
