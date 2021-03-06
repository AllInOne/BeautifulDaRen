//
//  WeiboComposerViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboComposerViewController.h"
#import "FriendsSelectionViewController.h"
#import "ViewHelper.h"
#import "ViewConstants.h"
#import "TakePhotoViewController.h"
#import "SinaSDKManager.h"
#import "UIImage+Scale.h"
#import "BSDKManager.h"
#import "BSDKDefines.h"
#import "iToast.h"
#import "LocationHelper.h"

#define WEIBO_CONTENT_TEXTVIEW_Y_OFFSET (90.0)
#define WEIBO_CONTENT_TEXTVIEW_MARGIN   (2.0)
#define WEIBO_CONTENT_SCROLL_BOUNCE_SIZE   (30.0)

#define LOCATION_ACTIVITY_Y_OFFSET     (25.0)
#define LOCATION_ACTIVITY_X_OFFSET     (10.0)

@interface WeiboComposerViewController ()
@property (nonatomic, assign) BOOL isKeypadShow;
@property (nonatomic, retain) CLLocation * currentLocation;
@property (nonatomic, retain) NSString * locationString;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSArray * categories;

- (void)setContentFrame:(CGRect)frame;
- (void)startSelectCategoryViewWithData:(NSArray*)categories;
@end

@implementation WeiboComposerViewController

@synthesize footerView = _footerView;
@synthesize weiboContentTextView = _weiboContentTextView;
@synthesize maketTextView = _maketTextView;
@synthesize brandTextView = _brandTextView;
@synthesize weiboContentBgTextFiled = _weiboContentBgTextFiled;
@synthesize contentScrollView = _contentScrollView;
@synthesize attachedImageBgButton = _attachedImageBgButton;
@synthesize selectedImage = _selectedImage;
@synthesize isKeypadShow = _isKeypadShow;
@synthesize sinaButton = _sinaButton;
@synthesize sinaShareImageView = _sinaShareImageView;
@synthesize priceTextView = _priceTextView;
@synthesize locationButton = _locationButton;
@synthesize atButton = _atButton;
@synthesize categoryButton = _categoryButton;
@synthesize locationLoadingView =_locationLoadingView;
@synthesize currentLocation = _currentLocation;
@synthesize locationString = _locationString;
@synthesize category = _category;
@synthesize categories = _categories;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _attachedImageBgButton.enabled = NO;

        [_weiboContentTextView setDelegate:self];

        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];

        [self.navigationItem setTitle:NSLocalizedString(@"tab_myshow", @"tab_myshow")];

        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onSendButtonClicked) title:NSLocalizedString(@"send", @"send")]];
    }
    return self;
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

    [_maketTextView becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self setContentFrame:CGRectMake(_weiboContentBgTextFiled.frame.origin.x, WEIBO_CONTENT_TEXTVIEW_Y_OFFSET, _weiboContentBgTextFiled.frame.size.width, _weiboContentTextView.frame.size.height)];

    [_contentScrollView setContentSize:CGSizeMake(_weiboContentTextView.frame.size.width, WEIBO_CONTENT_TEXTVIEW_Y_OFFSET + _weiboContentTextView.frame.size.height + WEIBO_CONTENT_SCROLL_BOUNCE_SIZE)];

    [_weiboContentTextView setDelegate:self];

    if (self.selectedImage != nil)
    {
        [self.attachedImageBgButton setImage:self.selectedImage forState:UIControlStateNormal];
    }

    UIImageView * toolbarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_background"]];
    toolbarBg.contentMode = UIViewContentModeScaleToFill;
    [self.footerView  insertSubview:toolbarBg atIndex:0];

    [toolbarBg release];

    if ([[SinaSDKManager sharedManager] isLogin])
    {
        [self.sinaButton setImage:[UIImage imageNamed:@"myshow_sina_color"] forState:UIControlStateNormal];
    }
    else
    {
        [self.sinaButton setImage:[UIImage imageNamed:@"myshow_sina_gray"] forState:UIControlStateNormal];
        [self.sinaShareImageView setHidden:YES];
    }

    _locationLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_locationLoadingView setHidden:YES];

    [self.view addSubview:_locationLoadingView];

