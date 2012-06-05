//
//  CommonViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 6/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendListViewCell.h"
#import "FriendDetailViewController.h"
#import "BorderImageView.h"
#import "ViewHelper.h"

@interface FriendListViewController ()
@property (assign, nonatomic) NSInteger type;

@property (retain, nonatomic) IBOutlet UITableView * commonTableView;

@end

@implementation FriendListViewController
@synthesize type = _type;
@synthesize commonTableView = _commonTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger)type{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString* title = nil;
        _type = type;
        switch (_type) {
            case FriendListViewController_TYPE_MY_FOLLOW:
                title = @"我的关注";
                break;
            case FriendListViewController_TYPE_MY_FANS:
                title = @"我的粉丝";
                break;
            case FriendListViewController_TYPE_MY_BLACKLIST:
                title = @"黑名单";
                break;
            case FriendListViewController_TYPE_FRIEND_FOLLOW:
                title = @"她的关注";
                break;
            case FriendListViewController_TYPE_FRIEND_FANS:
                title = @"她的粉丝";
                break;
        }
        [self.navigationItem setTitle:title];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)onBackButtonClicked {
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}


#pragma mark UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * friendListViewCellIdentifier = @"FriendListViewCell";
    NSArray * nameArray = [NSArray arrayWithObjects:
                           @"东东",
                           @"也许你是我唯一", 
                           @"天府广场",
                           @"奥斯卡", 
                           @"天之骄子",
                           @"醉在黄鹤楼", 
                           @"半个火枪手",
                           @"影子爱人", 
                           @"你知道我是谁知道",
                           @"飞越板凳", 
                           @"你是我的优乐美",
                           nil];
    UITableViewCell * cell = nil;
    NSInteger section = [indexPath section];
    cell = [tableView dequeueReusableCellWithIdentifier:friendListViewCellIdentifier];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:friendListViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        FriendListViewCell * friendListViewCell = (FriendListViewCell*)cell;
        BorderImageView * borderImageView = [[[BorderImageView alloc] initWithFrame:friendListViewCell.avatarImageView.frame andImage:[UIImage imageNamed:[NSString  stringWithFormat:@"search_avatar_sample%d",section+1]]] autorelease];
        [friendListViewCell.avatarImageView addSubview:borderImageView];
        
        friendListViewCell.friendNameLabel.text = [nameArray objectAtIndex:section];
        friendListViewCell.friendWeiboLabel.text = @"我今天在天府广场附近买了一款很好看的衣服。";
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 11;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendDetailViewController * friendDetailController = 
    [[[FriendDetailViewController alloc] init] autorelease];
    [self.navigationController pushViewController:friendDetailController animated:YES];
}

@end
