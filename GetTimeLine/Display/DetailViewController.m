//
//  DetailViewController.m
//  GetTimeLine
//
//  Created by 12cm0105 on 2013/05/10.
//  Copyright (c) 2013年 12cm0105. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.imageView.image = self.image;
    self.nameView.text = self.name;
    self.textView.text = self.text;
    
    _endPointsArray = [[NSMutableArray alloc] init] ;
    [_endPointsArray setObject:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/destroy/%@.json", self.idStr] atIndexedSubscript:DELETE_TWEET] ;
    [_endPointsArray setObject:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json", self.idStr] atIndexedSubscript:RETWEET] ;
    [_endPointsArray setObject:[NSString stringWithFormat:@"https://api.twitter.com/1.1/favorites/create.json"] atIndexedSubscript:FAVORITE] ;
    [_endPointsArray setObject:[NSString stringWithFormat:@"https://api.twitter.com/1.1/favorites/destroy.json"] atIndexedSubscript:REMOVE] ;
    
    _params = nil ;
    
    if(isFavorite){
//        UIBarButtonItem *item = [[_tool items] objectAtIndex:2] ;
//        [item initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(favoriteAction:)] ;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
            break;
            
        case 1:
            [self dataRequest:[_endPointsArray objectAtIndex:alertView.tag] parameters:_params] ;
            break;
    }
}

- (IBAction)retweetAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Retweet" message:@"本当にしますか？" delegate:self cancelButtonTitle:@"やめときます" otherButtonTitles:@"やります！", nil] ;
    alert.tag = RETWEET ;
    [alert show] ;
}

- (IBAction)favoriteAction:(id)sender {
    if(isFavorite){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"お気に入りから外す" message:@"本当にしますか？" delegate:self cancelButtonTitle:@"やめときます" otherButtonTitles:@"やります！", nil] ;
        alert.tag = REMOVE ;
        [alert show] ;
        _params = @{@"id" : self.idStr} ;
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"お気に入り登録" message:@"本当にしますか？" delegate:self cancelButtonTitle:@"やめときます" otherButtonTitles:@"やります！", nil] ;
        alert.tag = FAVORITE ;
        [alert show] ;
        _params = @{@"id" : self.idStr, @"include_entities" : @"true"} ;
    }
}

- (IBAction)deleteTweet:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ツイート取り消し" message:@"本当にしますか？" delegate:self cancelButtonTitle:@"やめときます" otherButtonTitles:@"やります", nil] ;
    alert.tag = DELETE_TWEET ;
    [alert show] ;
}

- (void)dataRequest:(NSString *)endPoints parameters:(NSDictionary *)parms
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *account = [accountStore accountWithIdentifier:self.identifier];

    NSURL *url = [NSURL URLWithString:endPoints];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:parms];
    //  Attach an account to the request
    [request setAccount:account];
    
    UIApplication *application = [UIApplication sharedApplication] ;
    application.networkActivityIndicatorVisible = YES ;
    
    
    //  Execute the request
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIApplication *application = [UIApplication sharedApplication] ;
            application.networkActivityIndicatorVisible = NO ;
            if(endPoints ==  [_endPointsArray objectAtIndex:DELETE_TWEET] ||
               endPoints == [_endPointsArray objectAtIndex:REMOVE]){
                [self.navigationController popViewControllerAnimated:YES] ; //一個前のやつに戻るぜよ！
            }
        }) ;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TweetViewController *tweetViewController = [segue destinationViewController] ;
    tweetViewController.idStr = _idStr ;
    tweetViewController.identifier = _identifier ;
    tweetViewController.name = _name ;
}

@end