//    [self.atButton setEnabled:NO];
//    [self.locationButton setEnabled:NO];
//    [self.categoryButton setEnabled:NO];

     NSLog(@"weibo composer view load");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setFooterView:nil];
    [self setBrandTextView:nil];
    [self setWeiboContentTextView:nil];
    [self setWeiboContentBgTextFiled:nil];
    [self setContentScrollView:nil];
    [self setMaketTextView:nil];
    [self setSinaButton:nil];
    [self setSinaShareImageView:nil];
    [self setPriceTextView:nil];
    [self setLocationButton:nil];
    [self setAtButton:nil];
    [self setCategoryButton:nil];
    [self setAttachedImageBgButton:nil];
    [self setLocationLoadingView:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSLog(@"weibo composer view unload");
}

- (void)dealloc
{
    [_footerView release];
    [_weiboContentTextView release];
    [_maketTextView release];
    [_brandTextView release];

    [_weiboContentBgTextFiled release];
    [_contentScrollView release];

    [_selectedImage release];
    [_sinaButton release];
    [_sinaShareImageView release];
    [_priceTextView release];
    [_atButton release];
    [_locationButton release];
    [_categoryButton release];
    [_attachedImageBgButton release];
    [_locationLoadingView release];
    [_currentLocation release];
    [_locationString release];
    [_category release];
    [_categories release];

    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITextView delegate for content view

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    [self.atButton setEnabled:YES];
//    [self.locationButton setEnabled:YES];
//    [self.categoryButton setEnabled:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    [self.atButton setEnabled:NO];
//    [self.locationButton setEnabled:NO];
//    [self.categoryButton setEnabled:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([[textView text] length] - range.length + text.length > TEXT_VIEW_MAX_CHARACTOR_NUMBER) {
        return NO;
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)note
{
    if (!self.isKeypadShow)
    {
        NSDictionary *info = [note userInfo];

        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        double animDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

        [UIView animateWithDuration:animDuration animations:^
         {
             [self setContentFrame: CGRectMake(self.weiboContentTextView.frame.origin.x,
                                               WEIBO_CONTENT_TEXTVIEW_Y_OFFSET,
                                               self.weiboContentTextView.frame.size.width,
                                               self.weiboContentTextView.frame.size.height - kbSize.height)];

             self.footerView.center = CGPointMake(self.footerView.center.x,
                                                  self.footerView.center.y - kbSize.height);
         }];

        self.contentScrollView.frame = CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height - kbSize.height);

        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.contentSize.width, self.contentScrollView.contentSize.height - kbSize.height);
        self.isKeypadShow = YES;
    }

}

- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isKeypadShow)
    {
        NSDictionary *info = [note userInfo];

        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        double animDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

        [UIView animateWithDuration:animDuration animations:^
         {
             [self setContentFrame:CGRectMake(self.weiboContentTextView.frame.origin.x,
                                              self.weiboContentTextView.frame.origin.y,
                                              self.weiboContentTextView.frame.size.width,
                                              self.weiboContentTextView.frame.size.height + kbSize.height)];

             self.footerView.center = CGPointMake(self.footerView.center.x,
                                                  self.footerView.center.y + kbSize.height);
         }];

        self.contentScrollView.frame = CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height + kbSize.height);

        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.contentSize.width, self.contentScrollView.contentSize.height + kbSize.height);
        self.isKeypadShow = NO;
    }
}

- (void)setContentFrame:(CGRect)frame
{
    self.weiboContentTextView.frame = frame;

    self.weiboContentBgTextFiled.frame = CGRectMake(frame.origin.x - WEIBO_CONTENT_TEXTVIEW_MARGIN, frame.origin.y - WEIBO_CONTENT_TEXTVIEW_MARGIN, frame.size.width + 2 * WEIBO_CONTENT_TEXTVIEW_MARGIN, frame.size.height + 2 * WEIBO_CONTENT_TEXTVIEW_MARGIN);
}

