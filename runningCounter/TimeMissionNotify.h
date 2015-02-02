//
//  TimeMissionNotify.h
//  runningCounter
//
//  Created by ChingHua on 2015/1/26.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfileSingleton.h"


@protocol TimeMissionNotifyDelegate <NSObject>
//@optional
-(void) dateNew;

@end

@interface TimeMissionNotify : NSObject

@property (nonatomic,weak) id<TimeMissionNotifyDelegate> delegate;

@property int timeCut;
@property NSDate *firstTime;


-(id) init;

@end
