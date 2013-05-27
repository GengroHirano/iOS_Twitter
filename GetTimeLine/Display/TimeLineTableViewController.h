//
//  TimeLineTableViewController.h
//  GetTimeLine
//
//  Created by 12cm0105 on 2013/04/30.
//  Copyright (c) 2013年 12cm0105. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "DetailViewController.h"
#import "TimeLineCell.h"
//enum{
//    GET_TIME_LINE,
//    GET_REPLY
//} ;
@interface TimeLineTableViewController : UITableViewController
@property (nonatomic, copy) NSString *httpErrorMessage; //エラーログ記録用

@property(strong, nonatomic)ACAccountStore *accountStore ;
@property (nonatomic, strong) NSArray *timelineData;
@property (nonatomic, copy) NSString *identifier;
@property dispatch_queue_t mainQueue;
@property dispatch_queue_t imageQueue;
@property(nonatomic, strong)NSMutableArray *endPointsArray ;
- (IBAction)getReply:(id)sender;

@end
