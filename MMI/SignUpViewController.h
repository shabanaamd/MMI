//
//  SignUpViewController.h
//  MMI
//
//  Created by Shaikh Razak on 26/10/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonClass.h"


@interface SignUpViewController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    IBOutlet UIImageView *BgImageView;
    IBOutlet UIImageView *profileImageView;
    IBOutlet UIView *textFieldsBGView;
    
    IBOutlet UITextField *addressField;
    IBOutlet UITextField *telephoneField;
    IBOutlet UITextField *genderField;
    IBOutlet UITextField *dobField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *userNameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *firstNameField;
    IBOutlet UIButton *signUpButton;
    IBOutlet UIScrollView *scrollView;
}
- (IBAction)signUpAction:(UIButton *)sender;
- (IBAction)backButtonAction:(UIButton *)sender;


@end
