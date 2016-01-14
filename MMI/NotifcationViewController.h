//
//  NotifcationViewController.h
//  MMI
//
//  Created by Shaikh Razak on 10/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "NotificationTableViewCell.h"

@interface NotifcationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *titleArray;
    NSMutableArray *dateArray;
    NSMutableArray *studioNameArray;
    NSMutableArray *addressArray;
}

@end
