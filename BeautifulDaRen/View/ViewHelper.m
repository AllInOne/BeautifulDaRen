//
//  ViewHelper.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/26/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ViewHelper.h"

#import "ButtonViewCell.h"

@implementation ViewHelper

+(UITableViewCell*) getLoginWithExtenalViewCellInTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonViewCell"];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ButtonViewCell" owner:self options:nil] objectAtIndex:0];
    }
    switch ([indexPath row]) {
        case 0:
        {
            // sina weibo
            ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"login_with_sina_weibo", @"You are not user, please register");
            ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"first"]; 
            ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"second"]; 
            break;
        } 
        case 1:
        {
            // tencent weibo
            ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"login_with_tencent_qq", @"You are not user, please register");
            ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"first"]; 
            ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"second"]; 
            break;
        }
    }
    return cell;
}

@end
