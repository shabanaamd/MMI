//
//  ListTableViewCell.m
//  MMI
//
//  Created by Shaikh Razak on 28/10/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell
@synthesize bgImageView, studioNameLabel, locationNameLabel, viewButton, blackStrip, shareButton, quickBookButton;

- (void)awakeFromNib {
    // Initialization code
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width, self.frame.size.height-10)];
    [self addSubview:bgView];
    
    bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
   // bgImageView.image = [UIImage imageNamed:@"list_image1"];
    [bgView addSubview:bgImageView];
    
    blackStrip = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height - 50, [[UIScreen mainScreen]bounds].size.width, 50)];
    blackStrip.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [bgImageView addSubview:blackStrip];
    
    studioNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
    studioNameLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    studioNameLabel.textColor = [UIColor whiteColor];
    studioNameLabel.backgroundColor = [UIColor clearColor];
    [blackStrip addSubview:studioNameLabel];
    studioNameLabel.text = @"Studio";
    
    locationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, studioNameLabel.frame.origin.y+studioNameLabel.frame.size.height-3, 200, 20)];
    locationNameLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    locationNameLabel.textColor = [UIColor whiteColor];
    locationNameLabel.backgroundColor = [UIColor clearColor];
    [blackStrip addSubview:locationNameLabel];
    locationNameLabel.text = @"Location";
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(blackStrip.frame.size.width - 80, 10, 60, blackStrip.frame.origin.y)];
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    [bgImageView bringSubviewToFront:view];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(10, 10, 50, 25);
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    [shareButton setImage:[UIImage imageNamed:@"share_list"] forState:UIControlStateNormal];
    [view addSubview:shareButton];
    
    quickBookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    quickBookButton.frame = CGRectMake(10, shareButton.frame.origin.y+shareButton.frame.size.height+5, 50, 25);
    quickBookButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    [quickBookButton setImage:[UIImage imageNamed:@"quickbook_list"] forState:UIControlStateNormal];
    [view addSubview:quickBookButton];
    
    viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    viewButton.frame = CGRectMake(blackStrip.frame.size.width - 80, 10, 50, 30);
    [viewButton setTitle:@"View" forState:UIControlStateNormal];
    [viewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[viewButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    viewButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    viewButton.layer.borderWidth = 0.6;
    viewButton.layer.cornerRadius = 3.0;
    [blackStrip addSubview:viewButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
