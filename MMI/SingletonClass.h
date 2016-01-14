//
//  SingletonClass.h
//  MMI
//
//  Created by Shaikh Razak on 19/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Reachability.h"
#import <UIKit/UIKit.h>

@interface SingletonClass : NSObject

+ (id)sharedManager;
+ (BOOL)checkInternetReachability;
+ (void)noInternetLabel:(UIView*)view frame:(float)y text:(NSString*)displayText;
+(void)showAlert:(NSString*)message title:(NSString*)title view:(UIViewController*)view;
+ (void)executeMultipart:(NSURL *)url dict:(NSDictionary*)jsonDict withCompletionHandler:(void (^)(NSDictionary *))handler;
+(UIView*)addBlackLayer:(UIViewController*)vc acti:(UIActivityIndicatorView*)activity;
@end
