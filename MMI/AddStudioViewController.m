//
//  AddStudioViewController.m
//  MMI
//
//  Created by Shaikh Razak on 09/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "AddStudioViewController.h"

@interface AddStudioViewController ()

@end

@implementation AddStudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    if ([[UIScreen mainScreen]bounds].size.height == 1024)
        backBtn.frame = CGRectMake(0, 0, 40, 40);
    else
        backBtn.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -4;// it was -6 in iOS 6
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, backButton, nil] animated:NO];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleLabel.text = @"Add Studio Details";
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    
    // create effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = blurImageView.frame;
    // add the effect view to the image view
    // add vibrancy to yet another effect view
    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    UIVisualEffectView *vibrantView = [[UIVisualEffectView alloc]initWithEffect:vibrancy];
    effectView.frame = self.view.frame;
    [blurImageView addSubview:effectView];
    [blurImageView addSubview:vibrantView];
    
  //  bgScrollView.contentSize = CGSizeMake([[UIScreen mainScreen]bounds].size.width, registerButton.frame.origin.y + registerButton.frame.size.height + 60);
    
    registerButton.backgroundColor = [UIColor colorWithRed:30/255.0f green:144/255.0f blue:202/255.0f alpha:1.0];
    registerButton.layer.cornerRadius = 5.0;
    
    NSArray *textFieldsArray = [[NSArray alloc]initWithObjects:studioNameField, contactField, cityField,stateField, countryField, addressField, webLinkField, emailField, telephoneField, engineerField, timingField, wrokingDaysFileld, descFiled, nil];
    for (UITextField *tf in textFieldsArray) {
        
        tf.backgroundColor = [UIColor clearColor];
        CALayer *sideBorder1 = [CALayer layer];
        sideBorder1.backgroundColor = [[UIColor whiteColor] CGColor];
        sideBorder1.frame = CGRectMake(0, tf.frame.size.height-1, tf.frame.size.width, 0.5f);
        [tf.layer addSublayer:sideBorder1];
        
        [tf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        tf.leftView = paddingView1;
        tf.leftViewMode = UITextFieldViewModeAlways;
    }
    
    
    // Do any additional setup after loading the view.
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)registerAction:(UIButton *)sender {
}
@end
