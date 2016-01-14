//
//  BankDetailsVC.m
//  MMI
//
//  Created by Shaikh Razak on 10/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "BankDetailsVC.h"

@interface BankDetailsVC ()

@end

@implementation BankDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateNormal];
    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //[SlideNavigationController sharedInstance].leftBarButtonItem = rightBarButtonItem;
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    
//    UIButton *logoView = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
//    [logoView setBackgroundImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
//    [logoView setUserInteractionEnabled:NO];
//    self.navigationItem.titleView = logoView;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:rightBarButtonItem, nil] animated:NO];
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"Shabana" forState:UIControlStateNormal];
    [[loginBtn titleLabel] setFont:[UIFont fontWithName:@"System" size:11]];
    //[loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.frame = CGRectMake(0, 0, 80, 35);
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithCustomView:loginBtn] ;
    [self.navigationItem setRightBarButtonItem:loginButton];
    
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0];
    
    NSArray *array = [[NSArray alloc]initWithObjects:cardNameField, cardNumberField, expiryDateField, nameOnCardField, nil];
    for (UITextField *tf in array) {
       
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        tf.leftView = paddingView1;
        tf.leftViewMode = UITextFieldViewModeAlways;
    }
    saveButton.backgroundColor = [UIColor colorWithRed:30/255.0f green:144/255.0f blue:202/255.0f alpha:1.0];
    saveButton.layer.cornerRadius = 5.0;
    
    // Do any additional setup after loading the view.
}

-(void)goback{
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
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

@end
