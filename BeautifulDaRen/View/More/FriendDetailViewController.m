//
//  FriendDetailViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/21/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "ButtonViewCell.h"
#import "GridViewCell.h"
#import "ViewHelper.h"
#import "ViewConstants.h"
#import "FriendListViewController.h"
#import "WeiboListViewController.h"
#import "EdittingViewController.h"
#import "BSDKDefines.h"
#import "BSDKManager.h"
#import "iToast.h"
#import "WeiboComposerViewController.h"
#import "UIImageView+WebCache.h"
#import "BorderImageView.h"
#import "PrivateLetterDetailViewController.h"

typedef enum
{
    SECTION_NOTE,
    SECTION_VERIFY,
    // key brief is the last section.
    SECTION_BRIEF,
    SECTION_COUNT
}SECTION_NAME;

#define BREIF_WIDTH_OFFSET 30

@interface FriendDetailViewController()
@property (retain, nonatomic) IBOutlet UIButton * weiboButton;
@property (retain, nonatomic) IBOutlet UIButton * topicButton;
@property (retain, nonatomic) IBOutlet UIButton * followButton;
@property (retain, nonatomic) IBOutlet UIButton * fansButton;
@property (retain, nonatomic) IBOutlet UIButton * collectionButton;
@property (retain, nonatomic) IBOutlet UIButton * publishedButton;

@property (retain, nonatomic) IBOutlet UITableView * friendDetailView;
@property (assign, nonatomic) BOOL isIdentification;
@property (retain, nonatomic) NSMutableDictionary * friendDictionary;
@property (retain, nonatomic) NSString * friendId;

@property (retain, nonatomic) IBOutlet UILabel * nameLabel;
@property (retain, nonatomic) IBOutlet UILabel * cityLabel;
@property (retain, nonatomic) IBOutlet UILabel * detailAddressLabel;
@property (retain, nonatomic) IBOutlet UILabel * levelLabel;
@property (retain, nonatomic) IBOutlet UILabel * pointLabel;
@property (retain, nonatomic) IBOutlet UILabel * phoneLabel;
@property (retain, nonatomic) IBOutlet UIImageView * genderImageView;
@property (retain, nonatomic) IBOutlet BorderImageView * avatarImageView;
@property (retain, nonatomic) IBOutlet UIImageView * vMarkImageView;
@property (retain, nonatomic) IBOutlet UIButton * actionButton;
@property (retain, nonatomic) UIToolbar *toolbar;

- (void) onActionButtonClicked: (UIButton*)sender;
- (void) refreshTopView;
- (void) refreshToolBar;
- (void) initialize;
- (void) refreshView;
@end

@implementation FriendDetailViewController
@synthesize nameLabel = _nameLabel;
@synthesize cityLabel = _cityLabel;
@synthesize detailAddressLabel = _detailAddressLabel;
@synthesize levelLabel = _levelLabel;
@synthesize pointLabel = _pointLabel;
@synthesize friendDetailView = _friendDetailView;
@synthesize isIdentification = _isIdentification;
@synthesize genderImageView = _genderImageView;
@synthesize phoneLabel = _phoneLabel;
@synthesize followButton = _followButton;
@synthesize fansButton = _fansButton;
@synthesize collectionButton = _collectionButton;
@synthesize weiboButton = _weiboButton;
@synthesize publishedButton = _publishedButton;
@synthesize topicButton = _topicButton;
@synthesize friendDictionary = _friendDictionary;
@synthesize actionButton = _actionButton;
@synthesize friendId = _friendId;
@synthesize avatarImageView = _avatarImageView;
@synthesize toolbar = _toolbar;
@synthesize vMarkImageView = _vMarkImageView;

- (void) initialize
{
    [self.navigationItem setTitle:NSLocalizedString(@"her_home_page", @"her_home_page")];
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
//    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onHomePageButtonClicked) title:NSLocalizedString(@"home_page", @"home_page")]];
    _isIdentification = YES;
    
//    [self refreshToolBar];
}

