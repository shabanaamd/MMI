//
//  BankDetailsVC.h
//  MMI
//
//  Created by Shaikh Razak on 10/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface BankDetailsVC : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *cardNameField;
    IBOutlet UITextField *cardNumberField;
    IBOutlet UITextField *expiryDateField;
    IBOutlet UITextField *nameOnCardField;
    IBOutlet UIButton *saveButton;
    
}

-(IBAction)saveCardDetailsAction:(UIButton*)sender;

@end
