//
//  SingletonClass.m
//  MMI
//
//  Created by Shaikh Razak on 19/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "SingletonClass.h"

@implementation SingletonClass

#pragma mark Singleton Methods

+ (id)sharedManager {
    static SingletonClass *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {
    
    }
    return self;
}

+ (BOOL)checkInternetReachability{
    
//    Reachability *reachable =  [[Reachability class] reachabilityWithHostname:@"www.google.com"];
//    
//    NetworkStatus NetworkStatus = [reachable currentReachabilityStatus];
    
    return YES;
}

+ (void)noInternetLabel:(UIView*)view frame:(float)y text:(NSString*)displayText{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, y, [[UIScreen mainScreen]bounds].size.width, 30)];
    label.text = displayText;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:14];
    label.textColor = [UIColor lightGrayColor];
    [view addSubview:label];
}

+(void)showAlert:(NSString*)message title:(NSString*)title view:(UIViewController*)view{
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float >= 8.0){

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:title
                                      message:message
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
        
        [alert addAction:okButton];
        
        [view presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:view cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

+ (void)executeMultipart:(NSURL *)url dict:(NSDictionary*)jsonDict withCompletionHandler:(void (^)(NSDictionary *))handler
{
    NSError *error;
    NSData *paramsJSONDictionaryData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonParamsString = [[NSString alloc] initWithData:paramsJSONDictionaryData encoding:NSUTF8StringEncoding];
    NSData *postData = [jsonParamsString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data!=nil) {
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            handler(jsonDict);
        }
    }];
}

+(UIView*)addBlackLayer:(UIViewController*)vc acti:(UIActivityIndicatorView*)activity{
    UIView *layer = [[UIView alloc]initWithFrame:vc.view.frame];
    layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [vc.view addSubview:layer];
    
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.frame = CGRectMake(10, 20, 40, 40);
    activity.center = layer.center;
    [layer addSubview:activity];
    [activity startAnimating];
    activity.hidesWhenStopped = YES;
    return layer;
}


- (void)dealloc {
    // Should never be called, but just here for clarity really.
}






















@end
