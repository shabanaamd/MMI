//
//  ListingViewController.m
//  MMI
//
//  Created by Administrator on 21/10/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "ListingViewController.h"

@interface ListingViewController ()
{
    __block CustomTableVC *customTable;
    UIView *loadingView;
    UIActivityIndicatorView *activity;
    UITapGestureRecognizer *tap;
    UIView *blackLayerView;
    __block NSMutableArray *pFilterArray;
    NSMutableArray *lFilterArray;
}
@end

@implementation ListingViewController
@synthesize subCatId, subCatString;

- (void)viewDidLoad {
    [super viewDidLoad];
    customTable = [[CustomTableVC alloc]init];
    customTable.customDelegate = self;
    
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
    
    //[SlideNavigationController sharedInstance].leftBarButtonItem = rightBarButtonItem;
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    
//    UIButton *logoView = [[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
//    [logoView setBackgroundImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
//    [logoView setUserInteractionEnabled:NO];
//    self.navigationItem.titleView = logoView;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIImageView *imgvw = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 80, 40)];
    imgvw.image = [UIImage imageNamed:@"logo.png"];
    [view addSubview:imgvw];
    self.navigationItem.titleView = view;
    
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
    
      NSArray *arr = [[NSArray alloc]initWithObjects:audioStudioView, subcategoryView, filterView, nearbyView, nil];
    for (UIView *view in arr) {
        view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        view.layer.borderWidth = 0.6;
        view.layer.cornerRadius = 5.0;
    }
    locationArray = [[NSMutableArray alloc]init];
    studioArray = [[NSMutableArray alloc]init];
    listImagesArray = [[NSMutableArray alloc]init];
    listImageURLArray = [[NSMutableArray alloc]init];

    loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    loadingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loadingView];
    
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.frame = CGRectMake(0, 0, 40, 40);
    activity.center = loadingView.center;
    [loadingView addSubview:activity];
    [activity startAnimating];
    [activity setHidesWhenStopped:YES];

    switch ([subCatId intValue]) {
        case 1:
            audioStudioLabel.text = @"Audio Studio";
            break;
            
            case 2:
            audioStudioLabel.text = @"Indoor Studio";
            break;
            
            case 3:
            audioStudioLabel.text = @"Jam Room";
            break;
            
            case 4:
            audioStudioLabel.text = @"Rehearsal Hall";
            break;
            
        default:
            break;
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    if ([SingletonClass checkInternetReachability]) {
        [self getListDetails];
    }else{
        [activity stopAnimating];
        [SingletonClass noInternetLabel:loadingView frame:200 text:@"No Internet Connection"];
    }
    
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{

}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getListDetails{
   
    NSArray *arrayKey = [[NSArray alloc]initWithObjects:@"Studio_ID",@"StudioBranch_ID",@"Category_ID",@"Customer_ID",@"ISQuickBook",@"FText",@"PageSize", @"PageIndex", @"SortMode", @"IsActive", nil];
    
    NSArray *arrayObject = [[NSArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"false",@"########", @"10", @"1", @"1", @"true", nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:arrayObject forKeys:arrayKey];
    NSError *error;
    NSData *paramsJSONDictionaryData = [NSJSONSerialization dataWithJSONObject:questionDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonParamsString = [[NSString alloc] initWithData:paramsJSONDictionaryData encoding:NSUTF8StringEncoding];
    NSData *postData = [jsonParamsString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.atcommobitech.in/MMIwebapi/Api/Studio"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data!=nil) {
            jsonResponseArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            for (int i = 0; i<[jsonResponseArray count]; i++) {
                //if (![[jsonDict allKeys] containsObject:@"Message"]) {
                    NSDictionary *dict = [jsonResponseArray objectAtIndex:i];
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        [studioArray addObject:[dict valueForKey:@"Studio_Name"]];
                        [locationArray addObject:[dict valueForKey:@"Studio_Location"]];
                        
                        if (i!=0) {
                            NSString *imageStr = [dict valueForKey:@"ImageList"];
                            NSArray *arr = [imageStr componentsSeparatedByString:@"| "];
                            imageStr = [arr objectAtIndex:0];
                            [listImageURLArray addObject:imageStr];
                            [listTableView reloadData];
                            [activity stopAnimating];
                            [loadingView removeFromSuperview];
                        }else
                            [listImageURLArray addObject:@"http://www.atcommobitech.in/MMIWebApi/Upload/Studio/list7.png"];
                        
                    }else{
                        listImagesArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"], nil];
                        [activity stopAnimating];
                        [loadingView removeFromSuperview];
                    }

                //}
//                else{
//                    [activity stopAnimating];
//                    [SingletonClass noInternetLabel:loadingView frame:200 text:@"An error has occured."];
//                }
            }
            
         }
        
        else{
            listImagesArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"],[UIImage imageNamed:@"list_image1"], nil];
            [listTableView reloadData];
            [activity stopAnimating];
            [loadingView removeFromSuperview];
        }
    }];
    
}

