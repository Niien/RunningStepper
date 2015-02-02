//
//  myDB.m
//  CustManger
//
//  Created by 廖宗綸 on 2014/12/22.
//  Copyright (c) 2014年 Joseph Liao. All rights reserved.
//

#import "myDB.h"

myDB *sharedInstance;

@implementation myDB
/** loadDb
 Method Detial
 
 @see More Imformation
 
 @param void
 
 @return None
 @return
*/

-(void)loadDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"pokemonDatabase.sqlite"];

//    NSString *bundleResourcePath = [[NSBundle mainBundle]resourcePath];
//    NSString *dbPath = [bundleResourcePath stringByAppendingPathComponent:@"mydatabase.sqlite"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not load DB");
    }

}


/** loadDb
 Method Detial
 @see More Imformation
 @param
 @return (id)
*/


// get data from database
-(id)queryCust_TableName:(NSString*)TableName TableArray:(NSArray*)TableArray OrderBy:(NSString*)OrderBy
{
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:0];
    
    //Creat SQLiteScrip
    int tableCount = (int)[TableArray count];
    NSMutableString *sqlite1 = [NSMutableString stringWithFormat:@"SELECT "];
    NSMutableString *sqlite2 = [[NSMutableString alloc] init];
    NSString *tmpString1 = @"";

    for (int i =0; i<tableCount; i++) {
        if (i<tableCount-1) {
            tmpString1 = [NSString stringWithFormat:@"%@,",TableArray[i]];
        }else{
            tmpString1 = [NSString stringWithFormat:@"%@",TableArray[i]];
        }
        [sqlite1 appendString:tmpString1];
    }
    [sqlite2 appendString:[NSString stringWithFormat:@"FROM %@ ORDER BY %@",TableName,OrderBy]];
    NSString *SQLiteScrip = [NSString stringWithFormat:@"%@ %@",sqlite1,sqlite2];
    
    NSLog(@"%@",SQLiteScrip);
    
    FMResultSet *result = [db executeQuery:SQLiteScrip];
    
    while ([result next]) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        for (int i = 0; i<tableCount; i++) {
            NSString *cust = [result stringForColumn:
                              [NSString stringWithFormat:@"%@",TableArray[i]]];
            [dict setValue:cust forKey:TableArray[i]];
        }
        [rows addObject:dict];
    }
    
    return rows;
}



-(id)queryCust_TableName:(NSString*)TableName TableArray:(NSArray*)TableArray OrderBy:(NSString*)OrderBy TargetName:(NSString*)TargetName TargetInside:(NSString*)TargetInside
{
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:0];
    //Creat SQLiteScrip
    int tableCount = (int)[TableArray count];
    NSMutableString *sqlite1 = [NSMutableString stringWithFormat:@"SELECT "];
    NSMutableString *sqlite2 = [[NSMutableString alloc] init];
    NSString *tmpString1 = @"";
    
    for (int i =0; i<tableCount; i++) {
        if (i<tableCount-1) {
            tmpString1 = [NSString stringWithFormat:@"%@,",TableArray[i]];
        }else{
            tmpString1 = [NSString stringWithFormat:@"%@",TableArray[i]];
        }
        [sqlite1 appendString:tmpString1];
    }
    
    //search string
    NSString *search = [NSString stringWithFormat:@"%@%%",TargetInside];
    [sqlite2 appendString:[NSString stringWithFormat:
                           @"FROM %@ where %@ like %@ ORDER BY %@",TableName,TargetName,@"?",OrderBy]];
    NSString *SQLiteScrip = [NSString stringWithFormat:@"%@ %@",sqlite1,sqlite2];
    
    NSLog(@"%@",SQLiteScrip);

    FMResultSet *result = [db executeQuery:SQLiteScrip,search];
    
    while ([result next]) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        for (int i = 0; i<tableCount; i++) {
            NSString *cust = [result stringForColumn:
                              [NSString stringWithFormat:@"%@",TableArray[i]]];
            [dict setValue:cust forKey:TableArray[i]];
        }
        [rows addObject:dict];
    }
    
    return rows;
}


-(id)init
{
    self = [super init];
    if (self) {
        [self loadDB];
    }
    return self;
}


+(myDB *)sharedInstance
{
    if (sharedInstance==nil) {
        sharedInstance = [[myDB alloc]init];
    }
    return sharedInstance;
}


-(NSString*)newCustNo_TableName:(NSString*)TableName Number:(NSString*)Number
{
    int maxNo = 1;
    NSString *SQLiteScrip = [NSString stringWithFormat:@"select max(%@) from %@ order by %@",Number,TableName,Number];
    FMResultSet *result = [db executeQuery:SQLiteScrip];
    while ([result next]) {
        maxNo = [result intForColumnIndex:0]+1;
    }
    return [NSString stringWithFormat:@"%03d",maxNo];
}


