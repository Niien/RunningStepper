//
//  UserProfileSingleton.h
//  runningCounter
//
//  Created by ChingHua on 2015/1/24.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfileSingleton : NSObject

// 通知的數量
@property NSMutableArray *notifydateArray;

+(UserProfileSingleton *) shareUserProfile;
-(id) init;


@end
