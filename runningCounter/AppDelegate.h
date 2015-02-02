//
//  AppDelegate.h
//  runningCounter
//
//  Created by Longfatown on 1/20/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import "StepCounter.h"
#import <UIKit/UIKit.h>
@import Parse;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) UILocalNotification *notify;
-(void)ReOderBadgeNumber;

@end

