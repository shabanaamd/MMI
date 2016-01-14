//
//  ListTableViewCell.h
//  MMI
//
//  Created by Shaikh Razak on 28/10/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
{
    
}
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UILabel *studioNameLabel;
@property(nonatomic, strong) UILabel *locationNameLabel;
@property(nonatomic, strong) UIButton *viewButton;
@property(nonatomic, strong) UIButton *shareButton;
@property(nonatomic, strong) UIButton *quickBookButton;
@property(nonatomic, strong) UIView *blackStrip;


@end
