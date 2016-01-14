//
//  PaymentViewController.m
//  MMI
//
//  Created by Administrator on 02/12/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController
@synthesize bookedDateString, timeSlotString, totalHoursString;

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
    
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateNormal];
    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    
    UIButton *logoView = [[UIButton alloc] initWithFrame:CGRectMake(0,0,50,40)];
    [logoView setBackgroundImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [logoView setUserInteractionEnabled:NO];
    self.navigationItem.titleView = logoView;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, backButton,rightBarButtonItem, nil] animated:NO];
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([[UIScreen mainScreen]bounds].size.height == 1024)
        loginBtn.frame = CGRectMake(0, 0, 32, 32);
    else
        loginBtn.frame = CGRectMake(0, 0, 50, 35);
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithCustomView:loginBtn] ;
    [self.navigationItem setRightBarButtonItem:loginButton];
    
    cellArray = [[NSMutableArray alloc]initWithObjects:@"Debit Card",@"Credit Card",@"Net Banking",@"Wallet",@"Cash/Cheque", nil];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paymentOptionsTableView.frame.size.width, 100)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, view.frame.size.width-20, 40)];
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont fontWithName:@"Helvetica" size:13];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"(Cash/Cheque payment should be done on the next working day after booking, in order to confirm booking)";
    [view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, label.frame.origin.y+label.frame.size.height+5, view.frame.size.width-40, 40);
    button.backgroundColor = [UIColor colorWithRed:0/255.0f green:189/255.0f blue:240/255.0f alpha:1.0];
    [button setTitle:@"PROCESS" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0;
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [button addTarget:self action:@selector(processToPayment) forControlEvents:UIControlEventTouchUpInside];
    button.userInteractionEnabled = YES;
    view.userInteractionEnabled = YES;
    [view addSubview:button];
    
    paymentOptionsTableView.tableFooterView = view;
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loginAction:(UIButton *)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *myVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginId"];
    [self.navigationController pushViewController:myVC animated:YES];
}


-(void)processToPayment{
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float < 9.0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"THANK YOU" message:[NSString stringWithFormat:@"Your booking has been confirmed for %@.\n Slot Booking - %@.\n Total hours - %@", bookedDateString, timeSlotString, totalHoursString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"THANK YOU"
                                      message:[NSString stringWithFormat:@"Your booking has been confirmed for %@.\n Slot Booking - %@.\n Total hours - %@", bookedDateString, timeSlotString, totalHoursString]
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                            }];
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [cellArray count];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    return view;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"Payment Gateway";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    CellIdentifier  = @"reusableIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    cell.textLabel.text = [cellArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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
