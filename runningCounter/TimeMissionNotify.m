//
//  TimeMissionNotify.m
//  runningCounter
//
//  Created by ChingHua on 2015/1/26.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "TimeMissionNotify.h"

@interface TimeMissionNotify ()
{
    NSTimer *timeGo;
   
}


@end


@implementation TimeMissionNotify

-(id) init
{
    self = [super init];
    _timeCut = 300;
    timeGo = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timeGoCut) userInfo:nil repeats:YES];
    
    return self;
}

-(void) timeGoCut
{
    _timeCut -= 60;
//    [self.delegate dateNew];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DateNow" object:nil];
    if (_timeCut == 0) {
        
        [self timestop];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Delete" object:nil];
    }
//    NSLog(@"%d",_timeCut);
    
}

-(void) timestop
{
    [timeGo invalidate];
}

//-(void) timeCu
//{
//    [self.delegate dateNew];
//}

@end