- (void)onBackButtonClicked {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"prompt")
                                                    message:NSLocalizedString(@"composer_back_confirmation", @"composer_back_confirmation")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                          otherButtonTitles:NSLocalizedString(@"confirm", @"confirm"), nil];
    alert.tag = TAG_ALERTVIEW_BACK_CONFIRM;

    [alert show];
    [alert release];

    return;
}

- (void)onSendButtonClicked {
    if ([self.weiboContentTextView.text length] == 0) {
        [ViewHelper showSimpleMessage:NSLocalizedString(@"please_enter_content", @"please_enter_content") withTitle:nil withButtonText:NSLocalizedString(@"ok", @"ok")];
        return;
    }

    if ([self.maketTextView.text length] == 0) {
        [ViewHelper showSimpleMessage:NSLocalizedString(@"please_enter_merchant", @"please_enter_merchant") withTitle:nil withButtonText:NSLocalizedString(@"ok", @"ok")];
        return;
    }

    if ([self.brandTextView.text length] == 0) {
        [ViewHelper showSimpleMessage:NSLocalizedString(@"please_enter_brand", @"please_enter_brand") withTitle:nil withButtonText:NSLocalizedString(@"ok", @"ok")];
        return;
    }

    if ([self.priceTextView.text length] == 0) {
        [ViewHelper showSimpleMessage:NSLocalizedString(@"please_enter_price", @"please_enter_price") withTitle:nil withButtonText:NSLocalizedString(@"ok", @"ok")];
        return;
    }

    if ( (self.category == nil) || ([self.category length] == 0)) {
        [ViewHelper showSimpleMessage:NSLocalizedString(@"please_enter_category", @"please_enter_category") withTitle:nil withButtonText:NSLocalizedString(@"ok", @"ok")];
        return;
    }

    if (self.selectedImage == nil) {
        [ViewHelper showSimpleMessage:NSLocalizedString(@"please_enter_photo", @"please_enter_photo") withTitle:nil withButtonText:NSLocalizedString(@"ok", @"ok")];
        return;
    }

    [self dismissModalViewControllerAnimated:YES];

    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_SHOWWAITOVERLAY object:self];

    __block NSInteger doneCount = 0;
    __block NSInteger doneCountExpected = 1;
    __block NSString * errorMsg = nil;

    processDoneWithDictBlock doneBlock = ^(AIO_STATUS status, NSDictionary * data){
        doneCount++;
        if (doneCount == doneCountExpected) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: FALSE];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_HIDEWAITOVERLAY object:self];
            if ([data objectForKey:K_BSDK_RESPONSE_STATUS] && !K_BSDK_IS_RESPONSE_OK(data)) {
                errorMsg = K_BSDK_GET_RESPONSE_MESSAGE(data);
            }

            if (errorMsg == nil)
            {
                [ViewHelper showSimpleMessage:NSLocalizedString(@"send_succeed", @"send_succeed") withTitle:nil withButtonText:NSLocalizedString(@"ok", @"ok")];
            }
            else
            {
                [ViewHelper showSimpleMessage:errorMsg withTitle:nil withButtonText:NSLocalizedString(@"ok", @"ok")];
            }
        }

    };

    double latitude = 0.0;
    double longitude = 0.0;
    if (self.currentLocation) {
        latitude = self.currentLocation.coordinate.latitude;
        longitude = self.currentLocation.coordinate.longitude;
    }
    
    if (!self.sinaShareImageView.hidden && [[SinaSDKManager sharedManager] isLogin])
    {
        NSString * syncContent = nil;
        if ([self.priceTextView.text intValue] != 0)
        {
            syncContent = [NSString stringWithFormat:@"商场: @%@ 品牌: @%@ 标价: ¥%@ %@", self.maketTextView.text, self.brandTextView.text, self.priceTextView.text, self.weiboContentTextView.text];
        }
        else
        {
            syncContent = [NSString stringWithFormat:@"商场: @%@ 品牌: @%@ %@", self.maketTextView.text, self.brandTextView.text, self.weiboContentTextView.text];
        }

        [[SinaSDKManager sharedManager] sendWeiBoWithText:syncContent image:[self.selectedImage scaleToSize:CGSizeMake(320.0, self.selectedImage.size.height * 320.0/self.selectedImage.size.width)] latitude:latitude longitude:longitude doneCallback:doneBlock];
        doneCountExpected++;
    };

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: TRUE];
    [[BSDKManager sharedManager] sendWeiboWithText:self.weiboContentTextView.text
                                            image:[self.selectedImage scaleToSize:CGSizeMake(320.0, self.selectedImage.size.height * 320.0/self.selectedImage.size.width)]
                                             shop:self.maketTextView.text
                                            brand:self.brandTextView.text
                                            price:[self.priceTextView.text intValue]
                                         category:self.category
                                      poslatitude:latitude
                                     posLongitude:longitude
                                     doneCallback:doneBlock];
}

