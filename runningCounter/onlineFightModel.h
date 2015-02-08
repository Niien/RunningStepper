//
//  onlineFightModel.h
//  runningCounter
//
//  Created by chiawei on 2015/2/8.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import <Foundation/Foundation.h>

@class onlineFightModel;
@protocol onlineFightModelDelegate <NSObject>

@optional
- (void)wasKilledBy:(NSString *)name;
- (void)wasAttacked:(NSInteger)resultHP By:(NSString *)name;

@end


@interface onlineFightModel : NSObject

@property (weak, nonatomic) id<onlineFightModelDelegate> delegate;

- (id)init;

- (void)AttackToEnemy:(NSInteger)attack EnemyHP:(NSInteger)HP By:(NSString *)name;


@end
