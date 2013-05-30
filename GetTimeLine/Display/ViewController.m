//
//  ViewController.m
//  GetTimeLine
//
//  Created by 12cm0105 on 2013/04/30.
//  Copyright (c) 2013年 12cm0105. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //テーブルビューの設定
    _table.delegate = self ;
    _table.dataSource = self ;
	// Do any additional setup after loading the view, typically from a nib.
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:^(BOOL granted, NSError *error) {
                                                if (granted) {
                                                    self.twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
                                                    if (self.twitterAccounts > 0) {
                                                        ACAccount *account = [self.twitterAccounts lastObject];
                                                        self.identifier = account.identifier;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            _na.title = account.username ;
                                                            [self getTimeline:GET_TIMELINE] ;
                                                        });
                                                    }
                                                    else {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.na.title = @"アカウントなし";
                                                        });
                                                    }
                                                }
                                                else {
                                                    NSLog(@"Account Error: %@", [error localizedDescription]);
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        self.na.title = @"アカウント認証エラー";
                                                    });
                                                }
                                            }];
    self.mainQueue = dispatch_get_main_queue();
    self.imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    _endPointsArray = [[NSMutableArray alloc] initWithObjects:
                       @"https://api.twitter.com/1.1/statuses/home_timeline.json",
                       @"https://api.twitter.com/1.1/statuses/mentions_timeline.json",nil] ;
    //EGO_PULL_TO_REF
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc]
                                       initWithFrame:CGRectMake(0.0f, 0.0f - _table.bounds.size.height,
                                                                self.view.frame.size.width, _table.bounds.size.height)];
    view.delegate = self;
    [_table addSubview:view];
    _refreshHeaderView = view;
    [_refreshHeaderView refreshLastUpdatedDate];
}

//画面表示が始まる時にテーブルのリロードと選択の解除 ※必須
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [_table  deselectRowAtIndexPath:[_table indexPathForSelectedRow] animated:YES];
    
    [_table  reloadData];
}

//画面表示が終わる時にスクロールバーを点滅させる ※必須
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.table flashScrollIndicators];
    
}

//編集モードに入る時UITableViewの編集状態を維持するようにする ※必須
- (void)setEditing:(BOOL)flag animated:(BOOL)animated {
    
    [super setEditing:flag animated:animated];
    
    [_table setEditing:flag animated:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectAccount:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    sheet.delegate = self;
    
    sheet.title = @"選択してください。";
    for (ACAccount *account in self.twitterAccounts) {
        [sheet addButtonWithTitle:account.username];
    }
    [sheet addButtonWithTitle:@"キャンセル"];
    sheet.cancelButtonIndex = self.twitterAccounts.count;
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showInView:self.view];
    
}

- (IBAction)getReply:(id)sender {
    [self getTimeline:GET_REPLY] ;
//    [self getTimeline:GET_TIMELINE] ;
}

- (void)actionSheet:(UIActionSheet *)actionSheet  clickedButtonAtIndex:(NSInteger)buttonIndex { // アクションシート選択時の処理
    if (self.twitterAccounts.count > 0) {
        if (buttonIndex != self.twitterAccounts.count) {
            ACAccount *account = [self.twitterAccounts objectAtIndex:buttonIndex];
            self.identifier = account.identifier;
            self.na.title = account.username;
            NSLog(@"Account set! %@", account.username);
        }
        else {
            NSLog(@"cancel!");
        }
    }
}

- (IBAction)favorite:(id)sender {
    FavoriteViewController *favoriteViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteViewController"] ;
    favoriteViewController.identifier = self.identifier ;
    [self.navigationController pushViewController:favoriteViewController animated:YES] ;
}   
    
- (IBAction)tweet:(id)sender {
    TweetViewController *tweetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TweetViewController"] ;
    tweetViewController.identifier = self.identifier ;
    [self presentViewController:tweetViewController animated:YES completion:^(void){
        NSLog(@"画面遷移？") ;
    }] ;
}