- (void) refreshToolBar
{
    if (self.toolbar) {
        [self.toolbar removeFromSuperview];
        self.toolbar = nil;
    }
    _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,372, 320,44)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *atButtonItem = nil;
    
    if ([[self.friendDictionary objectForKey:K_BSDK_GENDER] isEqualToString:K_BSDK_GENDER_FEMALE]) {
        atButtonItem = [ViewHelper getToolBarItemOfImageName:@"toolbar_at_icon" target:self action:@selector(onAt)];
    }
    else
    {
        atButtonItem = [ViewHelper getToolBarItemOfImageName:@"toolbar_at_him" target:self action:@selector(onAt)];    
    }
    
    UIBarButtonItem *privateLetterButtonItem = [ViewHelper getToolBarItemOfImageName:@"toolbar_private_letter_icon" target:self action:@selector(onPrivateLetter)];
    
    if (![[BSDKManager sharedManager] isLogin]) {
        [atButtonItem setEnabled:NO];
        [privateLetterButtonItem setEnabled:NO];
    }
    
    UIBarButtonItem *removeButtonItem = [ViewHelper getToolBarItemOfImageName:@"toolbar_remove_fan_icon" target:self action:@selector(onRemove)];
    NSString * relationship = [self.friendDictionary objectForKey:K_BSDK_RELATIONSHIP];
    if ( (!(relationship && ([relationship isEqualToString:K_BSDK_RELATIONSHIP_MY_FANS] || [relationship isEqualToString:K_BSDK_RELATIONSHIP_INTER_FOLLOW]))) || ![[BSDKManager sharedManager] isLogin]) {
        [removeButtonItem setEnabled:NO];
    }
    
    NSArray *barItems = [[NSArray alloc]initWithObjects:
                         flexible,
                         privateLetterButtonItem,
                         flexible,
                         flexible,
                         atButtonItem,
                         flexible,
                         flexible,
                         removeButtonItem,
                         flexible,
                         nil];
    
    _toolbar.items= barItems;
    UIImageView * tabBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_background"]];
    tabBarBg.frame = CGRectMake(0, 0, 320, 45);
    tabBarBg.contentMode = UIViewContentModeScaleToFill;
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        [_toolbar  insertSubview:tabBarBg atIndex:0];
    }
    else
    {
        [_toolbar  insertSubview:tabBarBg atIndex:1];            
    }
    [self.view addSubview: _toolbar];
    [flexible release]; 
    [tabBarBg release];
    [barItems release];
    
    NSString * buttonTitle = ([relationship isEqualToString:K_BSDK_RELATIONSHIP_MY_FOLLOW] || [relationship isEqualToString:K_BSDK_RELATIONSHIP_INTER_FOLLOW]) ? NSLocalizedString(@"unfollow", @"unfollow") : NSLocalizedString(@"follow", @"follow");
    
    [self.actionButton setTitle:buttonTitle forState:UIControlStateNormal];
}

-(id)initWithFriendId:(NSString*)friendId
{
    self = [super init];
    if (self) {
        self.friendDictionary = [NSMutableDictionary dictionaryWithCapacity:20];
        self.friendId = friendId;
        [self initialize];
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        self.friendDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [self initialize];
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
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void) onHomePageButtonClicked
{
    [[iToast makeText:@"主页"] show];
}

#pragma mark - View lifecycle
- (void)dealloc
{
    [_friendDetailView release];
    [_fansButton release];
    [_followButton release];
    [_collectionButton release];
    [_weiboButton release];
    [_publishedButton release];
    [_topicButton release];
    [_actionButton release];
    [_friendDictionary release];
    [_avatarImageView release];
    [_genderImageView release];
    [_friendId release];
    [_nameLabel release];
    [_cityLabel release];
    [_detailAddressLabel release];
    [_levelLabel release];
    [_pointLabel release];
    [_phoneLabel release];
    [_vMarkImageView release];
    
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.friendDetailView = nil;
    self.followButton = nil;
    self.fansButton = nil;
    self.collectionButton = nil;
    self.weiboButton = nil;
    self.publishedButton = nil;
    self.topicButton = nil;
    self.actionButton = nil;
    self.avatarImageView = nil;
    self.genderImageView = nil;
    self.friendId = nil;
    self.nameLabel = nil;
    self.cityLabel = nil;
    self.detailAddressLabel = nil;
    self.levelLabel = nil;
    self.pointLabel = nil;
    self.phoneLabel = nil;
    self.vMarkImageView = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshView];
    
    if (self.friendDictionary) {
        [self refreshTopView];
        [self refreshToolBar];
    }
}

