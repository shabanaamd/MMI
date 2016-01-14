//
//  NotifcationViewController.m
//  MMI
//
//  Created by Shaikh Razak on 10/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "NotifcationViewController.h"

@interface NotifcationViewController ()

@end

@implementation NotifcationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Notifications";
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateNormal];
    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:rightBarButtonItem, nil] animated:NO];
    
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0];

    titleArray = [[NSMutableArray alloc]initWithObjects:@"Order Confirmation",@"New Studio Added",@"Your seacrhing slot available now",@"Cancellation confirmation",@"Order Confirmation",@"New Studio Added",@"Your seacrhing slot available now",@"Cancellation confirmation",@"Order Confirmation",@"New Studio Added", nil];
    dateArray = [[NSMutableArray alloc]initWithObjects:@"8 mins ago",@"5 hours ago",@"11 hours ago",@"Sun at 1:00 pm",@"8 mins ago",@"5 hours ago",@"11 hours ago",@"Sun at 1:00 pm",@"11 hours ago",@"Sun at 1:00 pm", nil];
    studioNameArray = [[NSMutableArray alloc]initWithObjects:@"Raheja Studio",@"Pauls Studio",@"Raheja Studio",@"Pauls Studio",@"Raheja Studio",@"Pauls Studio",@"Raheja Studio",@"Pauls Studio",@"Raheja Studio",@"Pauls Studio", nil];
    addressArray = [[NSMutableArray alloc]initWithObjects:@"D4113 Oberoi garden, Andheri East.",@"D4113 Oberoi garden, Andheri East.",@"D4113 Oberoi garden, Andheri East.",@"D4113 Oberoi garden, Andheri East.",@"D4113 Oberoi garden, Andheri East.",@"D4113 Oberoi garden, Andheri East.",@"D4113 Oberoi garden, Andheri East.",@"",@"D4113 Oberoi garden, Andheri East.",@"D4113 Oberoi garden, Andheri East.", @"D4113 Oberoi garden, Andheri East.", nil];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayAddress:(NSString*)title msg:(NSString*)msg{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:@"Raheja Studio - D4113 Oberoi garden, Andheri East.\nYour booking has been confirmed for 3rd Sep 2015.\nSlot booking 9:00 - 10:00 to 1:00.\ntotal hours - Three (3)\nYou will recieve an email/sms shortly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"View", nil];
    [alert show];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    // view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:YES];
    [self displayAddress:[titleArray objectAtIndex:indexPath.row] msg:@""];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    NotificationTableViewCell *cell;
    CellIdentifier  = @"NotifsIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.nameOnStudioLabel.text = [studioNameArray objectAtIndex:indexPath.row];
    cell.dateLabel.text = [dateArray objectAtIndex:indexPath.row];
    cell.addressLabel.text = [addressArray objectAtIndex:indexPath.row];
    
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
