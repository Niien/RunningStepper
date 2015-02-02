//
//  GetPokemonAndStore.h
//  runningCounter
//
//  Created by Longfatown on 1/28/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myPlist.h"

@interface GetPokemonAndStore : NSObject


@property (strong,nonatomic) NSString *imageName;
@property (strong,nonatomic) NSString *iconName;


-(void)GetPokemon;

-(void)StoreinPlist;

@end
