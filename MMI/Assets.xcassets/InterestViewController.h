//
//  InterestViewController.h
//  MMI
//
//  Created by Shaikh Razak on 10/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOTag.h"
#import "SlideNavigationController.h"

@interface InterestViewController : UIViewController<AOTagDelegate>
{
    NSMutableArray *selectedRowsArray;
    NSMutableArray *selectedTagsArray;
}

@property (retain) AOTagList *tag;
@property (retain) NSMutableArray *randomTag;

@end
