//
//  test.h
//  runningCounter
//
//  Created by chiawei on 2015/1/28.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface test : NSObject

@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lon;

+ (test *)share;
@end