- (void)refreshView
{
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center = CGPointMake(SCREEN_WIDTH/2, USER_WINDOW_HEIGHT/2);
    [activityIndicator startAnimating];
    
    [self.view addSubview:activityIndicator];    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    processDoneWithDictBlock doneblock = ^(AIO_STATUS status, NSDictionary *data) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [activityIndicator release];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
        
        if (K_BSDK_IS_RESPONSE_OK(data)) {
            [self.friendDictionary setValuesForKeysWithDictionary:data];
            [self refreshTopView];
            [self refreshToolBar];
            [self.friendDetailView reloadData];
        }
        else
        {
            [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
        }
    };
    
    if (self.friendId) {
        [[BSDKManager sharedManager] getUserInforByUserId:self.friendId
                                          andDoneCallback:doneblock];
    }
    else
    {
        [[BSDKManager sharedManager] getUserInforByUserId:[self.friendDictionary objectForKey:K_BSDK_UID]
                                        andDoneCallback:doneblock];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)actionButtonClicked:(UIButton*)sender
{
    NSString* relation = [self.friendDictionary valueForKey:K_BSDK_RELATIONSHIP];
    NSInteger userId = [[self.friendDictionary valueForKey:K_BSDK_UID] intValue];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: TRUE];
    
    [self.actionButton setEnabled:NO];
    
    processDoneWithDictBlock doneBlock = ^(AIO_STATUS status, NSDictionary *data)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: FALSE];
        if (K_BSDK_IS_RESPONSE_OK(data)) {
            [self refreshView];
        }
        else
        {
            [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
        }
    };
    if ([relation isEqualToString:K_BSDK_RELATIONSHIP_MY_FOLLOW] || [relation isEqualToString:K_BSDK_RELATIONSHIP_INTER_FOLLOW])
    {
        [[BSDKManager sharedManager] unFollowUser:userId
                                  andDoneCallback:doneBlock];
    }
    else
    {
        [[BSDKManager sharedManager] followUser:userId
                                andDoneCallback:doneBlock];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if(section == 0)
    {
        number = _isIdentification ? SECTION_COUNT : SECTION_COUNT - 1;
    }
    else if(section == 1)
    {
        number = 1;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * buttonViewCellIdentifier = @"ButtonViewCell";
    static NSString * gridViewCellIdentifier = @"GridViewCell";
    
    UITableViewCell *cell  = nil;

    NSInteger section = [indexPath section];
    if(section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:3];
        }
        ButtonViewCell * buttonViewCell = (ButtonViewCell*)cell;
        if(_isIdentification)
        {
            switch ([indexPath row]) {
                case SECTION_NOTE:
                {
                    buttonViewCell.leftLabel.text = NSLocalizedString(@"notes", @"notes");
                    NSString * note = [self.friendDictionary valueForKey:K_BSDK_USER_NOTE_NAME];
                    buttonViewCell.buttonText.text = ([note length] > 0) ? note : NSLocalizedString(@"set_notes", @"set_notes");
                    break;
                }
                case SECTION_VERIFY:
                {
                    buttonViewCell.leftLabel.text = NSLocalizedString(@"authentication", @"authentication");
                    if ([[self.friendDictionary objectForKey:K_BSDK_ISVERIFY] isEqual:@"1"]) {
                        buttonViewCell.buttonText.text = NSLocalizedString(@"authentication_done", @"authentication_done");
                    }
                    else
                    {
                        buttonViewCell.buttonText.text = NSLocalizedString(@"authentication_not_done", @"authentication_not_done");
                    }
                    
                    buttonViewCell.buttonRightIcon.hidden = YES;
                    break;   
                }
                case SECTION_BRIEF:
                {
                    buttonViewCell.leftLabel.text = NSLocalizedString(@"brief", @"brief");
                    buttonViewCell.buttonRightIcon.hidden = YES;
                    
                    NSString * description = [self.friendDictionary valueForKey:KEY_ACCOUNT_INTRO];
                    if ([description length] > 0)
                    {
                        CGFloat frameWidth = buttonViewCell.buttonText.frame.size.width + BREIF_WIDTH_OFFSET;
                        CGFloat frameHeight = [ViewHelper getHeightOfText:description ByFontSize:15.0f contentWidth:frameWidth];
                        CGFloat heightOffset = frameHeight - buttonViewCell.buttonText.frame.size.height;
                        buttonViewCell.buttonText.frame = CGRectMake(buttonViewCell.buttonText.frame.origin.x,
                                                                     buttonViewCell.buttonText.frame.origin.y,
                                                                     frameWidth,
                                                                     frameHeight);
                        buttonViewCell.leftLabel.frame = CGRectMake(buttonViewCell.leftLabel.frame.origin.x,
                                                                    buttonViewCell.leftLabel.frame.origin.y+heightOffset/2,
                                                                    buttonViewCell.leftLabel.frame.size.width,
                                                                    buttonViewCell.leftLabel.frame.size.height);
                    }
                    if  (description && [description length])
                    {
                        buttonViewCell.buttonText.text = description;
                    }
                    else
                    {
                        buttonViewCell.buttonText.text = NSLocalizedString(@"descripton_not_done", @"descripton_not_done");
                    }
                    break;
                }
            }
        }
    }
    else if(section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:gridViewCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:gridViewCellIdentifier owner:self options:nil] objectAtIndex:1];
        }
        
        NSMutableAttributedString * attrStr = nil;
        
        attrStr = [ViewHelper
                   getGridViewCellForContactInformationWithName:NSLocalizedString(@"weibo", @"")
                   detail:[NSString stringWithFormat:@"(%d)",[[self.friendDictionary valueForKey:KEY_ACCOUNT_BLOG_COUNT] intValue]]];
        ((GridViewCell*)cell).firstLabel.attributedText = attrStr;
        ((GridViewCell*)cell).firstLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper
                   getGridViewCellForContactInformationWithName:NSLocalizedString(@"collection", @"")
                   detail:[NSString stringWithFormat:@"(%d)",[[self.friendDictionary valueForKey:KEY_ACCOUNT_FAVORITE_COUNT] intValue]]];
        ((GridViewCell*)cell).secondLabel.attributedText = attrStr;
        ((GridViewCell*)cell).secondLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper
                   getGridViewCellForContactInformationWithName:NSLocalizedString(@"follow", @"")
                   detail:[NSString stringWithFormat:@"(%d)",[[self.friendDictionary valueForKey:KEY_ACCOUNT_FOLLOW_COUNT] intValue]]];
        ((GridViewCell*)cell).thirdLabel.attributedText = attrStr;
        ((GridViewCell*)cell).thirdLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper
                   getGridViewCellForContactInformationWithName:NSLocalizedString(@"fans", @"")
                   detail:[NSString stringWithFormat:@"(%d)",[[self.friendDictionary valueForKey:KEY_ACCOUNT_FANS_COUNT] intValue]]];
        ((GridViewCell*)cell).fourthLabel.attributedText = attrStr;
        ((GridViewCell*)cell).fourthLabel.textAlignment = UITextAlignmentCenter;
        
        _weiboButton = ((GridViewCell*)cell).firstButton;
        _collectionButton= ((GridViewCell*)cell).secondButton;

        _followButton = ((GridViewCell*)cell).thirdButton;
        _fansButton = ((GridViewCell*)cell).fourthButton;

        [((GridViewCell*)cell).firstButton addTarget:self action:@selector(didButtonPressed:inView:) forControlEvents:UIControlEventTouchUpInside];
        [((GridViewCell*)cell).secondButton addTarget:self action:@selector(didButtonPressed:inView:) forControlEvents:UIControlEventTouchUpInside];
        [((GridViewCell*)cell).thirdButton addTarget:self action:@selector(didButtonPressed:inView:) forControlEvents:UIControlEventTouchUpInside];
        [((GridViewCell*)cell).fourthButton addTarget:self action:@selector(didButtonPressed:inView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case SECTION_NOTE:
        {
            EdittingViewController * edittingViewController = [[EdittingViewController alloc] initWithNibName:@"EdittingViewController" bundle:nil type:EdittingViewController_type0 block:^(NSString *text) {
                if (![text isEqualToString:[self.friendDictionary valueForKey:K_BSDK_USER_NOTE_NAME]]) {
                    [[BSDKManager sharedManager] addNoteToUserId:[self.friendDictionary valueForKey:K_BSDK_UID] noteName:text andCallBack:^(AIO_STATUS status, NSDictionary *data) {
                        if(AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
                        {
                            [self.friendDictionary setValue:text forKey:K_BSDK_USER_NOTE_NAME];
                            [self.friendDetailView reloadData];
                        }
                        else{
                            [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
                        }
                    }];
                }
            }];
            edittingViewController.placeholderString = [self.friendDictionary valueForKey:K_BSDK_USER_NOTE_NAME];
            [self.navigationController pushViewController:edittingViewController animated:YES];
            [edittingViewController release];
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        height = 40.0f;
        if ([indexPath row] == SECTION_BRIEF)
        {
            NSString * description = [self.friendDictionary valueForKey:KEY_ACCOUNT_INTRO];
            if ([description length] > 0)
            {
                CGFloat frameWidth = 184 + BREIF_WIDTH_OFFSET;
                height = [ViewHelper getHeightOfText:description ByFontSize:15.0f contentWidth:frameWidth] + 15;
            }
        }
    }
    else if (section == 1)
    {
        height = 71.0f;
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (void) didButtonPressed:(UIButton*)button inView:(UIView *)view
{
    UIViewController * viewController = nil;
    if(button == _followButton)
    {
        viewController = [[FriendListViewController alloc]
                          initWithNibName:@"FriendListViewController"
                          bundle:nil
                          type:FriendListViewController_TYPE_FRIEND_FOLLOW
                          dictionary:self.friendDictionary];
    }
    else if (button == _fansButton)
    {
        viewController = [[FriendListViewController alloc]
                          initWithNibName:@"FriendListViewController"
                          bundle:nil
                          type:FriendListViewController_TYPE_FRIEND_FANS
                          dictionary:self.friendDictionary];
    }
    else if (button == _collectionButton)
    {
        viewController = [[WeiboListViewController alloc]
                          initWithNibName:@"WeiboListViewController"
                          bundle:nil
                          type:WeiboListViewControllerType_FRIEND_COLLECTION
                          dictionary:self.friendDictionary];
    }
    else if (button == _weiboButton)
    {
        viewController = [[WeiboListViewController alloc]
                          initWithNibName:@"WeiboListViewController"
                          bundle:nil
                          type:WeiboListViewControllerType_FRIEND_WEIBO
                          dictionary:self.friendDictionary];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void) onActionButtonClicked: (UIButton*)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:nil, nil];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"add_to_black_list", @"add_to_black_list")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"impeach", "impeach")];
    [actionSheet setDestructiveButtonIndex:[actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"cancel")]];
    
    [actionSheet showInView:sender.superview.superview];
    [actionSheet release];
}

