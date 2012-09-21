//
//  CommonViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 6/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "CommonViewController.h"
#import "FriendListViewCell.h"
#import "BorderImageView.h"
#import "ViewHelper.h"

@interface CommonViewController ()

@property (retain, nonatomic) IBOutlet UITableView * commonTableView;

@end

@implementation CommonViewController
@synthesize commonTableView = _commonTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        [self.navigationItem setTitle:@"我的好友"];
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
    [self dismissModalViewControllerAnimated:YES];
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

}

@end
