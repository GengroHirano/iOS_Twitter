//
//  DetailViewController.h
//  GetTimeLine
//
//  Created by 12cm0105 on 2013/05/10.
//  Copyright (c) 2013年 12cm0105. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TweetViewController.h"

enum{
    DELETE_TWEET,
    RETWEET,
    FAVORITE,
    REMOVE
} ;
@interface DetailViewController : UIViewController<UIAlertViewDelegate>
{
   @public BOOL isFavorite ;
}
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *identifier;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *nameView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) NSString *idStr;

@property(nonatomic, strong)NSMutableArray *endPointsArray ; //エンドポイントを格納する
@property(nonatomic, strong)NSDictionary *params ;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *favoriteButtonItem;
@property (strong, nonatomic) IBOutlet UIToolbar *tool;

- (IBAction)retweetAction:(id)sender;
- (IBAction)favoriteAction:(id)sender;
- (IBAction)deleteTweet:(id)sender;

@end
