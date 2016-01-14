//
//  AccountSettingsVC.m
//  MMI
//
//  Created by Shaikh Razak on 10/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "AccountSettingsVC.h"

@interface AccountSettingsVC ()
{
    LoginViewController *login;
}
@end

@implementation AccountSettingsVC
@synthesize isNotificaionOn, isAlertOn;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Account Settings";

    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateNormal];
    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:rightBarButtonItem, nil] animated:NO];
    
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0];

    textFieldsArray = [[NSArray alloc]initWithObjects:userNameField, passwordField, emailField, phoneField, nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)updateSettings{
    
//    NSArray *arrayKey = [[NSArray alloc]initWithObjects:@"Customer_ID", @"Mobile",@"Customer_Name",@"Email",@"DOB",@"Address",@"Gender",@"Password", nil];    
//    NSArray *arrayObject = [[NSArray alloc]initWithObjects:emailAddressField.text,@"", @"false", nil];
//    
//    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:arrayObject forKeys:arrayKey];
//    [SingletonClass executeMultipart:[NSURL URLWithString:@"http://www.atcommobitech.in/MMIwebapi/API/Validate"] dict:questionDict withCompletionHandler:^(NSDictionary* dict){
//        
//        if ([[dict valueForKey:@"Result"] isEqualToString:@"Failure"]){
//            [SingletonClass showAlert:[dict valueForKey:@"Message"] title:[dict valueForKey:@"Result"] view:self];
//        }else{
//            [SingletonClass showAlert:[dict valueForKey:@"Message"] title:[dict valueForKey:@"Result"] view:self];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        [login stopAnimating];
//    }];
}


- (IBAction)switchAction:(UISwitch *)sender {
    if (sender.tag == 0) {
        if ([sender isOn]) {
            isNotificaionOn = YES;
        }else
            isNotificaionOn = NO;
    }else{
        if ([sender isOn])
            isAlertOn = YES;
        else
            isAlertOn = NO;
    }
}

- (IBAction)editPersonalDetailsAction:(UIButton *)sender {

    for (UITextField *tf in textFieldsArray) {
        tf.userInteractionEnabled = YES;
    }
    [userNameField becomeFirstResponder];
}


@end