- (IBAction)onPickedImagePressed:(id)sender
{
    [self onImagePickerPressed:sender];
}

- (IBAction)onImagePickerPressed:(id)sender
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
            [imagePickerActionSheet addButtonWithTitle:IMAGE_PICKER_CAMERA];
    }

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        [imagePickerActionSheet addButtonWithTitle:IMAGE_PICKER_LIBRARY];

//    if (self.messageImage.image)
//        [imagePickerActionSheet addButtonWithTitle:IMAGE_PICKER_DELETE];

    if ([imagePickerActionSheet numberOfButtons] > 0)
    {
        [imagePickerActionSheet setDestructiveButtonIndex:[imagePickerActionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"cancel")]];
        [imagePickerActionSheet showInView:self.view];
    }

    [imagePickerActionSheet release];
}

- (IBAction)onAtFriendPressed:(id)sender
{
//    [self.atButton setEnabled:NO];
//    [[BSDKManager sharedManager] getFollowList:GET_CURRENT_USER_INFO_BY_KEY(K_BSDK_UID) pageSize:50 pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//
//        NSArray * userList = [data objectForKey:K_BSDK_USERLIST];
//        NSMutableArray * friendList = [NSMutableArray arrayWithCapacity:[userList count]];
//
//        for(NSDictionary * user in userList)
//        {
//            [friendList addObject:[[user objectForKey:K_BSDK_ATTENTIONUSERINFO] objectForKey:K_BSDK_USERNAME]];
//        }
//
//        FriendsSelectionViewController *friendSelectionController =
//        [[FriendsSelectionViewController alloc] initWithNibName:nil bundle:nil];
//        friendSelectionController.delegate = self;
//        friendSelectionController.friendsList = friendList;
//        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: friendSelectionController];
//
//        [self.navigationController presentModalViewController:navController animated:YES];
//
//        [navController release];
//        [friendSelectionController release];
//
//        [self.atButton setEnabled:YES];
//    }];
    FriendsSelectionViewController *friendSelectionController =
    [[FriendsSelectionViewController alloc] initWithNibName:nil bundle:nil];
    friendSelectionController.delegate = self;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: friendSelectionController];

    [self.navigationController presentModalViewController:navController animated:YES];

    [navController release];
    [friendSelectionController release];
}

