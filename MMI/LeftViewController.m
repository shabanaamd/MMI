//
//  LeftViewController.m
//  MMI
//
//  Created by Administrator on 21/10/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    labelArray = [[NSArray alloc]initWithObjects:@"Home", @"Interests", @"Notifications", @"Account Settings", @"Booked History", @"Add Payment Details", @"Add To Book", @"Quick Book", @"Share", @"T & C", @"FAQ", nil];
    imageArray = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"interest"],
                  [UIImage imageNamed:@"interest"],
                  [UIImage imageNamed:@"notification"],
                  [UIImage imageNamed:@"setting"],
                  [UIImage imageNamed:@"booking_history"],
                  [UIImage imageNamed:@"add_bankdetails"],
                  [UIImage imageNamed:@"booking_history"],
                  [UIImage imageNamed:@"quickbook"],
                  [UIImage imageNamed:@"share"],
                  [UIImage imageNamed:@"t&c"],
                  [UIImage imageNamed:@"faq"], nil];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginAction:)];
    [profileImage addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginAction:)];
    [loginLabel addGestureRecognizer:tap1];
    
    // Do any additional setup after loading the view.
}

-(void)loginAction:(UIGestureRecognizer *)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *myVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginId"];
    [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:myVC withSlideOutAnimation:YES andCompletion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return [labelArray count];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    // view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:YES];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BankDetailsVC *myVC = (BankDetailsVC *)[storyboard instantiateViewControllerWithIdentifier:@"BankID"];
    AccountSettingsVC *acntVC = (AccountSettingsVC *)[storyboard instantiateViewControllerWithIdentifier:@"AccountID"];

    NotifcationViewController *notif = (NotifcationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NotifsID"];

    InterestViewController *interest = (InterestViewController *)[storyboard instantiateViewControllerWithIdentifier:@"InterestsID"];
    
    BookingHistoryVC *booking = (BookingHistoryVC *)[storyboard instantiateViewControllerWithIdentifier:@"BookingHistoryId"];
    
    ViewController *controller = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HomeId"];

    if (indexPath.row ==0) {
        [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:controller withSlideOutAnimation:YES andCompletion:^{
        }];
        
    }else if (indexPath.row == 1) {
        [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:interest withSlideOutAnimation:YES andCompletion:^{
        }];
    }else if (indexPath.row == 2) {
        [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:notif withSlideOutAnimation:YES andCompletion:^{
        }];
    }else if (indexPath.row == 3) {
        [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:acntVC withSlideOutAnimation:YES andCompletion:^{
        }];
    }else if (indexPath.row == 4) {
        [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:booking withSlideOutAnimation:YES andCompletion:^{
        }];
    }
    
    if (indexPath.row == 5) {
        
        [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:myVC withSlideOutAnimation:YES andCompletion:nil];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.contentView.backgroundColor = [UIColor blackColor];
    UILabel *cellLabel;
    if ([[UIScreen mainScreen]bounds].size.height == 1024) {
        cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 17, 200, 21)];
        cellLabel.font = [UIFont fontWithName:@"Lato" size:15];
    }else  if ([[UIScreen mainScreen]bounds].size.height == 667){
        cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 250, 21)];
        cellLabel.font = [UIFont fontWithName:@"Lato" size:14];
    }else{
        cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 12, 200, 21)];
        cellLabel.font = [UIFont fontWithName:@"Lato" size:12];
    }
    cellLabel.textColor = [UIColor lightGrayColor];
    cellLabel.tag = 1;
    [cell.contentView addSubview:cellLabel];
    
    UIImageView *cellimageView;
    if ([[UIScreen mainScreen]bounds].size.height == 1024)
        cellimageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 25, 25)];
    else  if ([[UIScreen mainScreen]bounds].size.height == 667)
        cellimageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 25, 25)];
    else
        cellimageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 25)];
    [cell.contentView addSubview:cellimageView];
    
    cellLabel.text = [labelArray objectAtIndex:indexPath.row];
    cellimageView.image = [imageArray objectAtIndex:indexPath.row];
    
    return cell;
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