-(void)insertCustNo_TableName:(NSString*)TableName TableArray:(NSArray*)TableArray TableInside:(NSArray*)TableInside
{
    //creat customer SQLiteScrip
    int tableCount = (int)[TableArray count];
    NSString *sqlite1 = [NSString stringWithFormat:@"insert into %@",TableName];
    NSMutableString *sqlite2 = [[NSMutableString alloc] init];
    NSMutableString *sqlite3 = [[NSMutableString alloc]init];
    NSString *tmpString1 = @"";
    NSString *tmpString2 = @"";
    [sqlite2 appendString:@"("];
    [sqlite3 appendString:@"values ("];
    for (int i =0; i<tableCount; i++) {
        if (i<tableCount-1) {
            tmpString1 = [NSString stringWithFormat:@"%@,",TableArray[i]];
            tmpString2 = [NSString stringWithFormat:@"'%@',",TableInside[i]];
        }else{
            tmpString1 = [NSString stringWithFormat:@"%@)",TableArray[i]];
            tmpString2 = [NSString stringWithFormat:@"'%@')",TableInside[i]];
        }
        [sqlite2 appendString:tmpString1];
        [sqlite3 appendString:tmpString2];
    }
    NSString *SQLiteScrip = [NSString stringWithFormat:@"%@ %@ %@",sqlite1,sqlite2,sqlite3];
    
    NSLog(@"%@",SQLiteScrip);

    if(![db executeUpdate:SQLiteScrip])
    {
        NSLog(@"Could not insert data: %@",[db lastErrorMessage]);
    }
}


-(void)updateCustNo_TableName:(NSString*)TableName TableArray:(NSArray*)TableArray TableInside:(NSArray*)TableInside
{
    int tableCount = (int)[TableArray count];
    NSString *sqlite1 = [NSString stringWithFormat:@"update %@ set",TableName];
    NSMutableString *sqlite2 = [[NSMutableString alloc] init];
    NSMutableString *sqlite3 = [[NSMutableString alloc]init];
    NSString *tmpString1 = @"";
    NSString *tmpString2 = [NSString stringWithFormat:@"where %@='%@'",TableArray[0],TableInside[0]];

    for (int i =1; i<tableCount; i++) {
        if (i<tableCount-1) {
            tmpString1 = [NSString stringWithFormat:@"%@='%@',",TableArray[i],TableInside[i]];
        }else{
            tmpString1 = [NSString stringWithFormat:@"%@='%@'",TableArray[i],TableInside[i]];
        }
        [sqlite2 appendString:tmpString1];
    }
    [sqlite3 appendString:tmpString2];
    NSString *SQLiteScrip = [NSString stringWithFormat:@"%@ %@ %@",sqlite1,sqlite2,sqlite3];
    
    NSLog(@"%@",SQLiteScrip);
    if(![db executeUpdate:SQLiteScrip])
    {
        NSLog(@"Could not insert data: %@",[db lastErrorMessage]);
    }

}
//ok
-(void)deleteCustNo_TableName:(NSString*)TableName Table:(NSString*)Table TableInside:(NSString*)TableInside
{
    NSString *SQLiteScrip = [NSString stringWithFormat:@"delete from %@ where %@='%@'",TableName,Table,TableInside];
    NSLog(@"%@",SQLiteScrip);
    if (![db executeUpdate:SQLiteScrip]) {
        NSLog(@"Could not delet data: %@",[db lastErrorMessage]);
    }
}

//ok
//MySQL Connect to change SQLite
-(void)insertCustDict_TableName:(NSString*)TableName TableArray:(NSArray*)TableArray MySqlTableArray:(NSArray*)MySqlTableArray MySqlTableInside:(NSDictionary*)MySqlTableInside
{
    /*
     merber_id       cust_no
     merber_name     cust_name
     merber_phone    cust_tel
     merber_email    cust_email
     merber_adde     cust_addr
     */
    
    //creat customer SQLiteScrip
    int tableCount = (int)[TableArray count];
    NSString *sqlite1 = [NSString stringWithFormat:@"insert into %@",TableName];
    NSMutableString *sqlite2 = [[NSMutableString alloc] init];
    NSMutableString *sqlite3 = [[NSMutableString alloc]init];
    NSString *tmpString1 = @"";
    NSString *tmpString2 = @"";
    [sqlite2 appendString:@"("];
    [sqlite3 appendString:@"values ("];
    for (int i =0; i<tableCount; i++) {
        if (i<tableCount-1) {
            tmpString1 = [NSString stringWithFormat:@"%@,",TableArray[i]];
            tmpString2 = [NSString stringWithFormat:@"'%@',",
                          [MySqlTableInside objectForKey:[NSString stringWithFormat:@"%@",MySqlTableArray[i]]]];
        }else{
            tmpString1 = [NSString stringWithFormat:@"%@)",TableArray[i]];
            tmpString2 = [NSString stringWithFormat:@"'%@')",
                          [MySqlTableInside objectForKey:[NSString stringWithFormat:@"%@",MySqlTableArray[i]]]];
        }
        [sqlite2 appendString:tmpString1];
        [sqlite3 appendString:tmpString2];
    }
    NSString *SQLiteScrip = [NSString stringWithFormat:@"%@ %@ %@",sqlite1,sqlite2,sqlite3];
    
    NSLog(@"%@",SQLiteScrip);
    
    if(![db executeUpdate:SQLiteScrip])
    {
        NSLog(@"Could not insert data: %@",[db lastErrorMessage]);
    }

}

@end