- (void)getTimeline :(NSInteger)tag
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *account = [accountStore accountWithIdentifier:self.identifier];
    NSLog(@"%@", self.identifier) ;
    
    NSURL *url = [NSURL URLWithString:[_endPointsArray objectAtIndex:tag]] ;
    NSDictionary *params = @{@"count" : @"20",
                             @"trim_user" : @"0",
                             @"include_entities" : @"0"};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    
    //  Attach an account to the request
    [request setAccount:account];
    
    //  Execute the request
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        if (responseData) {
            self.httpErrorMessage = nil;
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                NSError *jsonError;
                self.timelineData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingAllowFragments
                                                  error:&jsonError];
                if (self.timelineData) {
                    //                    NSLog(@"Timeline Response: %@\n", self.timelineData);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.table reloadData];
                    });
                }
                else {
                    // Our JSON deserialization went awry
                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                }
            }
            else {
                // The server did not respond successfully... were we rate-limited?
                self.httpErrorMessage =
                [NSString stringWithFormat:@"The response status code is %d", urlResponse.statusCode];
                NSLog(@"HTTP Error: %@", self.httpErrorMessage);
            }
        }
    }];
    [self.table registerClass:[TimeLineCell class] forCellReuseIdentifier:@"TimeLineCell"];
    dispatch_async(_mainQueue, ^(void){
        load = NO ;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_table] ;
    }) ;
}


//scrollViewのデリゲートメソッド群
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

//EGORefreshのデリゲートメソッド群
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
//    dispatch_async(_imageQueue, ^(void){
        load = YES ;
        [self getTimeline:GET_TIMELINE] ;
//    }) ;
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return load ;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date] ;
}
//tableviewのデリゲートメソッド群
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_timelineData count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //            static NSString *CellIdentifier = @"Cell";
    //            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLineCell" forIndexPath:indexPath];
    // この行はテーブルビューセルの再利用で必要（iOS6以降）
    // Configure the cell...
    if (self.httpErrorMessage) {
        cell.tweetTextLabel.text = self.httpErrorMessage;
        cell.tweetTextLabelHeight = 24;
    } else if (!self.timelineData) {
        cell.tweetTextLabel.text = @"Loading...";
        cell.tweetTextLabelHeight = 24;
    } else {
        NSString *name = [[[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"screen_name"];
        NSString *text = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"text"];
        
        CGSize labelSize = [text sizeWithFont:[UIFont systemFontOfSize:16]
                            constrainedToSize:CGSizeMake(300, 1000)
                                lineBreakMode:NSLineBreakByWordWrapping];
        cell.tweetTextLabelHeight = labelSize.height;
        cell.tweetTextLabel.text = text;
        
        cell.nameLabel.text = name;
        
        cell.imageView.image = [UIImage imageNamed:@"blank.png"];
        
        UIApplication *application = [UIApplication sharedApplication];
        application.networkActivityIndicatorVisible = YES;
        
        dispatch_async(self.imageQueue, ^{
            NSString *url;
            NSDictionary *tweetDictionary = [self.timelineData objectAtIndex:indexPath.row];
            
            if ([[tweetDictionary allKeys] containsObject:@"retweeted_status"]) {
                // リツイートの場合はretweeted_statusキー項目が存在する
                url = [[[tweetDictionary objectForKey:@"retweeted_status"] objectForKey:@"user"] objectForKey:@"profile_image_url"];
            } else {
                url = [[tweetDictionary objectForKey:@"user"] objectForKey:@"profile_image_url"];
            }
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            dispatch_async(self.mainQueue, ^{
                UIApplication *application = [UIApplication sharedApplication];
                application.networkActivityIndicatorVisible = NO;
                UIImage *image = [[UIImage alloc] initWithData:data];
                cell.imageView.image = image;
                [cell setNeedsLayout];
            });
        });
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"text"];
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:16]
                           constrainedToSize:CGSizeMake(300, 1000)
                               lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height + 35;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
    TimeLineCell *cell = (TimeLineCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    //Stroyboard ID で設定したView Controllerを遷移先に設定する
    detailViewController.name = cell.nameLabel.text;
    detailViewController.text = cell.tweetTextLabel.text;
    detailViewController.image = cell.imageView.image;
    detailViewController.identifier = self.identifier;
    detailViewController->isFavorite = NO ;
    // ...
    // Pass the selected object to the new view controller
    @try {
        detailViewController.idStr = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"id_str"];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        //次のView Controllerへ遷移する（NavigationControllerの管理下で）
        NSLog(@"%@", indexPath) ;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception) ;
    }
}

@end
