//
//  CalendarViewController.h
//  MMI
//
//  Created by Administrator on 23/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeCollectionCell.h"
#import "SlideNavigationController.h"
#import "LoginViewController.h"
#import "PaymentViewController.h"

@interface CalendarViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
    IBOutlet UILabel *categoryLabel;
    IBOutlet UILabel *monthLabel;
    IBOutlet UIView *calendarView;
    IBOutlet UIImageView *calendarImage;
    IBOutlet UICollectionView *timeCollectionView;
    TimeCollectionCell *myCell;
    IBOutlet UIScrollView *bgScrollView;
    IBOutlet UIView *topMostBgView;
    IBOutlet UIView *availabilityBgView;
    IBOutlet UIControl *unavailableView;
    IBOutlet UIControl *yourSelectionView;
    IBOutlet UIControl *availableView;
    IBOutlet UIView *selectedDateBgView;
    IBOutlet UILabel *selectedDateLabel;
    IBOutlet UILabel *bookingTimeLabel;
    IBOutlet UIView *allDetailsView;
    IBOutlet UIView *studioNameAddressBgView;
    IBOutlet UILabel *studioNameLabel;
    IBOutlet UILabel *studioAddressLabel;
    IBOutlet UIView *serviceBgView;
    IBOutlet UILabel *serviceNameLabel;
    IBOutlet UIView *dateBookingHoursBgView;
    IBOutlet UILabel *dateValueLabel;
    IBOutlet UILabel *timeValueLabel;
    IBOutlet UILabel *hoursValueLabel;
    IBOutlet UIView *chargesBgView;
    IBOutlet UILabel *subTotalValueLabel;
    IBOutlet UILabel *otherChargesValueLabel;
    IBOutlet UIView *totalBgView;
    IBOutlet UIView *personalDetailsBgView;
    IBOutlet UILabel *personalTitleLabel;
    IBOutlet UIButton *eidtPersonalDetailsButton;
    IBOutlet UITextView *personalDetailsTextView;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *previewButton;
    IBOutlet UIButton *totalAddToBookButton;
    IBOutlet UIView *confirmView;
    IBOutlet UIButton *addToBookButton;
    IBOutlet UIButton *confirmBookingButton;
    IBOutlet UIButton *addAnotherBookingButton;
    IBOutlet UIView *dismissView;
    IBOutlet UIButton *dismissButton;
    IBOutlet UILabel *totalValueLabel;
    
    NSMutableArray *timeArray;
    NSMutableArray *selectedRowsArray;
    NSMutableArray *availableSlotsArray;
    CGSize keyboardHeight;

}

@property (strong, nonatomic) NSString *studio_branchIDString;
@property (strong, nonatomic) NSString *studio_nameString;
@property (strong, nonatomic) NSString *studio_addressString;
@property (strong, nonatomic) NSString *engineerEditorString;

- (IBAction)editPersonalDetailsAction:(UIButton *)sender;
- (IBAction)cancelAction:(UIButton *)sender;
- (IBAction)saveAction:(UIButton *)sender;
- (IBAction)previewAction:(UIButton *)sender;
- (IBAction)showCalendarAction:(UIView *)sender;
- (IBAction)pushToTotalBookAction:(UIButton *)sender;
- (IBAction)addToBookAction:(UIButton *)sender;
- (IBAction)confirmBookingAction:(UIButton *)sender;
- (IBAction)addAnotherBookingAction:(UIButton *)sender;

@end
