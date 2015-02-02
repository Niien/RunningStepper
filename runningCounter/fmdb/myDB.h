//
//  myDB.h
//  CustManger
//
//  Created by 廖宗綸 on 2014/12/22.
//  Copyright (c) 2014年 Joseph Liao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface myDB : NSObject
{
    FMDatabase *db;
}

+(myDB *)sharedInstance;

-(id)queryCust_TableName:(NSString*)TableName TableArray:(NSArray*)TableArray OrderBy:(NSString*)OrderBy;

//search customer
-(id)queryCust_TableName:(NSString*)TableName TableArray:(NSArray*)TableArray OrderBy:(NSString*)OrderBy TargetName:(NSString*)TargetName TargetInside:(NSString*)TargetInside;
//SQLite Method
-(void)insertCustNo_TableName:(NSString*)TableName TableArray:(NSArray*)TableArray TableInside:(NSArray*)TableInside;//==>check there is the same custNo or not at first
-(void)updateCustNo_TableName:(NSString*)TableName TableArray:(NSArray*)TableArray TableInside:(NSArray*)TableInside;
-(void)deleteCustNo_TableName:(NSString*)TableName Table:(NSString*)Table TableInside:(NSString*)TableInside;

//get new custNO
-(NSString*)newCustNo_TableName:(NSString*)TableName Number:(NSString*)Number;

//Sync connect to change from MySQL
-(void)insertCustDict_TableName:(NSString*)TableName TableArray:(NSArray*)TableArray MySqlTableArray:(NSArray*)MySqlTableArray MySqlTableInside:(NSDictionary*)MySqlTableInside;
@end