-(void)loadFilters:(NSString*)param
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.atcommobitech.in/MMIwebapi/api/Filter"];
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] init];
    [request1 setURL:[NSURL URLWithString:webStringURL]];
    
    [NSURLConnection sendAsynchronousRequest:request1 queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSMutableString *loginResponseData=[[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (loginResponseData != nil) {
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            pFilterArray = [json valueForKey:@"PFilter"];
            lFilterArray = [json valueForKey:@"LFilter"];
            if (self.onCompletionGettingFilters) {
                self.onCompletionGettingFilters();
            }
        }
    }];
}


-(void)addQuickBook:(int)index{
   // {'QuickBook_ID':'0','Customer_ID':'1','StudioBranch_ID':'25','Active_Status':'true'}
    
    NSArray *arrayKey = [[NSArray alloc]initWithObjects:@"QuickBook_ID",@"Customer_ID",@"StudioBranch_ID",@"Active_Status", nil];
    
    NSArray *arrayObject = [[NSArray alloc]initWithObjects:[[jsonResponseArray objectAtIndex:index] valueForKey:@"QuickBook_ID"],@"1",[[jsonResponseArray objectAtIndex:index] valueForKey:@"StudioBranch_ID"],[[jsonResponseArray objectAtIndex:index] valueForKey:@"Active_Status"], nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:arrayObject forKeys:arrayKey];
    NSError *error;
    NSData *paramsJSONDictionaryData = [NSJSONSerialization dataWithJSONObject:questionDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonParamsString = [[NSString alloc] initWithData:paramsJSONDictionaryData encoding:NSUTF8StringEncoding];
    NSData *postData = [jsonParamsString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.atcommobitech.in/MMIwebapi/api/QuickBook"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data!=nil) {
            jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//            Message = "QuickBook Added/Updated successfully.";
//            ReferrenceID = 1;
//            Result = Success;
            if ([[jsonDict valueForKey:@"Result"] isEqualToString:@"Success"]) {
                [self showAlert:@"Success!" message:[jsonDict valueForKey:@"Message"]];
            }else
                [self showAlert:@"Error!" message:[jsonDict valueForKey:@"Message"]];
            [self removeBlackLayer];
        }
    }];
}

-(void)showAlert:(NSString*)title message:(NSString*)message{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
//    UIAlertAction* noButton = [UIAlertAction
//                               actionWithTitle:@"No, thanks"
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction * action)
//                               {
//                                   [alert dismissViewControllerAnimated:YES completion:nil];
//                                   
//                               }];
    
    [alert addAction:yesButton];
//    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)loginAction:(UIButton *)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *myVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginId"];
    [self.navigationController pushViewController:myVC animated:YES];
    
}

