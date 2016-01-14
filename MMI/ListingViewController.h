//
//  ListingViewController.h
//  MMI
//
//  Created by Administrator on 21/10/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "LeftViewController.h"
#import "LoginViewController.h"
#import "ListTableViewCell.h"
#import "CustomTableVC.h"
#import "DetailViewController.h"

@interface ListingViewController : UIViewController<SlideNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, CustomTableProtocol>
{
    IBOutlet UITableView *listTableView;
    IBOutlet UIView *audioStudioView;
    IBOutlet UIView *filterView;
    IBOutlet UIView *subcategoryView;
    IBOutlet UIView *nearbyView;
    IBOutlet UILabel *audioStudioLabel;
    IBOutlet UILabel *subCatLabel;

    __block UIView *filterBtnVw;
    UIView *filterVw;
    UIView *filterTableVw;
    
    NSMutableArray *listImagesArray;
    NSMutableArray *listImageURLArray;
    NSMutableArray *studioArray;
    NSMutableArray *locationArray;
    NSMutableArray *subCategoryArray;
    NSArray *jsonResponseArray;
    NSString *whichDropDown;
    NSDictionary *jsonDict;
}

@property (nonatomic, strong)NSString *subCatId;
@property (nonatomic, strong)NSString *subCatString;
@property (nonatomic, copy) void (^onCompletionGettingFilters)(void);

-(IBAction)audioStudioDropDownAction:(UIView*)sender;
-(IBAction)subCategoryDropDownAction:(UIView*)sender;
-(IBAction)filterAction:(UIView*)sender;
-(IBAction)nearbyAction:(UIView*)sender;

@end
