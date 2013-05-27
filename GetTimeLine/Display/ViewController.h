//
//  ViewController.h
//  GetTimeLine
//
//  Created by 12cm0105 on 2013/04/30.
//  Copyright (c) 2013年 12cm0105. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "TimeLineTableViewController.h"
#import "FavoriteViewController.h"
#import "TweetViewController.h"
#import "EGORefreshTableHeaderView.h"
enum{
    GET_TIMELINE,
    TWEET
} ;
enum{
    GET_TIME_LINE,
    GET_REPLY
} ;
@interface ViewController : UIViewController
<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate>
{
    BOOL load ;
}
@property (strong, nonatomic) IBOutlet UITableView *table; //テーブルビュー
@property(nonatomic, strong)ACAccountStore *accountStore ;
@property(nonatomic, strong)NSArray *twitterAccounts ;
@property(nonatomic, copy)NSString *identifier ; //アカウントID
@property (nonatomic, copy) NSString *httpErrorMessage; //エラーログ記録用
@property (nonatomic, strong) NSArray *timelineData; //タイムラインデータ格納
@property(nonatomic, strong)NSMutableArray *endPointsArray ; //エンドポイント格納
@property (strong, nonatomic) IBOutlet UINavigationItem *na; //ナビゲーションバー
@property(strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property dispatch_queue_t mainQueue; //メインキュー
@property dispatch_queue_t imageQueue; //サブキュー
- (IBAction)favorite:(id)sender;
- (IBAction)tweet:(id)sender;
- (IBAction)selectAccount:(id)sender;
- (IBAction)getReply:(id)sender;
@end
