//
//  TimeLineCell.h
//  GetTimeLine
//
//  Created by 12cm0105 on 2013/05/17.
//  Copyright (c) 2013年 12cm0105. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCell : UITableViewCell

@property (nonatomic, strong) UILabel *tweetTextLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) int tweetTextLabelHeight;

@end
