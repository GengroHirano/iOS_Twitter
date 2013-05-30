//
//  TweetViewController.m
//  TeitterClient02
//
//  Created by 12cm0105 on 2013/04/19.
//  Copyright (c) 2013年 12cm0105. All rights reserved.
//

#import "TweetViewController.h"

@interface TweetViewController ()

@end

@implementation TweetViewController

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
    
    NSLog(@"%@", _idStr) ;
    NSLog(@"%@", _identifier) ;
    //アクセサリビューの作成(メインとフッターの2段構造になってる)
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] ;
    accessoryView.backgroundColor = [UIColor clearColor] ; //透明色
    UIView *accessoryViewFutter = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 5)] ;
    accessoryViewFutter.backgroundColor = [UIColor grayColor] ;
    [accessoryView addSubview:accessoryViewFutter] ;
    //ボタンの作成
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [button setImage:[UIImage imageNamed:@"PullDownButton.png"] forState:UIControlStateNormal] ;
    [button addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventTouchUpInside] ;
    button.frame = CGRectMake(281, 22, 40, 30) ;
    [accessoryView addSubview:button] ;
    
    _tweetTextView.inputAccessoryView =  accessoryView ;
    if (_idStr != nil) {
        _tweetTextView.text = [NSString stringWithFormat:@"@%@ ",_name] ;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)endEdit:(id)sender{
    [_tweetTextView resignFirstResponder] ;
}

- (IBAction)tweetButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"本当にこれでつぶやくのですな？" message:@"口は災いの元" delegate:self cancelButtonTitle:@"やめとくでござる" otherButtonTitles:@"つぶやくでござる", nil] ;
    [alert show] ;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"戻った") ;
    }] ;
}

- (IBAction)combert:(id)sender {
    NSString *stringAfter = _tweetTextView.text;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"さん" withString:@"氏"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"ありがとう" withString:@"ありがたき幸せ"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"妹" withString:@"妹君"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"様" withString:@"殿"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"あんた" withString:@"貴殿"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"おまえ" withString:@"貴殿"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"お前" withString:@"貴殿"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"あなた" withString:@"おぬし"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"君" withString:@"貴殿"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"お手洗い" withString:@"おちょうずば"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"弟" withString:@"弟君"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"貴様" withString:@"おのれー"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"ありがたい" withString:@"かたじけない"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"助かる" withString:@"かたじけない"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"了解" withString:@"がってんでい"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"トイレ" withString:@"厠"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"はい" withString:@"御意"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"誰" withString:@"曲者"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"ございません" withString:@"ございますまい"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"俺" withString:@"拙者"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"私" withString:@"それがし"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"僕" withString:@"まろ"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"自分" withString:@"拙者"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"バカ" withString:@"たわけ"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"馬鹿" withString:@"たわけ"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"です" withString:@"でござる"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"メッセージ" withString:@"文"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"ません" withString:@"ませぬ"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"違う" withString:@"否！"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"腹減った" withString:@"武士は食ねど高楊枝"] ;
    stringAfter = [stringAfter stringByReplacingOccurrencesOfString:@"疲れた" withString:@"体力を消耗したでござる"] ;
    _tweetTextView.text = stringAfter ;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
            
        case 1:
        {
                    NSDictionary *params ;
                    if(_idStr != nil){
                        params = @{@"status" : _tweetTextView.text, @"in_reply_to_status_id" : _idStr};
                        NSLog(@"リプライの方をしたのでござる") ;
                    }
                    else{
                        params = @{@"status" : _tweetTextView.text};
                    }
                    //            UIImage *image = [UIImage imageNamed:@"blackbird.jpg"];
                    //            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
                    //                        NSData *imageData = UIImagePNGRepresentation(image);
                    //            [request addMultipartData:imageData
                    //                             withName:@"media[]"
                    //                                 type:@"image/png"
                    //                             filename:@"blackbird.jpg"];
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            ACAccount *account = [accountStore accountWithIdentifier:self.identifier];
            
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
            
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
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
                    [self dismissViewControllerAnimated:YES completion:^(void){
                        NSLog(@"閉じるぜ！") ;
                    }] ;
                }) ;
            }];
        }
            break ;
        default:
            break;
    }
}
@end
