//
//  CalendarViewController.m
//  MMI
//
//  Created by Administrator on 23/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "CalendarViewController.h"
#import "CKCalendarView.h"
#import "SingletonClass.h"

@interface CalendarViewController ()<CKCalendarDelegate>
{
    UIView *bgDimView;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@end

@implementation CalendarViewController
@synthesize studio_branchIDString, studio_addressString, studio_nameString, engineerEditorString;

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
    
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(month-1)];
    monthLabel.text = [NSString stringWithFormat:@"%@, %ld", monthName, (long)day];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSDate *dateTemp = [[NSDate alloc] init];
    dateTemp = [dateFormatter dateFromString:dateString];
    // converting into our required date format
    [dateFormatter setDateFormat:@"EE, dd MMM"];
    NSString *reqDateString = [dateFormatter stringFromDate:dateTemp];
    selectedDateLabel.text = reqDateString;
    
    [self getBookedSlots:[self formatDate:[NSDate date]]];
    
    [self initialize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCalendarAction:)];
    [monthLabel addGestureRecognizer:tap];
    [calendarImage addGestureRecognizer:tap];
    
    studioNameLabel.text = studio_nameString;
    studioAddressLabel.text = studio_addressString;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if ([[UIScreen mainScreen]bounds].size.height==667) {
        CGRect rect = saveButton.frame;
        rect.origin.x = 35;
        saveButton.frame = rect;
        
        rect = cancelButton.frame;
        rect.origin.x = saveButton.frame.origin.x+saveButton.frame.size.width+5;
        cancelButton.frame = rect;
    }
    saveButton.layer.cornerRadius = 3.0;
    cancelButton.layer.cornerRadius = 3.0;
    previewButton.layer.cornerRadius = 3.0;
    addToBookButton.layer.cornerRadius = 3.0;
    confirmBookingButton.layer.cornerRadius = 3.0;
    addAnotherBookingButton.layer.cornerRadius = 3.0;
    
    personalDetailsTextView.text = @"Mr. abcd Gupta \n shabanaamd2011@gmail.com \n 001234567";
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    bgScrollView.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    bgScrollView.contentSize = CGSizeMake([[UIScreen mainScreen]bounds].size.width, cancelButton.frame.origin.y+cancelButton.frame.size.height+80);
}

-(NSString*)formatDate:(NSDate*)date{

//    3 jan, 2014
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSDate *dateTemp = [[NSDate alloc] init];
    dateTemp = [dateFormatter dateFromString:dateString];
    // converting into our required date format
    [dateFormatter setDateFormat:@"dd MMM, yyyy"];
    NSString *reqDateString = [dateFormatter stringFromDate:dateTemp];
    return reqDateString;
}

-(void)keyboardWasShown:(NSNotification*)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    keyboardHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight.height, 0.0);
    bgScrollView.contentInset = contentInsets;
    bgScrollView.scrollIndicatorInsets = contentInsets;
    bgScrollView.contentOffset = CGPointMake(0, bgScrollView.contentSize.height - keyboardHeight.height-180);
    dismissView.frame = CGRectMake(0, keyboardHeight.height+12, [[UIScreen mainScreen]bounds].size.width, dismissView.frame.size.height);
    [self.view addSubview:dismissView];
}

