//
//  onlineFightModel.m
//  runningCounter
//
//  Created by chiawei on 2015/2/8.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "onlineFightModel.h"

@implementation onlineFightModel


- (id)init
{
    self = [super init];
    
    return self;
}


- (void)AttackToEnemy:(NSInteger)attack EnemyHP:(NSInteger)HP By:(NSString *)name
{
    
    NSLog(@"HP:%ld",(long)HP);
    HP -= attack;
    NSLog(@"HP:%ld",(long)HP);
    
    if (HP <= 0) {
        
        //[self performSelector:@selector(wasKilledBy:) withObject:nil afterDelay:1.5];
        [self.delegate wasKilledBy:name];
        
    }
    
    else {
        
        //[self performSelector:@selector(wasAttacked:By:) withObject:nil afterDelay:1.5];
        [self.delegate wasAttacked:HP By:name];

    }
    
}





@end
