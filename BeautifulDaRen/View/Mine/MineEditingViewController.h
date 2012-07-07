//
//  MineEditingViewController.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/10/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCityViewController.h"
#import "TakePhotoViewController.h"

@interface MineEditingViewController
: UIViewController <UITableViewDelegate, UITableViewDataSource, SelectCityProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@end
