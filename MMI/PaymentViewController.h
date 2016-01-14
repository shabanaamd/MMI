//
//  PaymentViewController.h
//  MMI
//
//  Created by Administrator on 02/12/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "LoginViewController.h"

@interface PaymentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *paymentOptionsTableView;
    IBOutlet UIView *topView;
    IBOutlet UIView *paymentLabel;
    IBOutlet UILabel *totalAmountPayableLabel;
    IBOutlet NSLayoutConstraint *nonRefundableLabel;
    IBOutlet UILabel *totalPayableValueLabel;
    IBOutlet UIView *payableBgView;
    
    NSMutableArray *cellArray;
    
}

@property(nonatomic, strong)NSString *bookedDateString;
@property(nonatomic, strong)NSString *timeSlotString;
@property(nonatomic, strong)NSString *totalHoursString;

@end
