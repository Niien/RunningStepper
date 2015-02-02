//
//  myPlist.h
//  runningCounter
//
//  Created by chiawei on 2015/1/25.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myPlist : NSObject


+ (myPlist *)shareInstanceWithplistName:(NSString *)name;

- (void)saveDataWithArray:(NSArray *)data;

- (void)saveDataByOverRide:(NSArray *)data;

- (NSMutableArray *)getDataFromPlist;

//- (NSArray *)getDataWithPokemonName:(NSString *)key;


@end
