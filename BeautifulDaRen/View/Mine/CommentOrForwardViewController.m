#import "CommentOrForwardViewController.h"
#import "AtMeViewCell.h"
#import "ViewHelper.h"

@interface CommentOrForwardViewController()

@property (retain, nonatomic) IBOutlet UITableView * tableView;

@property (assign, nonatomic) NSInteger controllerType;

@end

@implementation CommentOrForwardViewController
@synthesize tableView = _tableView;
@synthesize controllerType = _controllerType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClicked) title:NSLocalizedString(@"refresh", @"refresh")]];
        _controllerType = type;
        if(_controllerType == CommentOrForwardViewControllerType_FORWARD)
        {
            [self.navigationItem setTitle:NSLocalizedString(@"@me", @"@me")];
        }
        else
        {
            [self.navigationItem setTitle:NSLocalizedString(@"comment_me", @"comment_me")];
        }
    }
    return self;
}

- (void) onBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onRefreshButtonClicked
{
    [ViewHelper showSimpleMessage:@"refresh button click" withTitle:nil withButtonText:@"ok"];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDelegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row] % 2;
    return  (index == 0) ? 130 : 200;
}

#pragma mark UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * atMeViewCellIdentifier = @"AtMeViewCell";
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:atMeViewCellIdentifier];
    NSInteger index = [indexPath row] % 2;
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:atMeViewCellIdentifier owner:self options:nil] objectAtIndex:index];
    }
    AtMeViewCell * atMeCell = (AtMeViewCell*)cell;
    atMeCell.friendNameLabel.text = @"仁和春天光华店";
    atMeCell.shopNameLabel.text = @"仁和春天";
    atMeCell.brandLabel.text = @"好莱坞明星";
    if(index == 1)
    {
        atMeCell.weiboImageView.image = [ViewHelper getBubbleImageWithWidth:120 height:90];
        UIImageView * originalWeiboAvatarImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 25, 25)] autorelease];
        originalWeiboAvatarImageView.image = [UIImage imageNamed:@"item_fake"];
        [atMeCell.weiboView addSubview:originalWeiboAvatarImageView];
        
        UILabel * originalWeiBoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, 150, 25)];
        originalWeiBoNameLabel.font = [UIFont systemFontOfSize:12];
        originalWeiBoNameLabel.text = @"原始微博name";
        originalWeiBoNameLabel.backgroundColor = [UIColor clearColor];
        [atMeCell.weiboView addSubview:originalWeiBoNameLabel];
        
        UILabel * originalWeiBoTimeLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 12, 60, 25)];
        originalWeiBoTimeLineLabel.font = [UIFont systemFontOfSize:12];
        originalWeiBoTimeLineLabel.backgroundColor = [UIColor clearColor];
        originalWeiBoTimeLineLabel.text = @"12天以前";
        [atMeCell.weiboView addSubview:originalWeiBoTimeLineLabel];
        
        UIImageView * originalWeiboItemImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 60, 60)] autorelease];
        originalWeiboItemImageView.image = [UIImage imageNamed:@"item_fake"];
        [atMeCell.weiboView addSubview:originalWeiboItemImageView];
        
        UILabel * originalWeiBoCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 83, 33, 15)];
        originalWeiBoCostLabel.font = [UIFont systemFontOfSize:12];
        originalWeiboItemImageView.backgroundColor = [UIColor clearColor];
        originalWeiBoCostLabel.text = @"￥120";
        [atMeCell.weiboView addSubview:originalWeiBoCostLabel];
        
        UILabel * originalWeiBoShopLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 200, 20)];
        originalWeiBoShopLabel.font = [UIFont systemFontOfSize:12];
        originalWeiBoShopLabel.backgroundColor = [UIColor clearColor];
        originalWeiBoShopLabel.text = @"商场：万达广场";
        [atMeCell.weiboView addSubview:originalWeiBoShopLabel];
        
        UILabel * originalWeiBoBrandLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 75, 200, 20)];
        originalWeiBoBrandLabel.font = [UIFont systemFontOfSize:12];
        originalWeiBoBrandLabel.backgroundColor = [UIColor clearColor];
        originalWeiBoBrandLabel.text = @"品牌：Louis Vuitton";
        [atMeCell.weiboView addSubview:originalWeiBoBrandLabel];
    }
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
@end
