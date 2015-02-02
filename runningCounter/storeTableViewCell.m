//
//  storeTableViewCell.m
//  runningCounter
//
//  Created by chiawei on 2015/1/29.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "storeTableViewCell.h"

@implementation storeTableViewCell
{
    UIView *cellView;
    
    NSString *inputTitle;
    NSString *subTitle;
    
    UIImage *itemImage;
}

- (void)awakeFromNib {
    // Initialization code
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    cellView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/10, 10, self.frame.size.width-self.frame.size.width/4, (self.frame.size.width-self.frame.size.width/10)/2)];

    cellView.backgroundColor = [UIColor whiteColor];
    
    cellView.layer.masksToBounds = YES;
    
    cellView.layer.cornerRadius = 10.0;
    
    [self.contentView addSubview:cellView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/10, cellView.frame.size.height/7, cellView.frame.size.width, 40)];
    [self.contentView addSubview:title];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor yellowColor];
    [title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    title.textColor = [UIColor blackColor];
    [title setText: inputTitle];
    
    
    UILabel *detailTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/10+cellView.frame.size.width/5*2, cellView.frame.size.height/5*3, self.frame.size.width/2, 30)];
    [self.contentView addSubview:detailTitle];
    detailTitle.textAlignment = NSTextAlignmentCenter;
    //detailTitle.backgroundColor = [UIColor lightGrayColor];
    [title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    detailTitle.textColor = [UIColor blackColor];
    [detailTitle setText: subTitle];
    
    
    [self showImage];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:itemImage];
    [imageView setFrame:CGRectMake(self.frame.size.width/10, cellView.frame.size.height/2,cellView.frame.size.height/2, cellView.frame.size.width/5 )];
    [self.contentView addSubview:imageView];
    
}


- (void)addLabelwithtext:(NSString *)text subTitle:(NSString *)subtext
{
    
    inputTitle = text;
    
    subTitle = subtext;
}


- (void)showImage {
    
    if (![inputTitle containsString:@"補品"]) {
        itemImage = [UIImage imageNamed:@"power_100.png"];
    }
    
}



//cardTitle = [[UILabel alloc] initWithFrame:CGRectZero];
//[[self contentView] addSubview:cardTitle];
//[cardTitle setFrame:CGRectMake(10.0, 5.0, cardWidth - 20.0, 30.0)];
//cardTitle.textAlignment = NSTextAlignmentLeft;
//cardTitle.backgroundColor = [UIColor whiteColor];
//[cardTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
//cardTitle.textColor = [UIColor blackColor];
//[cardTitle setText:@"CARD TITLE"];


@end
