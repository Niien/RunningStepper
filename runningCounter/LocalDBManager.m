//
//  LocalDBManager.m
//  runningCounter
//
//  Created by Longfatown on 2/5/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import "LocalDBManager.h"
#import "FMDatabase.h"

static LocalDBManager *sharedInstance;

@implementation LocalDBManager
{
    FMDatabase *db;

}

- (id)init
{
    self = [super init];
    
    if (self) {
        // connect to database
        [self loadDB];
    }
    
    return self;
}

+ (LocalDBManager *)sharedInstance
{
    if (sharedInstance == nil) {
        
        sharedInstance = [[LocalDBManager alloc] init];
        
    }
    
    return sharedInstance;
}

- (void)loadDB
{
    NSArray *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = documentDir[0];
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"pokemon.sqlite"];
    
    NSLog(@"dbPath %@", dbPath);
    
    // check if sqlite-model exist in document directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dbPath]) {
        
        // file not exist
        NSString *bundleDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pokemon.sqlite"];
        NSError *error;
        BOOL copySuccess = [fileManager copyItemAtPath:bundleDBPath
                                                toPath:dbPath
                                                 error:&error];
        if (copySuccess) {
            NSLog(@"Copy DB Success!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        
        NSLog(@"Could not open DB");
        return;
    }
}

// 抓到神奇寶貝
- (BOOL)insertPokemonWithId:(NSNumber *)pokemonId with:(NSString *)lat with:(NSString *)lon
{
    NSString *insertSql = @"INSERT INTO Catch (pokemon_id, catch_lat, catch_lon)  VALUES (?,?,?)";
    
    BOOL result = [db executeUpdate:insertSql, pokemonId, lat, lon];
    
    if (result) {
        NSLog(@"成功新增神奇寶貝");
    } else {
        NSLog(@"新增神奇寶貝失敗");
    }
    
    return result;
}

- (NSMutableArray *)queryCatchedPokemon:(NSNumber *)pokemonID{
    
//    NSString *querySql = @"SELECT * FROM  (SELECT * FROM Catch) a JOIN Pokemon b WHERE a.pokemon_id = b.id";
    
    NSString *querySql = @"SELECT * FROM  Pokemon where id = ?;";
    
    FMResultSet *queryRS = [db executeQuery:querySql,pokemonID];
    
    NSMutableArray *catchArray = [[NSMutableArray alloc] init];
    
    while ([queryRS next]) {
        
        int LV = [queryRS intForColumn:@"pokemon_LV"];
        NSString *pokemon_LV = [NSString stringWithFormat:@"%d",LV];
        int attack = [queryRS intForColumn:@"pokemon_attack"];
        NSString *pokemon_attack = [NSString stringWithFormat:@"%d",attack];
        int exp = [queryRS intForColumn:@"pokemon_exp"];
        NSString *pokemon_exp = [NSString stringWithFormat:@"%d",exp];
        NSString *pokemon_iconname = [queryRS stringForColumn:@"pokemon_iconname"];
        NSString *pokemon_image = [queryRS stringForColumn:@"pokemon_image"];
        NSString *pokemon_name = [queryRS stringForColumn:@"pokemon_name"];
        int hp = [queryRS intForColumn:@"pokemon_hp"];
        NSString *pokemon_hp = [NSString stringWithFormat:@"%d",hp];
        NSString *pokemon_skill1 = [queryRS stringForColumn:@"pokemon_skill1"];
        NSString *pokemon_skill2 = [queryRS stringForColumn:@"pokemon_skill2"];
        
        NSDictionary *dict = @{@"LV":pokemon_LV,
                               @"attack":pokemon_attack,
                               @"exp":pokemon_exp,
                               @"iconname":pokemon_iconname,
                               @"image":pokemon_image,
                               @"name":pokemon_name,
                               @"hp":pokemon_hp,
                               @"skill1":pokemon_skill1,
                               @"skill2":pokemon_skill2};
        [catchArray addObject:dict];
        
    }
    
    return catchArray;
    
}


- (void)update:(NSString *)custNo andCustName:(NSString *)custName andCustTel:(NSString *)custTel andCustAddr:(NSString *)custAddress andCustEmail:(NSString *)custEmail {
    
    if (![db executeUpdate:@"update cust set cust_name = ?, cust_tel = ?, cust_addr = ?, cust_email = ? where cust_no = ?", custName, custTel, custAddress, custEmail, custNo]) {
        
        NSLog(@"could not updata data:%@",[db lastErrorMessage]);
        
    }
    
}



@end
