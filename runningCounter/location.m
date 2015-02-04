//
//  location.m
//  maptt
//
//  Created by chiawei on 2015/2/4.
//  Copyright (c) 2015年 chiawei. All rights reserved.
//

#import "ViewController.h"
#import "location.h"

@implementation location


static location *instance = nil;

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        
    }
    
    return self;
}


+(location *) share {
    
    if (instance == nil) {
        
        instance = [[location alloc]init];
        
    }
    
    return instance;
}


@end
