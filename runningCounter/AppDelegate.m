//
//  AppDelegate.m
//  runningCounter
//
//  Created by Longfatown on 1/20/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    NSUserDefaults *first;
}
@end

@implementation AppDelegate

-(void)ReOderBadgeNumber {
    //重新安排應用程式的按鈕的提示數字
    //查看目前剩餘的通知數
    NSArray *notifys = [[UIApplication sharedApplication] scheduledLocalNotifications];
    int index = 1;
    for (_notify in notifys) {
        
        _notify.applicationIconBadgeNumber = index; //安排新的badge number給每一筆資料
        
        [[UIApplication sharedApplication] scheduleLocalNotification:_notify]; //重新安排
        index++;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //====== 裝置版本判斷，註冊LocalNotification
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil ]];
        }
    }
    //====== 裝置版本判斷
    
    //====== Parse
    [Parse enableLocalDatastore];   //允許本地儲存
//
//    // Initialize Parse(初始化)
//    [Parse setApplicationId:@"37sMr08M1ovb6en1nQ7mm6wMa0wZS9w8EBrb8203"
//                  clientKey:@"VPIfQhgqixZKALeTzbhIurFTwYOrLZZPqRYS9oRn"];
//    
//    // [Optional] Track statistics around application opens.
//    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    //====== Parse
    
    [self copyDBtoDocumentIfNeeded];
    
    
    // register notification
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    
    // set tabBar item image
    [self changeTabBarItemImage];
    
    NSTimeZone *zone = [NSTimeZone defaultTimeZone];//獲得當前應用程序的時區
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒為單位返回當前應用程序與世界標準時間（格林威尼時間）的時差
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:interval];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    
    NSString *dateString = [[NSUserDefaults standardUserDefaults]objectForKey:@"LastDate"];
    if (dateString == nil) {
        
        NSString *dateString = [dateFormat stringFromDate:date];
        
        first =[NSUserDefaults standardUserDefaults];
        [first setInteger:0 forKey:@"DaySteps"];
        [first setInteger:0 forKey:@"Power"];
        [first setObject:dateString forKey:@"LastDate"];
        [first synchronize];
        NSLog(@"first");
    }
    else {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *lastDate = [dateFormat dateFromString:dateString];
        
        NSString *nowDateString = [dateFormat stringFromDate:date];
        NSDate *nowDate = [dateFormat dateFromString:nowDateString];
        if ([lastDate isEqualToDate:nowDate]) {
            first =[NSUserDefaults standardUserDefaults];
            
            [[StepCounter shareStepCounter]setPower:[first integerForKey:@"Power"]];
            
            [[StepCounter shareStepCounter]setStepNB:[first integerForKey:@"DaySteps"]];
            
            NSLog(@"Second");
        } else {
            first =[NSUserDefaults standardUserDefaults];
            
            [[StepCounter shareStepCounter]setPower:[first integerForKey:@"Power"]];
            
            [[StepCounter shareStepCounter]setStepNB:0];
            
        }
        
        
    }
   
    

    
    
    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //系統送過來的本地通知，ＡＰＰ執行時或使用中都會進來這邊
    //或ＡＰＰ在背景，沒有使用時，點選橫幅．提醒都會進來
    _notify.applicationIconBadgeNumber = 0;
    [self ReOderBadgeNumber];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    _notify.applicationIconBadgeNumber = 0;
    [self ReOderBadgeNumber];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {//程序到前景時
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    _notify.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
    [self ReOderBadgeNumber];
}

- (void)applicationWillTerminate:(UIApplication *)application { //當程式被結束時
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"You close App, can't step counter.";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    first =[NSUserDefaults standardUserDefaults];
    NSInteger power = [[StepCounter shareStepCounter]power];
    [first setInteger:power forKey:@"Power"];
    NSInteger step = [[StepCounter shareStepCounter]stepNB];
    [first setInteger:step forKey:@"DaySteps"];
    [first synchronize];
    NSLog(@"closs %ld",(long)power);
}


#pragma mark -SQLite
- (NSString*)getBundleFilePath_filename:(NSString*)filename
{
    NSString *bundleResourcePath = [[NSBundle mainBundle]resourcePath];
    NSString *dbPath = [bundleResourcePath stringByAppendingPathComponent:filename];
    return dbPath;
}


- (NSString*)getDBPath_filename:(NSString*)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documenPath = [paths firstObject];
    NSString *dbPath = [documenPath stringByAppendingPathComponent:filename];
    //NSLog(@"%@",dbPath);
    return dbPath;
}


- (void)copyDBtoDocumentIfNeeded
{
    //readable DB
    NSString *dbPath = [self getDBPath_filename:@"pokemonDatabase.sqlite"];
    
    //origenal DB(sample data table)
    NSString *defaultDbPath = [self getBundleFilePath_filename:@"pokemonDatabase.sqlite"];
    
    //check file is exit or not
    NSFileManager *fileMansger = [NSFileManager defaultManager];
    NSError *error;
    BOOL success;
    success = [fileMansger fileExistsAtPath:dbPath];
    if (!success) {
        //copy sample table to document is Needed;
        success = [fileMansger copyItemAtPath:defaultDbPath toPath:dbPath error:&error];
        if (!success) {
            NSLog(@"Error: %@",[error description]);
        }
        
    }else{
        /*
         if db/table change structure is needed;
         1. copy mydatabase.sqlite to _mydatabase.sqlite
         2. move the data of _mydatabase.sqlite to mydatabase.sqlite(which table is change)
         3. check the move data is correct,and delet _mydatabase!
         4. change the Method - (id)queryCust
         */
    }
}



#pragma mark - tabBar item image

- (void)changeTabBarItemImage {
    
    UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
    
    UITabBar *myTabBar = tbc.tabBar;
    
    myTabBar.barTintColor = [UIColor blackColor];
    myTabBar.backgroundImage = [UIImage imageNamed:@"tabBar2.png"];
    
    UITabBarItem *myItem = [myTabBar.items objectAtIndex:0];
    myItem.image = [[UIImage imageNamed:@"home_30.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *myItem2 = [myTabBar.items objectAtIndex:1];
    myItem2.image = [[UIImage imageNamed:@"mission_30.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *myItem3 = [myTabBar.items objectAtIndex:2];
    myItem3.image = [[UIImage imageNamed:@"book_30.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *myItem4 = [myTabBar.items objectAtIndex:3];
    myItem4.image = [[UIImage imageNamed:@"setting_30.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

@end
