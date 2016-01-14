//
//  BookingHistoryVC.m
//  MMI
//
//  Created by PMAM IT Services on 11/01/16.
//  Copyright © 2016 AtcomMobiTech. All rights reserved.
//

#import "BookingHistoryVC.h"

@interface BookingHistoryVC ()

@end

@implementation BookingHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBarButtonItems];
    [bookingsTable registerNib:[UINib nibWithNibName:@"BookingHistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellReuseID"];
    totalBookings = 10;
    // Do any additional setup after loading the view.
}

-(void)setUpNavigationBarButtonItems{
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateNormal];
    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    
    UIButton *logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *logoBtnImage = [UIImage imageNamed:@"logo.png"]  ;
    [logoBtn setBackgroundImage:logoBtnImage forState:UIControlStateNormal];
    logoBtn.frame = CGRectMake(0, 0, 60, 32);
    UIBarButtonItem *logoButton = [[UIBarButtonItem alloc] initWithCustomView: logoBtn] ;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:rightBarButtonItem, logoButton, nil] animated:NO];
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"]==YES) {
        [loginBtn setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"Customer_Name"] forState:UIControlStateNormal];
    }else
        [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.frame = CGRectMake(0, 0, 50, 35);
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithCustomView:loginBtn] ;
    [self.navigationItem setRightBarButtonItem:loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginAction:(UIButton *)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *myVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginId"];
    [self.navigationController pushViewController:myVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 380;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return totalBookings;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    // view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    BookingHistoryCell *cell;
    CellIdentifier  = @"CellReuseID";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[BookingHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:YES];
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
