//
//  CustomTableVC.h
//  MMI
//
//  Created by Shaikh Razak on 03/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CustomTableProtocol <NSObject>

-(void)tableViewItemSelected:(NSString*)selectedItem;

@end


@interface CustomTableVC : UITableViewController
{
    
}

@property(nonatomic, strong)NSMutableArray *listArray;
@property(nonatomic, assign)int font;
@property(nonatomic, assign)BOOL isCheckBoxHidden;
@property(nonatomic, strong)NSMutableArray *selectedRowsArray;
@property(nonatomic, strong)NSString *whichDropDown;
@property (nonatomic,assign) id<CustomTableProtocol>customDelegate;

@end
