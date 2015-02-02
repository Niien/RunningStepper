//
//  UserProfileSingleton.m
//  runningCounter
//
//  Created by ChingHua on 2015/1/24.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "UserProfileSingleton.h"

@implementation UserProfileSingleton

static UserProfileSingleton *instance;

+(UserProfileSingleton *)shareUserProfile
{
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}

-(id)init
{
    if (instance == nil) {
        instance = [super init];
    }
    return instance;
}


@end
