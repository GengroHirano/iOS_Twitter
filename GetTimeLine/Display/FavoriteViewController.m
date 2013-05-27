//
//  FavoriteViewController.m
//  GetTimeLine
//
//  Created by oota akihiro on 2013/05/21.
//  Copyright (c) 2013年 12cm0105. All rights reserved.
//

#import "FavoriteViewController.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getFavorite] ;
    NSLog(@"%@", _favoriteArray) ;

    
    self.mainQueue = dispatch_get_main_queue();
    self.imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(!_favoriteArray){
        return 1;
    }
    else{
        return [_favoriteArray count] ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLineCell"] ;
    // Configure the cell...
    if (self.httpError) {
        cell.tweetTextLabel.text = self.httpError;
        cell.tweetTextLabelHeight = 24;
    } else if (!self.favoriteArray) {
        cell.tweetTextLabel.text = @"Loading...";
        cell.tweetTextLabelHeight = 24;
    } else {
        NSString *name = [[[self.favoriteArray objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"screen_name"];
        NSString *text = [[self.favoriteArray objectAtIndex:indexPath.row] objectForKey:@"text"];
        
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
            NSDictionary *tweetDictionary = [_favoriteArray objectAtIndex:indexPath.row];
            
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
    NSString *content = [[_favoriteArray objectAtIndex:indexPath.row] objectForKey:@"text"];
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
    TimeLineCell *cell = (TimeLineCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    //Stroyboard ID で設定したView Controllerを遷移先に設定する
    detailViewController.name = cell.nameLabel.text;
    detailViewController.text = cell.tweetTextLabel.text;
    detailViewController.image = cell.imageView.image;
    detailViewController.identifier = self.identifier;
    detailViewController->isFavorite = YES ; //お気に入りから飛んできたのか？
    // ...
    // Pass the selected object to the new view controller
    @try {
        detailViewController.idStr = [[self.favoriteArray objectAtIndex:indexPath.row] objectForKey:@"id_str"];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        //次のView Controllerへ遷移する（NavigationControllerの管理下で）
        NSLog(@"%@", indexPath) ;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception) ;
    }
}

- (void)getFavorite
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *account = [accountStore accountWithIdentifier:self.identifier];
    NSLog(@"%@", self.identifier) ;
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/favorites/list.json"] ;
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:nil];
    
    //  Attach an account to the request
    [request setAccount:account];
    
    //  Execute the request
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        if (responseData) {
            _httpError = nil;
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                NSError *jsonError;
                self.favoriteArray =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingAllowFragments
                                                  error:&jsonError];
                if (self.favoriteArray) {
                    //                    NSLog(@"Timeline Response: %@\n", self.timelineData);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
                else {
                    // Our JSON deserialization went awry
                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                }
            }
            else {
                // The server did not respond successfully... were we rate-limited?
                self.httpError =
                [NSString stringWithFormat:@"The response status code is %d", urlResponse.statusCode];
                NSLog(@"HTTP Error: %@", self.httpError);
            }
        }
    }];
    [self.tableView registerClass:[TimeLineCell class] forCellReuseIdentifier:@"TimeLineCell"];
    [self stopLoading] ;
}

- (void)refresh
{
    [self getFavorite] ;
}
@end
