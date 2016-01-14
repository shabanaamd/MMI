//
//  DetailViewController.m
//  MMI
//
//  Created by Shaikh Razak on 19/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "DetailViewController.h"
#import "SingletonClass.h"

@interface DetailViewController ()
{
    UITapGestureRecognizer *tap;
    UIView *blackLayerView;
    UIActivityIndicatorView *activity;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dynamicTVHeight;

@end

@implementation DetailViewController
@synthesize hvTable, categoryNameString, studioNameString, addressString, costArray, servicesArray, emailString, contactNumberString, websiteString, contactUsString, engineerEditorString, timingString, workingString, ratingCountString, ratingString, reviewCountString, bannerImage, thumbnailImageArray, thumbnailURLString, studio_branchIDString;

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

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([[UIScreen mainScreen]bounds].size.height == 1024)
        loginBtn.frame = CGRectMake(0, 0, 32, 32);
    else
        loginBtn.frame = CGRectMake(0, 0, 50, 35);
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithCustomView:loginBtn] ;
    [self.navigationItem setRightBarButtonItem:loginButton];
    
    
    headingArray = [[NSMutableArray alloc]initWithObjects:@"http:// - ", @"Contact no - ",@"Email ID - ",@"Contact us - ",@"Engineer/Editor - ",@"Timings - ",@"Working Days - ", nil];

    contentArray = [[NSMutableArray alloc]initWithObjects:websiteString, contactNumberString,emailString,@"support@abc.com",engineerEditorString,@"some time",workingString, nil];
    
    CGRect rect = tableVw.frame;
    rect.size.height = [headingArray count]*35;
    rect.origin.y = addressLabel.frame.origin.y + addressLabel.frame.size.height+10;
    tableVw.frame = rect;
    tableVw.scrollEnabled = NO;
    
    rect = bottomView.frame;
    rect.origin.y = tableVw.frame.origin.y + tableVw.frame.size.height+10;
    bottomView.frame = rect;

    bgScrollView.contentSize = CGSizeMake([[UIScreen mainScreen]bounds].size.width, bottomView.frame.origin.y+bottomView.frame.size.height+10);
    hvTable.HVTableViewDataSource = self;
    hvTable.HVTableViewDelegate = self;
    bookButton.layer.cornerRadius = 3.0;
    
    //categoryLabel.text = categoryNameString;
    studioNameLabel.text = studioNameString;
    addressLabel.text = addressString;
    NSString *str1;
    NSString *str2;
    if ([ratingCountString intValue]>1) {
       str1 = [NSString stringWithFormat:@"%@ Ratings",ratingCountString];
    }else
       str1 = [NSString stringWithFormat:@"%@ Rating",ratingCountString];
    
    if ([reviewCountString intValue]>1) {
       str2 = [NSString stringWithFormat:@"%@ Reviews", reviewCountString];
    }else
       str2 = [NSString stringWithFormat:@"%@ Review", reviewCountString];
    ratingCountLabel.text = str1;
    reviewCountLabel.text = str2;
    bannerImageView.image = bannerImage;
    NSArray *imageVwArray = [[NSArray alloc]initWithObjects:thumbnailImageView1, thumbnailImageView2, thumbnailImageView3, nil];
    thumbnailImageArray = [thumbnailURLString componentsSeparatedByString:@"|"];
    
    for (int i = 0; i<[thumbnailImageArray count]; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[thumbnailImageArray objectAtIndex:i]]];
            NSURLResponse *returnedResponse = nil;
            NSError *returnedError = nil;
            NSData *itemData  = [NSURLConnection sendSynchronousRequest:request returningResponse:&returnedResponse error:&returnedError];
            
            UIImage *img = [[UIImage alloc] initWithData:itemData];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIImageView *imgVw = [imageVwArray objectAtIndex:i];
                if (img == nil) {
                    imgVw.image = [UIImage imageNamed:@"default_image"];
                }else{
                    imgVw.image = img;
                }
            });
        });

    }
    //[tableVw layoutIfNeeded];
    
    // Do any additional setup after loading the view.
}

-(IBAction)showOptions:(UIView*)sender{
    
    switch (sender.tag) {
        case 0:
        {
            [self showOptionsLayer:[NSArray arrayWithArray:costArray]];
        }
            break;
        case 2:
        {
            [self showOptionsLayer:[NSArray arrayWithArray:servicesArray]];
 
        }
            break;

        default:
            break;
    }
}

