//
//  TimeLineCell.m
//  GetTimeLine
//
//  Created by 12cm0105 on 2013/05/17.
//  Copyright (c) 2013年 12cm0105. All rights reserved.
//

#import "TimeLineCell.h"

@implementation TimeLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.tweetTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.tweetTextLabel.font = [UIFont systemFontOfSize:14.0f];
        self.tweetTextLabel.textColor = [UIColor blackColor];
        self.tweetTextLabel.numberOfLines = 0;
        [self.contentView addSubview:self.tweetTextLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
        self.nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    self.imageView.frame = CGRectMake(5, 5, 48, 48);
    self.tweetTextLabel.frame = CGRectMake(58, 5, 257, self.tweetTextLabelHeight);
    self.nameLabel.frame = CGRectMake(58, self.tweetTextLabelHeight + 15, 257, 12);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