- (void)onPrivateLetter
{
    PrivateLetterDetailViewController *privateLetterDetailViewControlller = 
    [[PrivateLetterDetailViewController alloc] initWithNibName:nil bundle:nil];
    
    privateLetterDetailViewControlller.userId = [self.friendDictionary valueForKey:K_BSDK_UID];
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: privateLetterDetailViewControlller];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    [privateLetterDetailViewControlller release];
    [navController release];  


}

- (void)onAt
{
    WeiboComposerViewController *weiboComposerViewControlller = 
    [[WeiboComposerViewController alloc] initWithNibName:nil bundle:nil];
    
    [weiboComposerViewControlller.weiboContentTextView setText:[NSString stringWithFormat:@"@%@", [self.friendDictionary valueForKey:KEY_ACCOUNT_USER_NAME]]];
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboComposerViewControlller];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    [weiboComposerViewControlller release];
    [navController release];
    
}

- (void)onRemove
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: TRUE];
    [[BSDKManager sharedManager] removeFan:[self.friendDictionary valueForKey:K_BSDK_UID] andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: FALSE];
        [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
        [self refreshView];
    }];
}

- (void) refreshTopView
{
    self.nameLabel.text = [self.friendDictionary valueForKey:KEY_ACCOUNT_USER_NAME];
    self.cityLabel.text = [self.friendDictionary valueForKey:KEY_ACCOUNT_CITY];
    self.detailAddressLabel.text = [self.friendDictionary valueForKey:KEY_ACCOUNT_ADDRESS];
    self.levelLabel.text = [NSString stringWithFormat:@"LV %d",
                            [[self.friendDictionary valueForKey:KEY_ACCOUNT_LEVEL] intValue]];
    self.pointLabel.text = [NSString stringWithFormat:@"%@ %d",
                            NSLocalizedString(@"point", @"point"),
                            [[self.friendDictionary valueForKey:KEY_ACCOUNT_POINT] intValue]];
    self.phoneLabel.text = [self.friendDictionary valueForKey:KEY_ACCOUNT_PHONE];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    NSString * avatarImageUrl = [self.friendDictionary valueForKey:K_BSDK_PICTURE_65];
    if (avatarImageUrl && [avatarImageUrl length] > 0 ) {
        [imageView setImageWithURL:[NSURL URLWithString:avatarImageUrl] placeholderImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:self.friendDictionary]]];
    }
    else
    {
        [imageView setImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:self.friendDictionary]]];
    }
    
    CGRect borderImageViewFrame = CGRectMake(0,0, 
                                             self.avatarImageView.frame.size.width,
                                             self.avatarImageView.frame.size.height);
    BorderImageView * borderView = [[BorderImageView alloc]
                                        initWithFrame:borderImageViewFrame
                                        andView:imageView];
    [self.avatarImageView addSubview:borderView];
    [imageView release];
    [borderView release];
    NSString * isVerify = [self.friendDictionary objectForKey:K_BSDK_ISVERIFY];
    if (isVerify && [isVerify isEqual:K_BSDK_ISVERIFY_YES]) {
        [self.vMarkImageView setImage:[UIImage imageNamed:@"v_mark_big"]];
        [self.vMarkImageView setHidden:NO];
    }
    else
    {
        [self.vMarkImageView setHidden:YES];
    }
    
    NSString * relationship = [self.friendDictionary objectForKey:K_BSDK_RELATIONSHIP];
    NSString * genderImageName = [[self.friendDictionary valueForKey:K_BSDK_GENDER] isEqual:K_BSDK_GENDER_FEMALE] ? @"gender_female" : @"gender_male";
    self.genderImageView.image = [UIImage imageNamed:genderImageName];
    
    NSString * title = [[self.friendDictionary valueForKey:K_BSDK_GENDER] isEqual:K_BSDK_GENDER_FEMALE] ? @"her_home_page" : @"his_home_page";
    
    [self.navigationItem setTitle:NSLocalizedString(title, title)];
    
    if ([ViewHelper isSelf:[self.friendDictionary objectForKey:K_BSDK_UID]]) {
        [self.actionButton setHidden:YES];
    }
    else
    {
        NSString * buttonTitle = ([relationship isEqualToString:K_BSDK_RELATIONSHIP_MY_FOLLOW] || [relationship isEqualToString:K_BSDK_RELATIONSHIP_INTER_FOLLOW]) ? NSLocalizedString(@"unfollow", @"unfollow") : NSLocalizedString(@"follow", @"follow");
        
        [self.actionButton setTitle:buttonTitle forState:UIControlStateNormal];
        [self.actionButton setEnabled:YES];
    }
    
    if (![[BSDKManager sharedManager] isLogin]) {
        [self.actionButton setHidden:YES];
    }
}

@end
