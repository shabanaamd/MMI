//
//  LoginViewController.m
//  MMI
//
//  Created by Shaikh Razak on 26/10/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "LoginViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
//#import "AFNetworking.h"
//#import <linkedin-sdk/LISDKAccessToken.h>
//#import <linkedin-sdk/LISDKPermission.h>
//#import <linkedin-sdk/LISDKSession.h>
//#import <linkedin-sdk/LISDKSessionManager.h>

//#import "LIALinkedInApplication.h"

@interface LoginViewController ()<GIDSignInDelegate, GIDSignInUIDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].clientID = @"74281413390-k1uei6ma6plr5vhs2i1d18rto1aqc4jd.apps.googleusercontent.com";
    //[GIDSignIn sharedInstance].scopes.append
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
    
    
    userIDTextField.backgroundColor = [UIColor clearColor];
    passwordTextField.backgroundColor = [UIColor clearColor];
    CALayer *sideBorder = [CALayer layer];
    sideBorder.backgroundColor = [[UIColor whiteColor] CGColor];
    sideBorder.frame = CGRectMake(0, userIDTextField.frame.size.height-1, userIDTextField.frame.size.width, 0.5f);
    [userIDTextField.layer addSublayer:sideBorder];
    
    CALayer *sideBorder1 = [CALayer layer];
    sideBorder1.backgroundColor = [[UIColor whiteColor] CGColor];
    sideBorder1.frame = CGRectMake(0, passwordTextField.frame.size.height-1, passwordTextField.frame.size.width, 0.5f);
    [passwordTextField.layer addSublayer:sideBorder1];
    
    //30 144 202
    signInButton.backgroundColor = [UIColor colorWithRed:30/255.0f green:144/255.0f blue:202/255.0f alpha:1.0];
    signInButton.layer.cornerRadius = 5.0;
    
    signUpButton.backgroundColor = [UIColor clearColor];
    signUpButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    signUpButton.layer.borderWidth = 0.5;
    signUpButton.layer.cornerRadius = 5.0;

    [userIDTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // Do any additional setup after loading the view.
}

-(void)showActivity:(UIViewController*)VC frame:(CGRect)rect{
    
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.frame = rect;
    [VC.view addSubview:activity];
    [activity startAnimating];
    activity.hidesWhenStopped = YES;
}

-(void)stopAnimating{
    [activity stopAnimating];
}

-(IBAction)signInAction:(UIButton *)sender{

    if (userIDTextField.text.length == 0) {
        [SingletonClass showAlert:@"Please enter Username" title:@"Alert!" view:self];
    }else if (passwordTextField.text.length == 0)
        [SingletonClass showAlert:@"Please enter Password" title:@"Alert!" view:self];
    else{
    [self showActivity:self frame:CGRectMake([[UIScreen mainScreen]bounds].size.width/2-20, passwordTextField.frame.origin.y+passwordTextField.frame.size.height+5, 40, 40)];
    [self performSelector:@selector(signIn) withObject:nil afterDelay:0.3];
    }
    
}

-(void)signIn{
    NSArray *arrayKey = [[NSArray alloc]initWithObjects:@"UserId", @"Password",@"Flag", nil];
    
    NSArray *arrayObject = [[NSArray alloc]initWithObjects:userIDTextField.text,passwordTextField.text, @"false", nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:arrayObject forKeys:arrayKey];
    [SingletonClass executeMultipart:[NSURL URLWithString:@"http://www.atcommobitech.in/MMIwebapi/API/Validate"] dict:questionDict withCompletionHandler:^(NSDictionary* dict){
        
        NSLog(@"booking slots are : %@", dict);
        if ([dict valueForKey:@"Result"] == nil) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"Customer_ID"] forKey:@"Customer_ID"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"Customer_Name"] forKey:@"Customer_Name"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"Password"] forKey:@"Password"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"Email"] forKey:@"Email"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"Mobile"] forKey:@"Mobile"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"Gender"] forKey:@"Gender"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"Image_URL"] forKey:@"Image_URL"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"DOB"] forKey:@"DOB"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"Address"] forKey:@"Address"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"City"] forKey:@"City"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict valueForKey:@"Status"] forKey:@"Status"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }else if ([[dict valueForKey:@"Result"] isEqualToString:@"Failure"]){
            [SingletonClass showAlert:[dict valueForKey:@"Message"] title:@"Error!" view:self];
        }
        [activity stopAnimating];
    }];
}

-(IBAction)googleAction{
    if ([[GIDSignIn sharedInstance] hasAuthInKeychain]) {
        [[GIDSignIn sharedInstance]signInSilently];
    }else
        [[GIDSignIn sharedInstance] signIn];
    
}

//Google plus sign in callback delegate method when sign in completes
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error{
    
    NSLog(@"GoogleID :%@", user.userID);
    NSLog(@"Email %@", user.profile.email);
    NSLog(@"User :%@", user.profile.name);
    NSLog(@"Image URL :%@", [user.profile imageURLWithDimension:1]);
    //Gender ?
}

-(void)viewWillDisappear:(BOOL)animated{
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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


- (IBAction)signUpAction:(UIButton *)sender {
}

- (IBAction)skipButton:(UIButton *)sender {
    self.navigationController.navigationBarHidden = NO;

}
@end
