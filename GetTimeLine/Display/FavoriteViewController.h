//
//  FavoriteViewController.h
//  GetTimeLine
//
//  Created by oota akihiro on 2013/05/21.
//  Copyright (c) 2013年 12cm0105. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <Security/Security.h>
#import "ViewController.h"
#import "PullRefreshTableViewController.h"
@interface FavoriteViewController : PullRefreshTableViewController
@property (nonatomic, copy) NSString *httpError; //エラーログ記録用
@property(strong, nonatomic)NSArray *favoriteArray ;
@property(copy, nonatomic)NSString *identifier ;
@property dispatch_queue_t mainQueue; //メインキュー
@property dispatch_queue_t imageQueue; //サブキュー
- (void)getFavorite ;
@end
