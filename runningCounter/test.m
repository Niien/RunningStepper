//
//  test.m
//  runningCounter
//
//  Created by chiawei on 2015/1/28.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "test.h"

@implementation test
test *mytest;

- (id) init {
    
    self = [super init];
    
    return self;
}

+ (test *)share {
    
    if (mytest == nil) {
        mytest = [[test alloc]init];
    }
    
    return mytest;
}

@end
