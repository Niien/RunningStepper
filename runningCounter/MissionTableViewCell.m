//
//  MissionTableViewCell.m
//  runningCounter
//
//  Created by ChingHua on 2015/1/24.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "MissionTableViewCell.h"

@interface MissionTableViewCell ()

@end

@implementation MissionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.timeLabel = [UILabel new];
    CGRect timeLBFrame = CGRectMake(0,0/*self.frame.size.width-self.timeLabel.frame.size.width ,
                                    self.frame.origin.y+self.frame.size.height/4*/,
                                    self.frame.size.width/7,
                                    self.frame.size.height-self.frame.size.height/5);
    self.timeLabel.frame = timeLBFrame;
    self.timeLabel.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.timeLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
