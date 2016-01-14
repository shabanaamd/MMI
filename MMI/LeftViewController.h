//
//  LeftViewController.h
//  MMI
//
//  Created by Administrator on 21/10/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "BankDetailsVC.h"
#import "ViewController.h"
#import "AccountSettingsVC.h"
#import "NotifcationViewController.h"
#import "InterestViewController.h"
#import "BookingHistoryVC.h"

@interface LeftViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

{
    IBOutlet UITableView *tableVw;
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *loginLabel;
    
    NSArray *labelArray;
    NSArray *imageArray;
}

@end
