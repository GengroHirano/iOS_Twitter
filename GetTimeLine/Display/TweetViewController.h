//
//  TweetViewController.h
//  TeitterClient02
//
//  Created by 12cm0105 on 2013/04/19.
//  Copyright (c) 2013年 12cm0105. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "ViewController.h"


@interface TweetViewController : UIViewController<UITextViewDelegate, UIAlertViewDelegate>

@property (copy, nonatomic)NSString *idStr ;
@property (strong, nonatomic) IBOutlet UITextView *tweetTextView;
@property (nonatomic, copy) NSString *identifier;
@property(nonatomic, copy) NSString *name ;
- (IBAction)editEndAction:(id)sender;
- (IBAction)tweetButton:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)combert:(id)sender;

@end