-(void)tableViewItemSelected:(NSString *)selectedItem{
    
    if ([whichDropDown isEqualToString:@"AudioStudio"]) {
        audioStudioLabel.text = selectedItem;
        [self removeLayer:tap];
        if ([selectedItem isEqualToString:@"Audio Studio"]) {
            subCatId = @"1";
        }else if ([selectedItem isEqualToString:@"Indoor Studio"])
            subCatId = @"2";
        else if ([selectedItem isEqualToString:@"Jam Room"])
            subCatId = @"3";
        else if ([selectedItem isEqualToString:@"Rehearsal Hall"])
            subCatId = @"4";
       subCatLabel.text = @"Sub-Category";
    }else if ([whichDropDown isEqualToString:@"SubCat"]){
        subCatLabel.text = selectedItem;
        [self removeBlackLayer];
    }
   
    
    [self addBlackLayer:NO];
    [self performSelector:@selector(getSubCAtegoryList) withObject:nil afterDelay:0.1];
}

-(void)getSubCAtegoryList{
    subCategoryArray = [[NSMutableArray alloc]init];
    //{"Category_ID":"1","StudioBranch_ID":"0","Studio_ID":"0","IsActive":"true","SortMode":"1","PageSize":"10","ISQuickBook":"false","Customer_ID":"0","PageIndex":"1","FilterText":""}
//    NSArray *arrayKey = [[NSArray alloc]initWithObjects:@"Category_ID",@"StudioBranch_ID",@"Studio_ID",@"IsActive",@"SortMode",@"PageSize",@"ISQuickBook", @"Customer_ID", @"PageIndex", @"FilterText", nil];
//    
//    NSArray *arrayObject = [[NSArray alloc]initWithObjects:subCatId,@"0",@"0",@"true",@"1",@"1",@"false", @"0", @"1", @"", nil];
    
   // NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:subCatId forKeys:@"CID"];
    NSDictionary *questionDict = [NSDictionary dictionaryWithObject:subCatId forKey:@"CID"];
    NSError *error;
    NSData *paramsJSONDictionaryData = [NSJSONSerialization dataWithJSONObject:questionDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonParamsString = [[NSString alloc] initWithData:paramsJSONDictionaryData encoding:NSUTF8StringEncoding];
    NSData *postData = [jsonParamsString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.atcommobitech.in/MMIWebApi/api/Category"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data!=nil) {
            jsonResponseArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            for (NSDictionary *dict in jsonResponseArray) {
                [subCategoryArray addObject:[dict valueForKey:@"Category_Name"]];
                [self removeBlackLayer];
                
            }
        }
    }];
    
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


-(IBAction)audioStudioDropDownAction:(UIView*)sender{
    blackLayerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    blackLayerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view.window addSubview:blackLayerView];
    blackLayerView.userInteractionEnabled = YES;
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeLayer:)];
    tap.delegate = self;
    [blackLayerView addGestureRecognizer:tap];
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"Audio Studio", @"Indoor Studio", @"Jam Room", @"Rehearsal Hall", nil];
    customTable.listArray = [array mutableCopy];
//    customTable.whichDropDown = @"AudioStudio";
    customTable.font = 14;
    customTable.isCheckBoxHidden = YES;
    customTable.tableView.frame = CGRectMake(40, 100, [[UIScreen mainScreen]bounds].size.width - 80, [array count]*44);
    customTable.tableView.center = blackLayerView.center;
    [customTable.tableView reloadData];
    customTable.tableView.layer .cornerRadius = 5.0;
    [blackLayerView addSubview:customTable.tableView];
    whichDropDown = @"AudioStudio";
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


-(IBAction)subCategoryDropDownAction:(UIView*)sender{
    NSArray *array;
    switch ([subCatId intValue]) {
        case 1:
            array = [[NSArray alloc]initWithArray:subCategoryArray];
            break;
            
            case 2:
            array = [[NSArray alloc]initWithArray:subCategoryArray];
            break;
            
            case 3:
            array = [[NSArray alloc]initWithArray:subCategoryArray];
            
            case 4:
            array = [[NSArray alloc]initWithArray:subCategoryArray];
            
        default:
            break;
    }
    whichDropDown = @"SubCat";
    [self addBlackLayer:YES];
    [self createCustomTable:array hidden:YES view:blackLayerView frame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width - 80, [array count]*44)];
}