-(void)showOptionsLayer:(NSArray*)array{
    
    blackLayerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    blackLayerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view.window addSubview:blackLayerView];
    blackLayerView.userInteractionEnabled = YES;
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeLayer:)];
    tap.delegate = self;
    [blackLayerView addGestureRecognizer:tap];
    
   // NSArray *array = [[NSArray alloc]initWithObjects:@"Audio Studio", @"Indoor Studio", @"Jam Room", @"Rehearsal Hall", nil];
    customTable = [[CustomTableVC alloc]init];
    customTable.customDelegate = self;
    customTable.listArray = [array mutableCopy];
    //    customTable.whichDropDown = @"AudioStudio";
    customTable.font = 14;
    customTable.isCheckBoxHidden = YES;
    customTable.tableView.frame = CGRectMake(40, 100, [[UIScreen mainScreen]bounds].size.width - 80, [array count]*44);
    customTable.tableView.center = blackLayerView.center;
    [customTable.tableView reloadData];
    customTable.tableView.layer .cornerRadius = 5.0;
    [blackLayerView addSubview:customTable.tableView];
}

-(void)tableViewItemSelected:(NSString *)selectedItem{
    
    
}

-(void)viewDidLayoutSubviews
{
    CGFloat height = MIN(self.view.bounds.size.height, tableVw.contentSize.height);
    self.dynamicTVHeight.constant = height;
    [self.view layoutIfNeeded];
}


-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loginAction:(UIButton *)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *myVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginId"];
    [self.navigationController pushViewController:myVC animated:YES];
    
}

- (IBAction)bookStudioAction:(UIButton *)sender{
    CalendarViewController *myVC = [[CalendarViewController alloc]init];
    myVC.studio_branchIDString = studio_branchIDString;
    myVC.studio_nameString = studioNameLabel.text;
    myVC.studio_addressString = addressLabel.text;
    myVC.engineerEditorString = engineerEditorString;
    [self.navigationController pushViewController:myVC animated:YES];
}

-(void)addBlackLayer:(BOOL)addGesture{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         blackLayerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
                         [self.view.window addSubview:blackLayerView];
                     }
                     completion:^(BOOL finished){
                     }];
    blackLayerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    if (addGesture) {
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeLayer:)];
        tap.delegate = self;
        [blackLayerView addGestureRecognizer:tap];
    }
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.frame = CGRectMake(0, 0, 40, 40);
    activity.center = blackLayerView.center;
    [blackLayerView addSubview:activity];
    [activity startAnimating];
}

-(void)removeBlackLayer{
    [blackLayerView removeFromSuperview];
    [activity stopAnimating];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isDescendantOfView:customTable.tableView])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)removeLayer:(UITapGestureRecognizer*)gesture{
    [gesture.view removeFromSuperview];
}

#pragma mark ---- HVTableView Delegates

-(void)tableView:(UITableView *)tableView expandCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:3];
    UIButton *purchaseButton = (UIButton *)[cell viewWithTag:10];
    purchaseButton.alpha = 0;
    purchaseButton.hidden = NO;
    
    [UIView animateWithDuration:.5 animations:^{
        detailLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        purchaseButton.alpha = 1;
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(3.14);
    }];
}

-(void)tableView:(UITableView *)tableView collapseCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:3];
    UIButton *purchaseButton = (UIButton *)[cell viewWithTag:10];
    
    [UIView animateWithDuration:.5 animations:^{
        detailLabel.text = @"Lorem ipsum dolor sit amet";
        purchaseButton.alpha = 0;
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(-3.14);
    } completion:^(BOOL finished) {
        purchaseButton.hidden = YES;
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isexpanded
{
    //you can define different heights for each cell. (then you probably have to calculate the height or e.g. read pre-calculated heights from an array
    if (isexpanded)
        return 200;
    
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded
{
    static NSString *CellIdentifier = @"Content1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *textLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:3];
    UIButton *purchaseButton = (UIButton *)[cell viewWithTag:10];
    
    //alternative background colors for better division ;)
    if (indexPath.row %2 ==1)
        cell.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    else
        cell.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];
    
    textLabel.text = [expandArray objectAtIndex:indexPath.row % 10];
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString* imageFileName = [NSString stringWithFormat:@"%ld.jpg", indexPath.row % 10 + 1];
    imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", bundlePath, imageFileName]];
    
    if (!isExpanded) //prepare the cell as if it was collapsed! (without any animation!)
    {
        detailLabel.text = @"Lorem ipsum dolor sit amet";
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(0);
        purchaseButton.hidden = YES;
    }
    else ///prepare the cell as if it was expanded! (without any animation!)
    {
        detailLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(3.14);
        purchaseButton.hidden = NO;
    }
    return cell;
}

#pragma mark ---- UITableView Delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == hvTable) {
        return 3;
    }else
    return [headingArray count];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:YES];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    DetailViewController *myVC = (DetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailID"];
//    [self.navigationController pushViewController:myVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    CellIdentifier  = @"CustomCellReuseID";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    if (tableView == hvTable) {
        
    }else{
    UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
    headingLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    headingLabel.textColor = [UIColor blackColor];
    headingLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:headingLabel];
    headingLabel.text = [headingArray objectAtIndex:indexPath.row];

    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 5, 200, 20)];
    detailLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    detailLabel.textColor = [UIColor blackColor];
    detailLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:detailLabel];
    if ([contentArray count]>0) {
        detailLabel.text = [contentArray objectAtIndex:indexPath.row];
     }
    }
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
