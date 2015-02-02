//
//  StepCounter.h
//  runningCounter
//
//  Created by ChingHua on 2015/1/24.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import "MissionTableViewController.h"
#import "UserProfileSingleton.h"
#import "TimeMissionNotify.h"

@import CoreMotion;
@import UIKit;

@interface StepCounter : NSObject

// 新 舊 的步數
@property NSInteger stepNB;

@property NSInteger power;

+(StepCounter*)shareStepCounter;
-(void)startStepCounter ;
-(void)stopStepCounter;

@end
