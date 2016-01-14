//
//  AddStudioViewController.h
//  MMI
//
//  Created by Shaikh Razak on 09/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddStudioViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate>
{
    
    IBOutlet UIScrollView *bgScrollView;
    IBOutlet UITextField *studioNameField;
    IBOutlet UITextField *contactField;
    IBOutlet UITextField *cityField;
    IBOutlet UITextField *stateField;
    IBOutlet UITextField *countryField;
    IBOutlet UITextField *addressField;
    IBOutlet UITextField *webLinkField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *telephoneField;
    IBOutlet UITextField *engineerField;
    IBOutlet UITextField *timingField;
    IBOutlet UITextField *wrokingDaysFileld;
    
    IBOutlet UITextField *descFiled;
    IBOutlet UIButton *registerButton;
    IBOutlet UIImageView *blurImageView;
}
- (IBAction)registerAction:(UIButton *)sender;


@end
