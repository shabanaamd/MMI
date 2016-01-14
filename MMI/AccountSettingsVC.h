//
//  AccountSettingsVC.h
//  MMI
//
//  Created by Shaikh Razak on 10/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "SingletonClass.h"
#import "LoginViewController.h"

@interface AccountSettingsVC : UIViewController<UITextFieldDelegate, UIScrollViewDelegate>
{
    IBOutlet UIView *alertBgView;
    IBOutlet UIView *notificationBgView;
    IBOutlet UIView *notifsSwitch;
    IBOutlet UISwitch *alertSwitch;
    IBOutlet UIButton *editDetailsButton;
    IBOutlet UITextField *userNameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *phoneField;
    IBOutlet UIScrollView *bgScrollView;
    NSArray *textFieldsArray;
}

@property(nonatomic, assign)BOOL isNotificaionOn;
@property(nonatomic, assign)BOOL isAlertOn;


- (IBAction)switchAction:(UISwitch *)sender;
- (IBAction)editPersonalDetailsAction:(UIButton *)sender;


@end
