//
//  ForgotPasswordVC.m
//  MMI
//
//  Created by PMAM IT Services on 11/01/16.
//  Copyright © 2016 AtcomMobiTech. All rights reserved.
//

#import "ForgotPasswordVC.h"

@interface ForgotPasswordVC ()
{
    LoginViewController *login;
}
@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    
    // create effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = bgImage.frame;
    // add the effect view to the image view
    // add vibrancy to yet another effect view
    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    UIVisualEffectView *vibrantView = [[UIVisualEffectView alloc]initWithEffect:vibrancy];
    effectView.frame = self.view.frame;
    [bgImage addSubview:effectView];
    [bgImage addSubview:vibrantView];
    
    emailAddressField.backgroundColor = [UIColor clearColor];
    CALayer *sideBorder = [CALayer layer];
    sideBorder.backgroundColor = [[UIColor whiteColor] CGColor];
    sideBorder.frame = CGRectMake(0, emailAddressField.frame.size.height-1, emailAddressField.frame.size.width, 0.5f);
    [emailAddressField.layer addSublayer:sideBorder];
    
    sendButton.backgroundColor = [UIColor colorWithRed:30/255.0f green:144/255.0f blue:202/255.0f alpha:1.0];
    sendButton.layer.cornerRadius = 5.0;
    
    [emailAddressField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

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

//{
//    "Result": "Failure",
//    "ReferrenceID": "-1",
//    "Message": "Invalid User ID."
//}


- (IBAction)sendAction:(UIButton *)sender {
    login = [[LoginViewController alloc]init];
    
    [login showActivity:self frame:CGRectMake([[UIScreen mainScreen]bounds].size.width/2-20, sendButton.frame.origin.y+sendButton.frame.size.height + 20, 40, 40)];
    [self performSelector:@selector(forgotPassword) withObject:nil afterDelay:0.2];
}

-(void)forgotPassword{
    
    NSArray *arrayKey = [[NSArray alloc]initWithObjects:@"UserId", @"Password",@"Flag", nil];
    
    NSArray *arrayObject = [[NSArray alloc]initWithObjects:emailAddressField.text,@"", @"false", nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:arrayObject forKeys:arrayKey];
    [SingletonClass executeMultipart:[NSURL URLWithString:@"http://www.atcommobitech.in/MMIwebapi/API/Validate"] dict:questionDict withCompletionHandler:^(NSDictionary* dict){
    
        if ([[dict valueForKey:@"Result"] isEqualToString:@"Failure"]){
            [SingletonClass showAlert:[dict valueForKey:@"Message"] title:[dict valueForKey:@"Result"] view:self];
        }else{
            [SingletonClass showAlert:[dict valueForKey:@"Message"] title:[dict valueForKey:@"Result"] view:self];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [login stopAnimating];
    }];
}


-(IBAction)backButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