-(void)keyboardWillHide:(NSNotification *)notification{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    bgScrollView.contentInset = contentInsets;
    bgScrollView.scrollIndicatorInsets = contentInsets;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut |  UIViewAnimationCurveEaseIn
                     animations:^{
                         self.view.frame = CGRectMake(0, 63, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)getBookedSlots:(NSString*)dateString{
    
    availableSlotsArray = [[NSMutableArray alloc]init];
    NSArray *arrayKey = [[NSArray alloc]initWithObjects:@"StudioBranch_ID",@"Date", nil];
    
    NSArray *arrayObject = [[NSArray alloc]initWithObjects:studio_branchIDString, dateString, nil];
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:arrayObject forKeys:arrayKey];
    
    [SingletonClass executeMultipart:[NSURL URLWithString:@"http://www.atcommobitech.in/MMIwebapi/api/BookedSlots"] dict:questionDict withCompletionHandler:^(NSDictionary* dict){
        
        NSLog(@"booking slots are : %@", dict);
        if ([[dict valueForKey:@"Message"] isEqualToString:@"All slots available."]) {
            
        }else if ([[dict valueForKey:@"Message"] isEqualToString:@"Some slots are filled."]){
            availableSlotsArray = [dict valueForKey:@"lstSlots"];
        }else
        {
            [SingletonClass showAlert:@"Unkown error occured while getting the slots" title:@"Error!" view:self];
        }
    }];
}

- (IBAction)dismissAction:(UIButton *)sender{
    
    [personalDetailsTextView resignFirstResponder];
    [dismissView removeFromSuperview];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}



-(void)initialize{
    myCell = [[TimeCollectionCell alloc]init];
    [timeCollectionView registerNib:[UINib nibWithNibName:@"TimeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    timeArray = [[NSMutableArray alloc]initWithObjects:@"9:00 AM", @"10:00 AM", @"11:00 AM", @"12:00 PM", @"1:00 PM", @"2:00 PM", @"3:00 PM", @"4:00 PM", @"5:00 PM", @"6:00 PM", @"7:00 PM", @"8:00 PM", @"9:00 PM", @"10:00 PM", @"11:00 PM", @"12:00 AM", @"1:00 AM", @"2:00 AM", @"3:00 AM", @"4:00 AM", @"5:00 AM", @"6:00 AM", @"7:00 AM", @"8:00 AM", nil];
    selectedRowsArray = [[NSMutableArray alloc]init];
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loginAction:(UIButton *)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *myVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginId"];
    [self.navigationController pushViewController:myVC animated:YES];
    
}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
        return [timeArray count];
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = [[UIScreen mainScreen]bounds].size.width/6;
    CGSize retval =  CGSizeMake(width, width);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    if ([[UIScreen mainScreen]bounds].size.height == 1024)
//        return UIEdgeInsetsMake(25, 25, 25, 25);
//    else if ([[UIScreen mainScreen]bounds].size.height == 667)
//        return UIEdgeInsetsMake(8, 11, 8, 11);
//    else if ([[UIScreen mainScreen]bounds].size.height == 736)
//        return UIEdgeInsetsMake(8, 11, 8, 11);
//    else
        return UIEdgeInsetsMake(0, 0, 0, 0);//T,L,B,R
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    myCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    myCell.backgroundColor = [UIColor whiteColor];
    myCell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    myCell.layer.borderWidth = 0.5;
    myCell.timeLabel.text = [timeArray objectAtIndex:indexPath.row];
    CGRect rect = timeCollectionView.frame;
    rect.size.height = timeCollectionView.contentSize.height;
    timeCollectionView.frame = rect;
    
    rect = allDetailsView.frame;
    if ([[UIScreen mainScreen]bounds].size.height==667){
        rect.origin.y = timeCollectionView.frame.origin.y+timeCollectionView.frame.size.height-50;
        
        allDetailsView.frame = rect;
        
        rect = personalDetailsBgView.frame;
        rect.origin.y = allDetailsView.frame.origin.y+allDetailsView.frame.size.height+10;
        personalDetailsBgView.frame = rect;
        
        
        rect = saveButton.frame;
        rect.origin.y = personalDetailsBgView.frame.origin.y+personalDetailsBgView.frame.size.height+10;
        saveButton.frame = rect;
        
        rect = cancelButton.frame;
        rect.origin.y = personalDetailsBgView.frame.origin.y+personalDetailsBgView.frame.size.height+10;
        cancelButton.frame = rect;
    } else{
        rect = allDetailsView.frame;
        rect.origin.y = timeCollectionView.frame.origin.y+timeCollectionView.frame.size.height+10;
        allDetailsView.frame = rect;
        
    }

    return myCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    myCell = (TimeCollectionCell*)[timeCollectionView cellForItemAtIndexPath:indexPath];

    if (![selectedRowsArray containsObject:[timeArray objectAtIndex:indexPath.row]]) {
        [selectedRowsArray addObject:[timeArray objectAtIndex:indexPath.row]];
        myCell.backgroundColor = [UIColor colorWithRed:32/255.0f green:149/255.0f blue:133/255.0f alpha:1.0];
    }else{
        [selectedRowsArray removeObject:[timeArray objectAtIndex:indexPath.row]];
        myCell.backgroundColor = [UIColor whiteColor];
    }
    
    timeValueLabel.text = [selectedRowsArray componentsJoinedByString:@","];
    
    hoursValueLabel.text = [NSString stringWithFormat:@"%@(%lu)", [self formatCountNumber:[NSNumber numberWithInteger:[selectedRowsArray count]]], (unsigned long)[selectedRowsArray count]];

    float totalValue = [engineerEditorString integerValue]*[selectedRowsArray count];
    
    subTotalValueLabel.text = [NSString stringWithFormat:@"Rs.%f",totalValue];
    
    int all = totalValue;
    int correct = 10;
    float precentage = (all * correct)/100;
    CGFloat rounded_down = floorf(precentage * 100) / 100;   /* Result: 37.77 */

    otherChargesValueLabel.text = [NSString stringWithFormat:@"Rs.%f", rounded_down];
    totalValueLabel.text = [NSString stringWithFormat:@"Rs.%f", totalValue+rounded_down];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)formatCountNumber:(NSNumber*)inputNumber{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterSpellOutStyle;
    NSNumber *number = inputNumber;
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:[NSLocale localeIdentifierFromComponents:@{NSLocaleLanguageCode: @"us"}]];
    
    /* create a locale where diacritic marks are not considered important, e.g. US English */
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    
    NSString *input = [formatter stringFromNumber:number];
    
    /* get first char */
    NSString *firstChar = [input substringToIndex:1];
    
    /* remove any diacritic mark */
    NSString *folded = [firstChar stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:locale];
    
    /* create the new string */
    NSString *result = [[folded uppercaseString] stringByAppendingString:[input substringFromIndex:1]];
    return result;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setContentSizeOfBgScrollView:(float)height{
    bgScrollView.contentSize = CGSizeMake([[UIScreen mainScreen]bounds].size.width, height);
}

#pragma mark IBActions

- (IBAction)pushToTotalBookAction:(UIButton *)sender{
    
    
}

- (IBAction)previewAction:(UIButton *)sender{
    categoryLabel.text = @"Preview";
    monthLabel.hidden = YES;
    calendarImage.hidden = YES;
    previewButton.hidden = YES;
    timeCollectionView.hidden = YES;
    selectedDateBgView.hidden = YES;
    yourSelectionView.hidden = YES;
    availabilityBgView.hidden = YES;
    unavailableView.hidden = YES;
    
    totalAddToBookButton.frame = calendarImage.frame;
    [calendarView addSubview:totalAddToBookButton];

    CGRect rect = allDetailsView.frame;
    rect.origin.y = topMostBgView.frame.size.height+10;
    allDetailsView.frame = rect;
    rect = personalDetailsBgView.frame;
    rect.origin.y = allDetailsView.frame.origin.y+allDetailsView.frame.size.height+1;
    personalDetailsBgView.frame = rect;
    
    confirmView.frame = CGRectMake(10, personalDetailsBgView.frame.origin.y+personalDetailsBgView.frame.size.height+1, [[UIScreen mainScreen]bounds].size.width-20, confirmView.frame.size.height);
    [bgScrollView addSubview:confirmView];
    [self setContentSizeOfBgScrollView:confirmView.frame.origin.y+confirmView.frame.size.height+50];
}

- (IBAction)editPersonalDetailsAction:(UIButton *)sender {
    [personalDetailsTextView setEditable:YES];
    [personalDetailsTextView becomeFirstResponder];
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAction:(UIButton *)sender {
    saveButton.hidden = YES;
    cancelButton.hidden = YES;
    previewButton.frame = CGRectMake(40, saveButton.frame.origin.y, [[UIScreen mainScreen]bounds].size.width - 80, 40);
    [bgScrollView addSubview:previewButton];
    
}

- (IBAction)showCalendarAction:(UIView *)sender {
    
    bgDimView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    bgDimView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view.window addSubview:bgDimView];
    
    
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    calendar.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 400);
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/1990"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [bgDimView addSubview:calendar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}


#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
//    if ([self dateIsDisabled:date]) {
        dateItem.backgroundColor = [UIColor whiteColor];
        dateItem.textColor = [UIColor darkGrayColor];
//    }
}

//- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
//    return ![self dateIsDisabled:date];
//}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    [bgDimView removeFromSuperview];
    [self.calendar removeFromSuperview];
    //Getting date from string
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *dateTemp = [[NSDate alloc] init];
    dateTemp = [dateFormatter dateFromString:dateString];
    // converting into our required date format
    [dateFormatter setDateFormat:@"EE, dd MMM"];
    NSString *reqDateString = [dateFormatter stringFromDate:dateTemp];
    selectedDateLabel.text = reqDateString;
    dateValueLabel.text = selectedDateLabel.text;
    [self getBookedSlots:[self formatDate:dateTemp]];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

- (IBAction)addToBookAction:(UIButton *)sender {
}

- (IBAction)confirmBookingAction:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PaymentViewController *myVC = (PaymentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PaymentID"];
    myVC.totalHoursString = hoursValueLabel.text;
    myVC.bookedDateString = selectedDateLabel.text;
    myVC.timeSlotString = timeValueLabel.text;
    [self.navigationController pushViewController:myVC animated:YES];

}

- (IBAction)addAnotherBookingAction:(UIButton *)sender {
    [self performSelectorOnMainThread:@selector(setHiddenView) withObject:nil waitUntilDone:NO];
}

-(void)confirmBeforeBooking{
//    {
//        "Customer_ID": 1,
//        "Status": 1,
//        "objBooking": [
//                       {
//                           "Booking_ID": 1,
//                           "SrNo": '1',
//                           "StudioBranch_ID": 1,
//                           "ServiceType": "vOICE rEC,aUDIO rEC",
//                           "Dates": "30 Jan, 2014##21 Jan, 2015",
//                           "Slots": "4,1##3,4",
//                           "TotalAmount": 200,
//                           "CustomerName": "CN",
//                           "Email": "E",
//                           "Mobile": "M"
//                       },
//                       {
//                           "Booking_ID": 1,
//                           "SrNo": '2',
//                           "StudioBranch_ID": 1,
//                           "ServiceType": "ST,ST",
//                           "Dates": "30 Jan, 2014##20 Jan, 2015",
//                           "Slots": "11,2##3,4",
//                           "TotalAmount": 200,
//                           "CustomerName": "CN",
//                           "Email": "E",
//                           "Mobile": "M"
//                       }
//                       ]
//    }
    NSArray *arrayKey = [[NSArray alloc]initWithObjects:@"Customer_ID",@"Status", nil];
    
    NSArray *arrayObject = [[NSArray alloc]initWithObjects:@"1", @"1", nil];
    
    NSMutableArray *objBookingArray = [[NSMutableArray alloc]init];
    
    
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:arrayObject forKeys:arrayKey];
    
    [SingletonClass executeMultipart:[NSURL URLWithString:@"http://www.atcommobitech.in/MMIwebapi/api/Booking"] dict:questionDict withCompletionHandler:^(NSDictionary* dict){
        
        NSLog(@"booking slots are : %@", dict);
        if ([dict count]==0 || dict == nil) {
            
        }else{
            
        }
    }];
}

-(void)setHiddenView{
    categoryLabel.text = @"Music Studio";
    totalAddToBookButton.hidden = YES;
    [monthLabel setHidden:NO];
    [calendarImage setHidden:NO];
    confirmView.hidden = YES;
    [timeCollectionView setHidden:NO];
    [selectedDateBgView setHidden:NO];
    [yourSelectionView setHidden:NO];
    [availabilityBgView setHidden:NO];
    [unavailableView setHidden:NO];
    saveButton.hidden = NO;
    cancelButton.hidden = NO;
    
    CGRect rect = allDetailsView.frame;
    if ([[UIScreen mainScreen]bounds].size.height==667) {
        rect.origin.y = timeCollectionView.frame.origin.y+timeCollectionView.frame.size.height-50;
    }else
    rect.origin.y = timeCollectionView.frame.origin.y+timeCollectionView.frame.size.height+10;
    allDetailsView.frame = rect;
    rect = personalDetailsBgView.frame;
    rect.origin.y = allDetailsView.frame.origin.y+allDetailsView.frame.size.height+1;
    personalDetailsBgView.frame = rect;
    
    [self setContentSizeOfBgScrollView:saveButton.frame.origin.y+saveButton.frame.size.height+50];
}




@end
