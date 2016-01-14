//
//  SignUpViewController.m
//  MMI
//
//  Created by Shaikh Razak on 26/10/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
{
    NSArray *textfieldsArray;
    UITextField *activeField;
    CGSize kbSize;
    BOOL isMalechecked;
    UIView *bgLayer;
    NSArray *textFieldArray;
    UILabel *maleLabel;
    UILabel *femaleLabel;
    UIView *genderView;
    UIDatePicker *datePicker;
}
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = BgImageView.frame;
    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    UIVisualEffectView *vibrantView = [[UIVisualEffectView alloc]initWithEffect:vibrancy];
    effectView.frame = self.view.frame;
    [BgImageView addSubview:effectView];
    [BgImageView addSubview:vibrantView];
    
    textfieldsArray = [[NSArray alloc]initWithObjects:firstNameField, addressField, telephoneField, genderField, dobField, emailField, userNameField, passwordField, nil];
    for (UITextField *tf in textfieldsArray) {
        CALayer *sideBorder1 = [CALayer layer];
        sideBorder1.backgroundColor = [[UIColor lightGrayColor] CGColor];
        sideBorder1.frame = CGRectMake(0, tf.frame.size.height-0.5, tf.frame.size.width, 0.5f);
        [tf.layer addSublayer:sideBorder1];
        
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        tf.leftView = paddingView1;
        tf.leftViewMode = UITextFieldViewModeAlways;
    }
    signUpButton.backgroundColor = [UIColor colorWithRed:30/255.0f green:144/255.0f blue:202/255.0f alpha:1.0];
    signUpButton.layer.cornerRadius = 5.0;
    
    scrollView.contentSize = scrollView.bounds.size;
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];

    UIButton *genderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    genderButton.frame = CGRectMake(0, 0, genderField.frame.size.width, genderField.frame.size.height);
    genderButton.userInteractionEnabled = YES;
    [genderButton addTarget:self action:@selector(genderSelection:) forControlEvents:UIControlEventTouchUpInside];
    [genderField addSubview:genderButton];
    
    UIButton *dobButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dobButton.frame = CGRectMake(0, 0, dobField.frame.size.width, dobField.frame.size.height);
    dobButton.userInteractionEnabled = YES;
    [dobButton addTarget:self action:@selector(dobSelection:) forControlEvents:UIControlEventTouchUpInside];
    [dobField addSubview:dobButton];
    
    
    textFieldArray = [[NSArray alloc]initWithObjects:firstNameField, telephoneField, addressField, genderField, dobField, emailField, passwordField, userNameField, nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeKeyBoard:)];
    [scrollView addGestureRecognizer:tap1];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
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
-(void)keyboardWasShown:(NSNotification *)notification{
    
    //isKeyboardShowing = YES;
    NSDictionary* info = [notification userInfo];
    kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+40, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
}
-(void)keyboardWillHide:(NSNotification *)notification{
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
//    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut |  UIViewAnimationCurveEaseIn
//                     animations:^{
//                         
//                         self.view.frame = CGRectMake(0, 63, self.view.frame.size.width, self.view.frame.size.height);
//                         
//                     }
//                     completion:^(BOOL finished){
//                         
//                     }];
    //writeReviewScroll.contentSize = CGSizeMake([[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    //[productField resignFirstResponder];
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    scrollView.contentSize = CGSizeMake([[UIScreen mainScreen]bounds].size.width, 650);
//    if (textField != firstNameField && textField != addressField) {
//        [scrollView setContentOffset:CGPointMake(0,textField.frame.origin.y-40) animated:YES];//you can set your  y cordinate as your req also
//    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut |UIViewAnimationCurveEaseIn animations:^{
    [datePicker removeFromSuperview];
    [genderView removeFromSuperview];
    }
    completion:^(BOOL finished){
        
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    scrollView.contentSize = scrollView.bounds.size;
//    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    
    return YES;
}

-(void)removeKeyBoard:(UIGestureRecognizer*)gesture{
    for (UITextField *tf in textFieldArray) {
        [tf resignFirstResponder];
    }
    [datePicker removeFromSuperview];
    [genderView removeFromSuperview];
}

-(void)dobSelection:(UIButton*)sender{
    for (UITextField *tf in textFieldArray) {
        [tf resignFirstResponder];
    }
    [self showDatePicker];
}

-(void)showDatePicker{
    
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height-200,[[UIScreen mainScreen]bounds].size.width, 200)];
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor lightGrayColor];
    datePicker.hidden=NO;
    datePicker.date=[NSDate date];
    [datePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
}

-(void)LabelTitle:(id)sender{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    //assign text to label
    dobField.text=str;
}

-(void)genderSelection:(UIButton*)sender{
    for (UITextField *tf in textFieldArray) {
        [tf resignFirstResponder];
    }
    [self createGenderOptionsView];
}

