//
//  ForgotPasswordVC.h
//  MMI
//
//  Created by PMAM IT Services on 11/01/16.
//  Copyright © 2016 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonClass.h"
#import "LoginViewController.h"

@interface ForgotPasswordVC : UIViewController

{
    
    __weak IBOutlet UIImageView *bgImage;
    __weak IBOutlet UITextField *emailAddressField;
    __weak IBOutlet UIButton *sendButton;
}
- (IBAction)sendAction:(UIButton *)sender;
- (IBAction)backButton:(UIButton *)sender;

@end
