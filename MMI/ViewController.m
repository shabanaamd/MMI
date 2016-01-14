//
//  ViewController.m
//  MMI
//
//  Created by Administrator on 20/10/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
}
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
    }
    return self;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
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
    
    [activity startAnimating];
    [activity setHidesWhenStopped:YES];

    catNameArray = [[NSMutableArray alloc]initWithObjects:@"AUDIO STUDIO",@"INDOOR STUDIO",@"JAM ROOM",@"REHEARSAL HALL",@"ADD STUDIO",@"INVITE FRIENDS", nil];
    catImageArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"add_studio"],[UIImage imageNamed:@"indoor_studio"],[UIImage imageNamed:@"jam_room"],[UIImage imageNamed:@"rehearsal_room"],[UIImage imageNamed:@"add_studio"],[UIImage imageNamed:@"invite_friend"], nil];
    sliderImagesArray = [[NSMutableArray alloc]init];
    sliderImageIdArray = [[NSMutableArray alloc]init];
    
//    CALayer *sideBorder = [CALayer layer];
//    sideBorder.backgroundColor = [[UIColor whiteColor] CGColor];
//    sideBorder.frame = CGRectMake(0, homeSearchBar.frame.size.height-1, homeSearchBar.frame.size.width, 0.5f);
//    [homeSearchBar.layer addSublayer:sideBorder];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    NSArray *viewArray = [[NSArray alloc]initWithObjects:audioStudioView, indoorStudioView, jamRoomVIew, rehearsalHallView, nil];
    for (UIView *view in viewArray) {
        CALayer *upperBorder = [CALayer layer];
        upperBorder.backgroundColor = [[UIColor lightGrayColor] CGColor];
        upperBorder.frame = CGRectMake(-10, view.frame.size.height-1.0f, CGRectGetWidth(view.frame), 0.5f);
        [view.layer addSublayer:upperBorder];
    }
    
    NSArray *viewArray1 = [[NSArray alloc]initWithObjects:audioStudioView, jamRoomVIew, addStudioView, nil];
    for (UIView *view in viewArray1) {
        CALayer *sideBorder = [CALayer layer];
        sideBorder.backgroundColor = [[UIColor lightGrayColor] CGColor];
        sideBorder.frame = CGRectMake(view.frame.size.width-1.0f, 0, 0.5f, view.frame.size.height);
        [view.layer addSublayer:sideBorder];

    }
    
    SingletonClass *singleton = [SingletonClass sharedManager];
    if ([[singleton class] checkInternetReachability]) {
        [self getSliderImages];
    }else{
        [activity stopAnimating];
        [[singleton class] noInternetLabel:self.view frame:100 text:@"No Internet Connection"];
    }
    
    [self updateLocation];
}

-(void)updateLocation{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter=100.0;
    locationManager.delegate = self;
    locationManager.pausesLocationUpdatesAutomatically = NO;
    [locationManager startMonitoringSignificantLocationChanges];
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined){
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"City"]==nil | [[NSUserDefaults standardUserDefaults]objectForKey:@"Latitude"] == nil | [[NSUserDefaults standardUserDefaults]objectForKey:@"Longitude"] == nil) {
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"19.06311475"] forKey:@"Latitude"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"72.83010585"] forKey:@"Longitude"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"Mumbai"] forKey:@"CurrentCity"];
        }
    }
    //[locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    //[locationManager startUpdatingLocation];
    float latitude = newLocation.coordinate.latitude;
    float longitude = newLocation.coordinate.longitude;
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f", latitude] forKey:@"Latitude"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f", longitude] forKey:@"Longitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           //NSLog(@"Geocode failed with error: %@", error);
                           
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       //NSLog(@"placemark.ISOcountryCode %@",placemark.locality);
                       CLLocationCoordinate2D p1;
                       p1.latitude  = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Latitude"] doubleValue];
                       p1.longitude = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Longitude"] doubleValue];
                       
                       if (placemark.locality == nil || !CLLocationCoordinate2DIsValid(p1)) {
                           
                           [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"19.06311475"] forKey:@"Latitude"];
                           [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"72.83010585"] forKey:@"Longitude"];
                           [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"Mumbai"] forKey:@"CurrentCity"];
                           
                       }else{
                         
                           if ([[NSUserDefaults standardUserDefaults]objectForKey:@"City"]==nil | [[NSUserDefaults standardUserDefaults]objectForKey:@"Latitude"] == nil | [[NSUserDefaults standardUserDefaults]objectForKey:@"Longitude"] == nil) {
                               [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f", latitude] forKey:@"Latitude"];
                               [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f", longitude] forKey:@"Longitude"];
                               [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", placemark.locality] forKey:@"CurrentCity"];
                               [[NSUserDefaults standardUserDefaults]synchronize];
                           }
                       }
                   }];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length == 0)
    {
    }else{
        [self getSearchResults:searchText isSearch:YES];
    }
}

