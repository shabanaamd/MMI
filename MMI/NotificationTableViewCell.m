
//
//  NotificationTableViewCell.m
//  MMI
//
//  Created by Shaikh Razak on 10/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell
@synthesize titleLabel, addressLabel, nameOnStudioLabel, dateLabel, bgView;


- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
