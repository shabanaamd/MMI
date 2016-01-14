//
//  InterestViewController.m
//  MMI
//
//  Created by Shaikh Razak on 10/11/15.
//  Copyright © 2015 AtcomMobiTech. All rights reserved.
//

#import "InterestViewController.h"

@interface InterestViewController ()

@end

@implementation InterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Interests";
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateNormal];
    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:rightBarButtonItem, nil] animated:NO];
    
    selectedRowsArray = [[NSMutableArray alloc]init];
    selectedTagsArray = [[NSMutableArray alloc]init];
    
    self.tag = [[AOTagList alloc] initWithFrame:CGRectMake(40.0f,50.0f, [[UIScreen mainScreen]bounds].size.width-80, self.view.frame.size.height-self.tag.frame.origin.y+self.tag.frame.size.height)];
    //self.tag.backgroundColor = [UIColor redColor];
    [self.tag setTagFont:@"Helvetica" withSize:14.0f];
    [self.tag setDelegate:self];
    [self.view addSubview:self.tag];
    self.tag.hidden = NO;
    self.randomTag = [[NSMutableArray alloc]initWithObjects:@"Mumbai", @"Pune", @"Coimbatore",@"Punjab",@"Hyderabad", @"Chennai", @"Goa",@"Orissa", nil];
    for (int i = 0; i < [self.randomTag count]; i++) {
        [self addRandomTag:i];
    }
    //    [self.tag removeAllTag];
    
    // Do any additional setup after loading the view.
}


- (void)addRandomTag:(int)index
{
    NSLog(@"%lu %@ ", (unsigned long)[self.randomTag count], self.randomTag);
    if ([self.randomTag count])
    {
        self.tag.tag = index;
        [self.tag addTag:[self.randomTag objectAtIndex:index] withImage:nil];
        //        [selectedRowsArray addObject:[self.randomTag objectAtIndex:index]];
        //        [self.randomTag removeObjectAtIndex:index];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                        message:@"No more random data to be used !"
                                                       delegate:self
                                              cancelButtonTitle:@"Reset"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Tag delegate

- (void)tagDidAddTag:(AOTag *)tag
{
    //NSLog(@"Tag > %@ has been added", [autoFillArray  objectAtIndex:[self getRandomTagIndex]]);
    
}

- (void)tagDidRemoveTag:(AOTag *)tag
{
    NSLog(@"Tag > %@ has been removed", tag.tTitle);
    [selectedRowsArray removeObject:tag.tTitle];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
