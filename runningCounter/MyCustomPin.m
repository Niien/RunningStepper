//
//  MyCustomPin.m
//  runningCounter
//
//  Created by chiawei on 2015/1/21.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "MyCustomPin.h"

@implementation MyCustomPin

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if ([reuseIdentifier  isEqualToString: @"hospital"]) {
        
        UIImage *image = [UIImage imageNamed:@"hospital_25.png"];
        
        self.frame = CGRectMake(0, 0, 10, 10);
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width, self.frame.size.height)];
        
        imageView.image = image;
        
        [self addSubview:imageView];
        
    }
    else if ([reuseIdentifier isEqualToString:@"convenience_store"]) {
        
        UIImage *image = [UIImage imageNamed:@"cart_25.png"];
        
        self.frame = CGRectMake(0, 0, 5, 5);
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        
        [self addSubview:imageView];
        
    }
    else {
        
        UIImage *image = [UIImage imageNamed:reuseIdentifier];
        
        self.frame = CGRectMake(25, 25, 10, 10);
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        
        [self addSubview:imageView];
        
    }
    
    
    return self;
}


@end
