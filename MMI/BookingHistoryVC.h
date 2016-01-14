//
//  BookingHistoryVC.h
//  MMI
//
//  Created by PMAM IT Services on 11/01/16.
//  Copyright © 2016 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "LoginViewController.h"
#import "BookingHistoryCell.h"

@interface BookingHistoryVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *bookingsTable;
    
    NSUInteger totalBookings;
}
@end
