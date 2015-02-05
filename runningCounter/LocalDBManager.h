//
//  LocalDBManager.h
//  runningCounter
//
//  Created by Longfatown on 2/5/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalDBManager : NSObject

+ (LocalDBManager *)sharedInstance;

- (BOOL)insertPokemonWithId:(NSNumber *)pokemonId with:(NSString *)lat with:(NSString *)lon;
- (NSMutableArray *)queryCatchedPokemon:(NSNumber *)pokemonID;

@end
