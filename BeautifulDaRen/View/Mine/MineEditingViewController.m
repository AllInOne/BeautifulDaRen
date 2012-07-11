//
//  MineEditingViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/10/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "MineEditingViewController.h"
#import "MyInfoTopViewCell.h"
#import "ViewHelper.h"
#import "ButtonViewCell.h"
#import "EdittingViewController.h"
#import "SelectCityViewController.h"
#import "SegmentControl.h"
#import "iToast.h"
#import "ViewConstants.h"
#import "ModifyPasswordViewController.h"
#import "UIImage+Scale.h"
#import "BSDKDefines.h"
#import "BSDKManager.h"
#import "UIImageView+WebCache.h"

typedef enum
{
    SECTION_NICKNAME = 0,
    SECTION_MODIFYPASSWORD ,
    SECTION_CITY,
    SECTION_ADDRESS,
    SECTION_PHONE,
//    SECTION_SENIOR,
    SECTION_BRIEF,
    SECTION_COUNT
}SECTION_NAME;

@interface MineEditingViewController()
@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) NSMutableDictionary * tableViewDict;
@property (retain, nonatomic) UIImage * avatarImage;
@property (assign, nonatomic) UIButton * segmentedFirstButton;
@property (assign, nonatomic) UIButton * segmentedSecondButton;

- (void)startCameraAction;
@end
 
@implementation MineEditingViewController
@synthesize tableView = _tableView;
@synthesize tableViewDict = _tableViewDict;
@synthesize avatarImage = _avatarImage;
@synthesize segmentedFirstButton = _segmentedFirstButton;
@synthesize segmentedSecondButton = _segmentedSecondButton;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)onBackButtonClicked
{
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)onSaveButtonClicked
{
    if (![ViewHelper isDigitsString:[_tableViewDict objectForKey:KEY_ACCOUNT_PHONE]])
    {
        [[iToast makeText:NSLocalizedString(@"please_correct_phone", @"please_correct_phone")] show];
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: TRUE];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_SHOWWAITOVERLAY object:self];
    [[BSDKManager sharedManager] modifyUser:[ViewHelper getMyUserId] 
                                       name:[_tableViewDict objectForKey:KEY_ACCOUNT_USER_NAME]
                                     gender:[_tableViewDict objectForKey:KEY_ACCOUNT_GENDER]
                                      email:[_tableViewDict objectForKey:KEY_ACCOUNT_EMAIL]
                                    city:[_tableViewDict objectForKey:KEY_ACCOUNT_CITY]
                                        tel:[_tableViewDict objectForKey:KEY_ACCOUNT_PHONE] 
                                    address:[_tableViewDict objectForKey:KEY_ACCOUNT_ADDRESS]
                                description:[_tableViewDict valueForKey:KEY_ACCOUNT_INTRO]
                                     avatar:self.avatarImage 
                            andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: FALSE];
                                [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_HIDEWAITOVERLAY object:self];
                                [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
                                if(AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
                                {
                                    NSDictionary * dict = [data objectForKey:K_BSDK_USERINFO];
                                    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
                                }
                                
                            }];
    [self.avatarImage release];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:NSLocalizedString(@"edit_profile", @"edit_profile")];
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onSaveButtonClicked) title:NSLocalizedString(@"save", @"save")]];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
    _tableViewDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
    self.tableViewDict = nil;
    self.avatarImage = nil;
    self.segmentedFirstButton = nil;
    self.segmentedSecondButton = nil;
}
-(void)dealloc
{
    [super dealloc];
    [_tableView release];
    [_tableViewDict release];
    [_avatarImage release];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section) {
        case 0:
        case 1:
        {
            number = 1;
            break;
        }
        case 2:
        {
            number = SECTION_COUNT;
            break;
        }
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * infoTopViewIdentifier = @"MyInfoTopViewCell";
    static NSString * buttonViewCellIdentifier = @"ButtonViewCell";
    
    UITableViewCell * cell;
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:infoTopViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:infoTopViewIdentifier owner:self options:nil] objectAtIndex:1];
            
            UIImageView * imageView = [[UIImageView alloc] init];
            if (self.avatarImage) {
                [imageView setImage:self.avatarImage];
            }
            else
            {
                NSString * avatarUrl = [self.tableViewDict objectForKey:K_BSDK_PICTURE_65];
                if (avatarUrl && [avatarUrl length] > 0)
                {
                    [imageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:self.tableViewDict]]];
                }
                else
                {
                    [imageView setImage:[UIImage imageNamed:[ViewHelper getUserDefaultAvatarImageByData:self.tableViewDict]]];
                }            
            }
            CGRect borderImageViewFrame = CGRectMake(0,0, 
                                                     ((MyInfoTopViewCell*)cell).avatarImageView.frame.size.width,
                                                     ((MyInfoTopViewCell*)cell).avatarImageView.frame.size.height);
            BorderImageView * tempBorderView = [[BorderImageView alloc]
                                                initWithFrame:borderImageViewFrame
                                                andView:imageView];
            [((MyInfoTopViewCell*)cell).avatarImageView addSubview:tempBorderView];
            [imageView release];
            [tempBorderView release];

            [((MyInfoTopViewCell*)cell).updateAvatarButton addTarget:self action:@selector(onUpdataAvatarPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else if(section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:5];
        }
        ButtonViewCell * buttonViewCell = (ButtonViewCell*)cell;
        buttonViewCell.leftLabel.text = NSLocalizedString(@"gender", @"gender");

        NSInteger index = [[_tableViewDict valueForKey:K_BSDK_GENDER] isEqualToString:K_BSDK_GENDER_MALE] ? 1 : 0;
        SegmentControl * seg = [[SegmentControl alloc]
                                initWithFrame:CGRectMake(65, 8, 112, 29)
                                leftText:NSLocalizedString(@"female", @"gender")
                                rightText:NSLocalizedString(@"male", @"gender")
                                selectedIndex:index];
        
        [buttonViewCell addSubview:seg];
        [seg.firstButton addTarget:self action:@selector(onSegementButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [seg.secondButton addTarget:self action:@selector(onSegementButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        _segmentedFirstButton = seg.firstButton;
        _segmentedSecondButton = seg.secondButton;
        [seg release];
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:3];
        }
        ButtonViewCell * buttonViewCell = (ButtonViewCell*)cell;
        switch ([indexPath row]) {
            case SECTION_NICKNAME:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"nickname", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:KEY_ACCOUNT_USER_NAME];
                break;
            }
            case SECTION_MODIFYPASSWORD:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"modify_password", @"");
                buttonViewCell.leftLabel.frame = CGRectMake(buttonViewCell.leftLabel.frame.origin.x,
                                                            buttonViewCell.leftLabel.frame.origin.y,
                                                            [ViewHelper getWidthOfText:buttonViewCell.leftLabel.text ByFontSize:buttonViewCell.leftLabel.font.pointSize],
                                                            buttonViewCell.leftLabel.frame.size.height);
                buttonViewCell.buttonText.text =@"";
                buttonViewCell.buttonText.frame = CGRectZero;
                break;
            }
            case SECTION_CITY:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"city", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:KEY_ACCOUNT_CITY];
                break;
            }
            case SECTION_ADDRESS:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"address", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:KEY_ACCOUNT_ADDRESS];
                break;
            }
            case SECTION_PHONE:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"phone", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:KEY_ACCOUNT_PHONE];
                break;
            }