-(void)createGenderOptionsView{
    
    bgLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    bgLayer.userInteractionEnabled = YES;
    [self.view addSubview:bgLayer];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBgLayer:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [bgLayer addGestureRecognizer:tap];
    
    genderView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 200, 150)];
    genderView.backgroundColor = [UIColor whiteColor];
    genderView.layer.cornerRadius = 5.0;
    [bgLayer addSubview:genderView];
    genderView.center = bgLayer.center;
    
    UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, genderView.frame.size.width, 50)];
    headingLabel.text = @"Select Gender";
    headingLabel.textColor = [UIColor whiteColor];
    headingLabel.backgroundColor = [UIColor lightGrayColor];
    headingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    headingLabel.textAlignment = NSTextAlignmentCenter;
    [genderView addSubview:headingLabel];
   
    
    UIView *maleView = [[UIView alloc]initWithFrame:CGRectMake(0, headingLabel.frame.size.height, 200, 50)];
    maleView.backgroundColor = [UIColor whiteColor];
    [genderView addSubview:maleView];
    
    UIButton *maleTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    maleTextButton.frame = CGRectMake(0, 0, genderView.frame.size.width, 50);
    maleTextButton.tag = 1;
    [maleTextButton setTitle:@"Male" forState:UIControlStateNormal];
    [maleTextButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[maleTextButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [maleTextButton addTarget:self action:@selector(radioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [maleView addSubview:maleTextButton];
    
    UIView *femaleView = [[UIView alloc]initWithFrame:CGRectMake(0, maleView.frame.origin.y + maleView.frame.size.height, 200, 50)];
    femaleView.backgroundColor = [UIColor whiteColor];
    [genderView addSubview:femaleView];
    
    
    UIButton *femaleTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    femaleTextButton.frame = CGRectMake(0, 0, genderView.frame.size.width, 50);
    femaleTextButton.tag = 2;
    [femaleTextButton setTitle:@"Female" forState:UIControlStateNormal];
    [femaleTextButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[femaleTextButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [femaleTextButton addTarget:self action:@selector(radioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [femaleView addSubview:femaleTextButton];

}

-(IBAction)backButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)radioButtonAction:(UIButton*)sender{
    
    if (sender.tag == 1) {
        genderField.text = @"Male";
    }else
        genderField.text = @"Female";
    
    [self performSelector:@selector(removeBgLayer:) withObject:nil afterDelay:0.1];
}

-(void)removeBgLayer:(UIGestureRecognizer*)gesture{
    
    [gesture.view removeGestureRecognizer:gesture];
    [bgLayer removeFromSuperview];
}

-(NSString*)validations{
    
    NSString *message;
    if (firstNameField.text.length == 0) {
        message = @"Please enter first name";
    }else if (addressField.text.length == 0)
        message = @"Please enter address";
    else if (telephoneField.text.length == 0)
        message = @"Please enter telephone number";
    else if (genderField.text.length == 0)
        message = @"Please select gender";
    else if (dobField.text.length == 0)
        message = @"Please select date of birth";
    else if (emailField.text.length == 0)
        message = @"Please enter email address";
    else if (userNameField.text.length == 0)
        message = @"Please enter username";
    else if (passwordField.text.length == 0)
        message = @"Please enter password";
    return message;
}

- (IBAction)signUpAction:(UIButton *)sender {
    NSString *msg = [self validations];
    if (msg!=nil) {
        [SingletonClass showAlert:msg title:@"Alert" view:self];
    }else{
    UIActivityIndicatorView *activity;
    UIView *view = [SingletonClass addBlackLayer:self acti:activity];
    [self performSelector:@selector(signUp:) withObject:view afterDelay:0.2];
    }
}

-(void)signUp:(UIView*)acti{
   
        NSArray *arrayKey = [[NSArray alloc]initWithObjects:@"Customer_ID", @"Mobile",@"Customer_Name",@"Email",@"DOB",@"Address",@"Gender",@"Password", nil];
        
        NSArray *arrayObject = [[NSArray alloc]initWithObjects:@"0", telephoneField.text,firstNameField.text,emailField.text,dobField.text,addressField.text,genderField.text,passwordField.text, nil];
        
        NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:arrayObject forKeys:arrayKey];
        NSError *error;
        NSData *paramsJSONDictionaryData = [NSJSONSerialization dataWithJSONObject:questionDict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonParamsString = [[NSString alloc] initWithData:paramsJSONDictionaryData encoding:NSUTF8StringEncoding];
        NSData *postData = [jsonParamsString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://www.atcommobitech.in/MMIwebapi/api/Customer"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: postData];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (data!=nil) {
                NSArray *jsonResponseArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                if ([[jsonResponseArray valueForKey:@"Result"] isEqualToString:@"Success"]) {
                    [[NSUserDefaults standardUserDefaults]setObject:[jsonResponseArray valueForKey:@"ReferrenceID"] forKey:@"ReferenceId"];
                }
                [self showAlert:[jsonResponseArray valueForKey:@"Message"] title:[jsonResponseArray valueForKey:@"Result"]];
                [acti removeFromSuperview];
            }
        }];
}

-(void)showAlert:(NSString*)message title:(NSString*)title {
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float >= 8.0){
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:title
                                      message:message
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handel your yes please button action here
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       [self.navigationController popViewControllerAnimated:YES];
                                       
                                   }];
        
        [alert addAction:okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }


}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:genderView])
        return NO;
    
    return YES;
}











@end