- (IBAction)onLocationPressed:(id)sender
{
    if (self.currentLocation) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"prompt")
                                                        message:NSLocalizedString(@"clear_location", @"clear_location")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                              otherButtonTitles:NSLocalizedString(@"clear", @"clear"), nil];
        alert.tag = TAG_ALERTVIEW_CLEAR_LOCATION;

        [alert show];
        [alert release];

        return;
    }

    [self.locationLoadingView setHidden:NO];
    [self.locationLoadingView setFrame:CGRectMake(LOCATION_ACTIVITY_X_OFFSET, self.footerView.frame.origin.y - LOCATION_ACTIVITY_Y_OFFSET, CGRectGetWidth(self.locationLoadingView.frame), CGRectGetHeight(self.locationLoadingView.frame))];
    [self.locationLoadingView startAnimating];

    [[LocationHelper sharedManager] getCurrentLocationWithDoneCallbck:^(NSError *error, CLLocation *location, MKPlacemark *placeMark) {
        NSLog(@"%@, %@, %@", error, location, placeMark);
        if ((error == nil) || ((location != nil) && placeMark && (placeMark.locality != nil) && (placeMark.thoroughfare != nil))) {
            _locationString = nil;

            self.locationString = [NSString stringWithFormat:@"%@#%@,%@＃ ", NSLocalizedString(@"i_am_here", @"i_am_here"), placeMark.locality, placeMark.thoroughfare];
            self.weiboContentTextView.text = [self.weiboContentTextView.text stringByAppendingString: _locationString];

            _currentLocation = nil;
            self.currentLocation = location;
        }
        else
        {
            [ViewHelper showSimpleMessage:NSLocalizedString(@"get_location_falied", @"get_location_falied") withTitle:NSLocalizedString(@"prompt", @"prompt") withButtonText:NSLocalizedString(@"cancel", @"cancel")];
        }

        [self.locationLoadingView stopAnimating];
        [self.locationButton setEnabled:YES];
        [self.locationLoadingView setHidden:YES];
    }];
    [self.locationButton setEnabled:NO];
}

- (IBAction)onTraderPressed:(id)sender
{
    //TODO:
}

- (void)startSelectCategoryViewWithData:(NSArray*)categories
{
    CategorySelectViewController *categorySelectionController =
    [[CategorySelectViewController alloc] initWithNibName:nil bundle:nil];
    categorySelectionController.delegate = self;
    categorySelectionController.initialSelectedCategoryId = self.category;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: categorySelectionController];

    [self.navigationController presentModalViewController:navController animated:YES];

    [navController release];
    [categorySelectionController release];
}

- (IBAction)onCategoryPressed:(id)sender
{
    [self startSelectCategoryViewWithData:self.categories];
}

- (IBAction)onSinaPressed:(id)sender
{
    if (![[SinaSDKManager sharedManager] isLogin])
    {
        [[SinaSDKManager sharedManager] setRootviewController:self.navigationController];
        [[SinaSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
            NSLog(@"Sina SDK login done, status:%d", status);
            [self.sinaButton setImage:[UIImage imageNamed:@"myshow_sina_color"] forState:UIControlStateNormal];
            [self.sinaShareImageView setHidden:NO];
        }];
    }
    else
    {
        [self.sinaShareImageView setHidden:(self.sinaShareImageView.hidden ? NO : YES)];
    }
}

- (void)didFinishContactSelectionWithContacts:(NSString *)friendId
{
    self.weiboContentTextView.text = [self.weiboContentTextView.text stringByAppendingString: [NSString stringWithFormat:@"@%@ ", friendId]];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TAG_ALERTVIEW_CLEAR_LOCATION) {
        switch (buttonIndex) {
            case 1:
                self.weiboContentTextView.text = [self.weiboContentTextView.text stringByReplacingOccurrencesOfString:_locationString withString:@""];
                self.currentLocation = nil;
                self.locationString = nil;
                break;
            default:
                break;
        }
    }
    else if (alertView.tag == TAG_ALERTVIEW_BACK_CONFIRM)
    {
        switch (buttonIndex) {
            case 1:
                if (![self.navigationController popViewControllerAnimated:YES])
                {
                    [self dismissModalViewControllerAnimated:YES];
                }
                break;
            default:
                break;
        }
    }
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
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];

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

#pragma mark - UIImagePickerControllerDelegate/UINavigationControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (self.selectedImage)
    {
        [self.attachedImageBgButton setImage:self.selectedImage forState:UIControlStateNormal];
    }

    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - select category delegate
- (void)onCategorySelected:(NSArray*)categories
{
    [self setCategory:nil];
    self.category = [categories objectAtIndex:0];
}

@end