//            case SECTION_SENIOR:
//            {
//                buttonViewCell.leftLabel.text = NSLocalizedString(@"senior", @"");
//                buttonViewCell.buttonText.text = @"高级内容";
//                break;
//            } 
            case SECTION_BRIEF:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"brief", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:KEY_ACCOUNT_INTRO];
                break;
            } 
        }
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    NSInteger section = [indexPath section];
    switch (section) {
        case 0:
        {
            height = 72.0f;
            break;
        }
        case 1:
        {
            height = 40.0f;
            break;
        }
        case 2:
        {
            height = 40.0f;
            break;
        }    }
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    if(section == 2)
    {
        NSInteger type = 0;
        NSInteger row = [indexPath row];
        
        if(row == SECTION_MODIFYPASSWORD)
        {
            ModifyPasswordViewController *modifiyPasswordViewController = 
            [[ModifyPasswordViewController alloc] initWithNibName:nil bundle:nil];
            
            UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: modifiyPasswordViewController];
            
            [self.navigationController presentModalViewController:navController animated:YES];
            
            [navController release];
            [modifiyPasswordViewController release];
        }
        else if(row == SECTION_CITY)
        {
            SelectCityViewController *citySelectionController = 
            [[SelectCityViewController alloc] initWithNibName:nil bundle:nil];
            
            UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: citySelectionController];
            citySelectionController.delegate = self;
            
            [self.navigationController presentModalViewController:navController animated:YES];
            
            [navController release];
            [citySelectionController release];
        }
        else {
            EditDoneBlock block = nil;
            NSString * placeholderString = nil;
            
//            if(row == SECTION_SENIOR)
//            {
//                type = EdittingViewController_type1;
//                
//            }
//            else
            {
                type = EdittingViewController_type0;
                switch (row) {
                    case SECTION_NICKNAME:
                    {
                        placeholderString = [_tableViewDict objectForKey:KEY_ACCOUNT_USER_NAME];
                        block = ^(NSString * text)
                        {
                            [_tableViewDict setValue:text
                                              forKey:KEY_ACCOUNT_USER_NAME];
                            [self.tableView reloadData];
                        };
                        break;
                    }
                    case SECTION_ADDRESS:
                    {
                        placeholderString = [_tableViewDict objectForKey:KEY_ACCOUNT_ADDRESS];
                        block = ^(NSString * text)
                        {
                            [_tableViewDict setValue:text
                                              forKey:KEY_ACCOUNT_ADDRESS];
                            [self.tableView reloadData];
                        };
                        break;
                    }
                    case SECTION_PHONE:
                    {
                        placeholderString = [_tableViewDict objectForKey:KEY_ACCOUNT_PHONE];
                        block = ^(NSString * text)
                        {
                            [_tableViewDict setValue:text
                                              forKey:KEY_ACCOUNT_PHONE];
                            [self.tableView reloadData];
                        };
                        break;
                    }
                    case SECTION_BRIEF:
                    {
                        placeholderString = [_tableViewDict objectForKey:KEY_ACCOUNT_INTRO];
                        block = ^(NSString * text)
                        {
                            [_tableViewDict setValue:text
                                              forKey:KEY_ACCOUNT_INTRO];
                            [self.tableView reloadData];
                        };
                        break;
                    }
                }
            }
            EdittingViewController * edittingViewController = [[EdittingViewController alloc]
                                                               initWithNibName:@"EdittingViewController" 
                                                               bundle:nil
                                                               type:type
                                                               block:block];
            edittingViewController.placeholderString = placeholderString;
            [self.navigationController pushViewController:edittingViewController animated:YES];
            [edittingViewController release];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (void) genderSelected:(UISegmentedControl*)segmentedControl
{
    [ViewHelper showSimpleMessage:@"你修改了性别" withTitle:nil withButtonText:@"好"];
}

-(IBAction)onSegementButtonPressed:(UIButton*)sender
{
    NSString * gender = (sender == self.segmentedFirstButton) ? K_BSDK_GENDER_FEMALE : K_BSDK_GENDER_MALE;
    [_tableViewDict setValue:gender
                      forKey:KEY_ACCOUNT_GENDER];
}

#pragma mark SelectCityProtocol
- (void)onCitySelected:(NSString*)city
{
    [_tableViewDict setValue:city
                      forKey:KEY_ACCOUNT_CITY];
    [self.tableView reloadData];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet destructiveButtonIndex])
    {
        switch (actionSheet.tag)
        {
            case ACTIONSHEET_IMAGE_PICKER:
            {
                NSString *pressed = [actionSheet buttonTitleAtIndex:buttonIndex];
                
                if ([pressed isEqualToString:IMAGE_PICKER_CAMERA])
                {
                    UIImagePickerController * imagePicker = [APPDELEGATE getImagePicker];
                    
                    [imagePicker setDelegate: self];
                    [imagePicker setSourceType: UIImagePickerControllerSourceTypeCamera];
                    
                    [self presentModalViewController:imagePicker animated:YES];
                    
                }
                else if ([pressed isEqualToString:IMAGE_PICKER_LIBRARY])
                {
                    UIImagePickerController * imagePicker = [APPDELEGATE getImagePicker];
                    
                    [imagePicker setDelegate: self];
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    
                    [self presentModalViewController:imagePicker animated:YES];
                }
                else if ([pressed isEqualToString:IMAGE_PICKER_DELETE])
                {
                    // TODO:
                }
            }
            default:
                break;
        }
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissModalViewControllerAnimated:NO];

    self.avatarImage = [image scaleToSize:CGSizeMake(320.0, image.size.height * 320.0/image.size.width)];
    [self.tableView reloadData];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)startCameraAction
{
    UIActionSheet * imagePickerActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                         delegate:self
                                                                cancelButtonTitle:nil
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:nil];
    
    imagePickerActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    imagePickerActionSheet.tag = ACTIONSHEET_IMAGE_PICKER;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
        {
            [imagePickerActionSheet addButtonWithTitle:IMAGE_PICKER_CAMERA];        
        }
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [imagePickerActionSheet addButtonWithTitle:IMAGE_PICKER_LIBRARY];
    }
    
    if ([imagePickerActionSheet numberOfButtons] > 0)
    {
        [imagePickerActionSheet setDestructiveButtonIndex:[imagePickerActionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"cancel")]];
        [imagePickerActionSheet showInView:self.view];
    }
    
    [imagePickerActionSheet release];
}

- (IBAction)onUpdataAvatarPressed:(UIButton*)sender
{
    [self startCameraAction];
}

@end