-(IBAction)filterAction:(UIView*)sender{
    filterVw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, self.view.frame.size.height)];
    [self.view addSubview:filterVw];
    
    filterBtnVw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width/3, self.view.frame.size.height-50)];
    [self.view addSubview:filterBtnVw];
    filterBtnVw.backgroundColor = [UIColor darkGrayColor];
    filterBtnVw.userInteractionEnabled = YES;
    
    filterTableVw = [[UIView alloc]initWithFrame:CGRectMake(filterBtnVw.frame.size.width, 0, [[UIScreen mainScreen]bounds].size.width-filterBtnVw.frame.size.width, self.view.frame.size.height-50)];
    [self.view addSubview:filterTableVw];
    filterTableVw.backgroundColor = [UIColor whiteColor];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(0, filterTableVw.frame.origin.y+filterTableVw.frame.size.height, [[UIScreen mainScreen]bounds].size.width/2, 50);
    [clearBtn setTitle:@"CLEAR FILTERS" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearFilters:) forControlEvents:UIControlEventTouchUpInside];
    [[clearBtn titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [clearBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearBtn setBackgroundColor:[UIColor whiteColor]];
    [filterVw addSubview:clearBtn];
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake(clearBtn.frame.size.width, filterTableVw.frame.origin.y+filterTableVw.frame.size.height, [[UIScreen mainScreen]bounds].size.width/2, 50);
    [applyBtn setTitle:@"APPLY" forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyFilters:) forControlEvents:UIControlEventTouchUpInside];
    [[applyBtn titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyBtn setBackgroundColor:[UIColor orangeColor]];
    [filterVw addSubview:applyBtn];
    
    UIButton *ratingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ratingBtn.tag = 1;
    ratingBtn.userInteractionEnabled = YES;
    ratingBtn.frame = CGRectMake(0, 0, filterBtnVw.frame.size.width, 50);
    [ratingBtn setTitle:@"Services" forState:UIControlStateNormal];
    [ratingBtn addTarget:self action:@selector(ratingsFilters:) forControlEvents:UIControlEventTouchUpInside];
    [[ratingBtn titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [ratingBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [ratingBtn setBackgroundColor:[UIColor whiteColor]];
    [filterBtnVw addSubview:ratingBtn];
    
    UIButton *priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    priceBtn.tag = 2;
    priceBtn.userInteractionEnabled = YES;
    priceBtn.frame = CGRectMake(0, ratingBtn.frame.origin.y+ratingBtn.frame.size.height, filterBtnVw.frame.size.width, 50);
    [priceBtn setTitle:@"Price" forState:UIControlStateNormal];
    [priceBtn addTarget:self action:@selector(priceFilters:) forControlEvents:UIControlEventTouchUpInside];
    [[priceBtn titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [priceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [priceBtn setBackgroundColor:[UIColor clearColor]];
    [filterBtnVw addSubview:priceBtn];
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"5 Star", @"4 Star", @"3 Star", @"2 Star", @"1 Star", nil];
    customTable.listArray = [array mutableCopy];
    customTable.font = 12;
    customTable.isCheckBoxHidden = NO;
    customTable.tableView.frame = CGRectMake(0, filterTableVw.frame.origin.y, filterTableVw.frame.size.width, filterTableVw.frame.size.height);
    [filterTableVw addSubview:customTable.tableView];
    [customTable.tableView reloadData];

//    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil];
//    UIView *mainView = [subviewArray objectAtIndex:0];
//    [self.view addSubview:mainView];
}

-(void)createCustomTable:(NSArray *)listArray hidden:(BOOL)isCheckBoxHidden view:(UIView*)viewToAdd frame:(CGRect)rect{
    
    customTable.listArray = [listArray mutableCopy];
    customTable.font = 14;
    customTable.isCheckBoxHidden = isCheckBoxHidden;
    customTable.tableView.frame = rect;
    [viewToAdd addSubview:customTable.tableView];
    customTable.tableView.scrollEnabled = NO;
    [customTable.tableView reloadData];
    customTable.tableView.center = viewToAdd.center;
    customTable.tableView.layer .cornerRadius = 5.0;
}

-(void)clearFilters:(UIButton*)sender{
    [filterVw removeFromSuperview];
    [filterBtnVw removeFromSuperview];
    [filterTableVw removeFromSuperview];
    
}


-(void)applyFilters:(UIButton*)sender{
     [filterVw removeFromSuperview];
    [filterBtnVw removeFromSuperview];
    [filterTableVw removeFromSuperview];

}


-(void)ratingsFilters:(UIButton*)sender{
    
    sender.backgroundColor = [UIColor whiteColor];
    [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    UIButton *button = (UIButton *)[filterBtnVw viewWithTag:2];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"Voice over", @"Voice dubbing", @"Live instruments(Specify instrument)", @"Other(mention type of recording and equipment required)", nil];
    customTable.listArray = [array mutableCopy];
    customTable.isCheckBoxHidden = NO;
    [customTable.tableView reloadData];
}


-(void)priceFilters:(UIButton*)sender{
    UIButton *button = (UIButton *)[filterBtnVw viewWithTag:1];
    if ([pFilterArray count]==0) {
        [customTable.tableView addSubview:activity];
        [activity startAnimating];
    }
    [self loadFilters:nil];
    self.onCompletionGettingFilters=^{
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < [pFilterArray count]; i++) {
            [array addObject:[NSString stringWithFormat:@"Rs.%@ - Rs.%@", [[pFilterArray objectAtIndex:i] valueForKey:@"MinValue"], [[pFilterArray objectAtIndex:i] valueForKey:@"MaxValue"]]];
        }
        customTable.listArray = [array mutableCopy];
        customTable.isCheckBoxHidden = NO;
        [customTable.tableView reloadData];
        [activity stopAnimating];
    };
    
}

-(IBAction)nearbyAction:(UIView*)sender{
    
    filterVw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, self.view.frame.size.height)];
    [self.view addSubview:filterVw];

    NSArray *array = [[NSArray alloc]initWithObjects:@"South", @"Central", @"Harbour", @"Western", @"Navi Mumbai", @"Kalyan", @"Bangalore", @"Hyderabad", @"Delhi", @"Ahmedabad", @"Chennai", @"Kolkata", @"Pune", @"Lucknow", nil];
    customTable.listArray = [array mutableCopy];
    customTable.font = 12;
    customTable.isCheckBoxHidden = NO;
    customTable.tableView.frame = CGRectMake(0, 0, filterVw.frame.size.width, filterVw.frame.size.height-50);
    [filterVw addSubview:customTable.tableView];
    [customTable.tableView reloadData];

    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(0, customTable.tableView.frame.origin.y+customTable.tableView.frame.size.height, [[UIScreen mainScreen]bounds].size.width/2, 50);
    [clearBtn setTitle:@"CLEAR FILTERS" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearFilters:) forControlEvents:UIControlEventTouchUpInside];
    [[clearBtn titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [clearBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearBtn setBackgroundColor:[UIColor whiteColor]];
    [filterVw addSubview:clearBtn];
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake(clearBtn.frame.size.width, customTable.tableView.frame.origin.y+customTable.tableView.frame.size.height, [[UIScreen mainScreen]bounds].size.width/2, 50);
    [applyBtn setTitle:@"APPLY" forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyFilters:) forControlEvents:UIControlEventTouchUpInside];
    [[applyBtn titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyBtn setBackgroundColor:[UIColor orangeColor]];
    [filterVw addSubview:applyBtn];
    
}



-(void)viewDetail:(UIButton*)button{
    
}

-(void)shareAction:(UIButton*)button{
    NSString *textToShare = @"I would like to share it with you";
    NSString *urlString = [NSString stringWithFormat:@"http://www.atcommobitech.com"];
    NSURL *urlToShare = [NSURL URLWithString:urlString];
    NSArray *activityItems = [NSArray arrayWithObjects:textToShare, urlToShare, nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [activityVC setValue:@"Studio Share" forKey:@"subject"];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

-(void)quickBookAction:(UIButton*)button{
    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
    [myQueue addOperationWithBlock:^{
        [self addQuickBook:button.tag];
        // Background work
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Main thread work (UI usually)
            [self addBlackLayer:NO];
        }];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([listImagesArray count]>0)
        return [listImagesArray count];
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

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *myVC = (DetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailID"];
    myVC.categoryNameString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"Category_Name"];
    myVC.studioNameString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"Studio_Name"];
    myVC.addressString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"Branch_Address"];
    myVC.costArray = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"ArrCosts"];
    myVC.servicesArray = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"ArrServices"];
    myVC.emailString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"Email"];
    myVC.contactNumberString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"ContactNumber"];
    myVC.websiteString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"WebSite"];
    //myVC.contactUsString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"ContactNumber"];
    myVC.engineerEditorString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"EngineerEditor"];
    //myVC.timingString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"EngineerEditor"];
    myVC.workingString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"WorkingDays"];
    myVC.ratingCountString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"RatingCount"];
    myVC.ratingString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"Rating"];
    myVC.reviewCountString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"ReviewComment"];
    myVC.studio_branchIDString = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"StudioBranch_ID"];


    NSString *imageStr = [[jsonResponseArray objectAtIndex:indexPath.row] valueForKey:@"ImageList"];
    NSArray *arr = [imageStr componentsSeparatedByString:@"|"];
    if ([arr count]==4) {
    imageStr = [NSString stringWithFormat:@"%@|%@|%@", [arr objectAtIndex:1], [arr objectAtIndex:2],[arr objectAtIndex:3]];
    }else
    imageStr = [NSString stringWithFormat:@"%@|%@", [arr objectAtIndex:1], [arr objectAtIndex:2]];
    myVC.thumbnailURLString = imageStr;
    
    ListTableViewCell *selectedCell = (ListTableViewCell*)[listTableView cellForRowAtIndexPath:indexPath];
    myVC.bannerImage = selectedCell.bgImageView.image;

    [self.navigationController pushViewController:myVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    ListTableViewCell *cell;
    CellIdentifier  = @"CustomCellReuseID";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tableView==listTableView) {
        listTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        if ([listImageURLArray count]>0) {
            cell.studioNameLabel.text = [studioArray objectAtIndex:indexPath.row];
            cell.locationNameLabel.text = [locationArray objectAtIndex:indexPath.row];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[listImageURLArray objectAtIndex:indexPath.row]]];
            NSURLResponse *returnedResponse = nil;
            NSError *returnedError = nil;
            NSData *itemData  = [NSURLConnection sendSynchronousRequest:request returningResponse:&returnedResponse error:&returnedError];
            
            UIImage *img = [[UIImage alloc] initWithData:itemData];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (img == nil) {
                    cell.bgImageView.image = [UIImage imageNamed:@"default_image"];
                }else{
                    cell.bgImageView.image = img;
                    }
                });
            });

        }
    }
    cell.viewButton.tag = indexPath.row;
    cell.shareButton.tag = indexPath.row;
    cell.quickBookButton.tag = indexPath.row;

    [cell.viewButton addTarget:self action:@selector(viewDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.quickBookButton addTarget:self action:@selector(quickBookAction:) forControlEvents:UIControlEventTouchUpInside];

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
