//
//  DetailViewController.h
//  MMI
//
//  Created by Shaikh Razak on 19/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "HVTableView.h"
#import "CalendarViewController.h"
#import "CustomTableVC.h"

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, HVTableViewDataSource, HVTableViewDelegate, UIGestureRecognizerDelegate, CustomTableProtocol>
{
    IBOutlet UITableView *tableVw;
    CustomTableVC *customTable;
    NSMutableArray *headingArray;
    NSMutableArray *contentArray;
    NSMutableArray *expandArray;
    
    IBOutlet UILabel *categoryLabel;
    IBOutlet UILabel *studioNameLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UIView *bottomView;
    IBOutlet UIButton *reviewsButton;
    IBOutlet UIButton *ratingsButton;
    IBOutlet UIButton *bookButton;
    IBOutlet UIScrollView *bgScrollView;
    IBOutlet UILabel *ratingCountLabel;
    IBOutlet UILabel *reviewCountLabel;
    IBOutlet UIImageView *bannerImageView;
    IBOutlet UIImageView *thumbnailImageView1;
    IBOutlet UIImageView *thumbnailImageView2;
    IBOutlet UIImageView *thumbnailImageView3;
    
}

@property (strong, nonatomic) IBOutlet HVTableView *hvTable;
@property (strong, nonatomic) NSString *categoryNameString;
@property (strong, nonatomic) NSString *studioNameString;
@property (strong, nonatomic) NSString *addressString;
@property (strong, nonatomic) NSArray *costArray;
@property (strong, nonatomic) NSArray *servicesArray;
@property (strong, nonatomic) NSString *emailString;
@property (strong, nonatomic) NSString *contactNumberString;
@property (strong, nonatomic) NSString *websiteString;
@property (strong, nonatomic) NSString *contactUsString;
@property (strong, nonatomic) NSString *engineerEditorString;
@property (strong, nonatomic) NSString *timingString;
@property (strong, nonatomic) NSString *workingString;
@property (strong, nonatomic) NSString *ratingCountString;
@property (strong, nonatomic) NSString *ratingString;
@property (strong, nonatomic) NSString *reviewCountString;
@property (strong, nonatomic) UIImage *bannerImage;
@property (strong, nonatomic) NSArray *thumbnailImageArray;
@property (strong, nonatomic) NSString *thumbnailURLString;
@property (strong, nonatomic) NSString *studio_branchIDString;


- (IBAction)bookStudioAction:(UIButton *)sender;
-(IBAction)showOptions:(UIView*)sender;

@end
