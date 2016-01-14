//
//  ViewController.h
//  MMI
//
//  Created by Administrator on 20/10/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ListingViewController.h"
#import "SlideNavigationController.h"
#import "LeftViewController.h"
#import "LoginViewController.h"
#import "AddStudioViewController.h"
#import "SingletonClass.h"
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate, SlideNavigationControllerDelegate, UISearchBarDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    UIStoryboard *storyBoard;
    IBOutlet UISearchBar *homeSearchBar;
    IBOutlet UIScrollView *imageSlider;
    IBOutlet UIPageControl *pager;
    IBOutlet UIView *audioStudioView;
    IBOutlet UIView *indoorStudioView;
    IBOutlet UIView *jamRoomVIew;
    IBOutlet UIView *rehearsalHallView;
    IBOutlet UIView *addStudioView;
    IBOutlet UIView *inviteFriendsView;
    IBOutlet UIActivityIndicatorView *activity;
    
    NSMutableArray *catImageArray;
    NSMutableArray *catNameArray;
    NSMutableArray *sliderImagesArray;
    NSMutableArray *sliderImageIdArray;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;

-(IBAction)pushToList:(UIView*)sender;
-(IBAction)addStudioAction:(UIView*)sender;
-(IBAction)getLocationsAction:(UIButton*)sender;


@end

