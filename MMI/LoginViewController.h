//
//  LoginViewController.h
//  MMI
//
//  Created by Shaikh Razak on 26/10/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonClass.h"
//#import <linkedin-sdk/LISDK.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIImageView *bgImage;
    IBOutlet UITextField *userIDTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIButton *signInButton;
    IBOutlet UIButton *forgotPasswordButton;
    IBOutlet UIButton *FbButton;
//    IBOutlet UIButton *linkedInButton;
    IBOutlet UIButton *googleButton;
    IBOutlet UIButton *signUpButton;
//    IBOutlet UIButton *skipButton;
    UIActivityIndicatorView *activity;
    
}
- (IBAction)signInAction:(UIButton *)sender;
- (IBAction)signUpAction:(UIButton *)sender;
- (IBAction)skipButton:(UIButton *)sender;
-(IBAction)googleAction;
-(void)showActivity:(UIViewController*)VC frame:(CGRect)rect;
-(void)stopAnimating;

@end
