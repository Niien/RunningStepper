//
//  location.h
//  maptt
//
//  Created by chiawei on 2015/2/4.
//  Copyright (c) 2015年 chiawei. All rights reserved.
//

@import CoreLocation;
#import <Foundation/Foundation.h>

@interface location : NSObject 


@property (strong, nonatomic) CLLocation *userLocation;


+(location *) share;


@end