-(void)getSearchResults:(NSString*)searchText isSearch:(BOOL)isSearch{
    
    NSString *param;
    if (isSearch) {
        param = [NSString stringWithFormat:@"%@########", searchText];
    }else
        param = [NSString stringWithFormat:@"##%@######",searchText];
    NSArray *arrayKey = [[NSArray alloc]initWithObjects:@"Studio_ID",@"StudioBranch_ID",@"Category_ID",@"Customer_ID",@"ISQuickBook",@"FText",@"PageSize", @"PageIndex", @"SortMode", @"IsActive", nil];
    
    NSArray *arrayObject = [[NSArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"false",param, @"10", @"1", @"1", @"true", nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:arrayObject forKeys:arrayKey];
    [SingletonClass executeMultipart:[NSURL URLWithString:@"http://www.atcommobitech.in/MMIwebapi/Api/Studio"] dict:questionDict withCompletionHandler:^(NSDictionary* dict){
        NSLog(@"result serach = %@", dict);
        
    }];
}


-(void)getSliderImages{

    NSArray *objects = [NSArray arrayWithObjects:@"0", @"", @"0", @"1", @"1", nil];
    NSArray *keys = [NSArray arrayWithObjects:@"Slider_ID", @"FilterText", @"PageSize", @"PageIndex", @"SortMode", nil];
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSError *error;
    NSData *paramsJSONDictionaryData = [NSJSONSerialization dataWithJSONObject:questionDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonParamsString = [[NSString alloc] initWithData:paramsJSONDictionaryData encoding:NSUTF8StringEncoding];
    NSData *postData = [jsonParamsString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.atcommobitech.in/MMIwebapi/api/Slider/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data != nil) {
            NSArray *jsonResponseArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            __block int xOffset = 0;
            CGRect rect = imageSlider.frame;
            rect.size.width = [[UIScreen mainScreen] bounds].size.width;
            imageSlider.frame = rect;
            imageSlider.pagingEnabled = YES;
            [imageSlider layoutIfNeeded];
            __block UIImageView *img;
            
            for (int i = 0; i<[jsonResponseArray count]; i++) {
                [sliderImageIdArray addObject:[[jsonResponseArray objectAtIndex:i] valueForKey:@"Slider_ID"]];
                [array addObject:[[jsonResponseArray objectAtIndex:i] valueForKey:@"Slider_Img_URL"]];
            }
            [self asynchronousGetSliderImages:array completion:^{
                [activity stopAnimating];
                for(int index=0; index < [sliderImagesArray count]; index++)
                {
                    img  = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, 0, imageSlider.frame.size.width, imageSlider.frame.size.height)];
                    img.image = [sliderImagesArray objectAtIndex:index];
                    [imageSlider addSubview:img];
                    xOffset+=[[UIScreen mainScreen]bounds].size.width;
                    imageSlider.contentSize = CGSizeMake(xOffset,imageSlider.frame.size.height);
                }
            }];  
        }
    }];
}

- (void)asynchronousGetSliderImages:(NSMutableArray*)urlString completion:(void (^)(void))completion;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Some long running task you want on another thread
        for (NSString *str in urlString) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
            NSURLResponse *returnedResponse = nil;
            NSError *returnedError = nil;
            NSData *itemData  = [NSURLConnection sendSynchronousRequest:request returningResponse:&returnedResponse error:&returnedError];
            
            UIImage *img = [[UIImage alloc] initWithData:itemData];
            
            if(img!=nil){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [sliderImagesArray addObject:img];
                    if (completion) {
                        completion();
                    }
                });
            }
        }
        
    });
}


-(IBAction)getLocationsAction:(UIButton*)sender{
    [self getSearchResults:[[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentCity"]isSearch:NO];
}

-(void)loginAction:(UIButton *)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *myVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginId"];
    [self.navigationController pushViewController:myVC animated:YES];
    
}

-(IBAction)pushToList:(UIView*)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ListingViewController *myVC = (ListingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ListView"];
    myVC.subCatId = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    [self.navigationController pushViewController:myVC animated:YES];
}

-(IBAction)addStudioAction:(UIView*)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddStudioViewController *myVC = (AddStudioViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AddStudioID"];
    [self.navigationController pushViewController:myVC animated:YES];
}

-(void)buttonTapped:(UIButton*)sender{
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
