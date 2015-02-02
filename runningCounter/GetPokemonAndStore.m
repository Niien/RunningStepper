//
//  GetPokemonAndStore.m
//  runningCounter
//
//  Created by Longfatown on 1/28/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import "GetPokemonAndStore.h"

//先設定目前總共有的怪獸數
#define NumOfPokeMon 30

@interface GetPokemonAndStore()
{
    int random;
}
@end

@implementation GetPokemonAndStore

#pragma mark 隨機取怪獸
-(void)GetPokemon{
    random = arc4random()%NumOfPokeMon+1;
    
    _imageName = [NSString stringWithFormat:@"%d.png",random];
    _iconName = [NSString stringWithFormat:@"%d.png",random];
    NSLog(@"imageName:%@",_imageName);
    NSLog(@"iconName:%@",_iconName);
    
    //UIImage *image = [UIImage imageNamed:imageName];
    //UIImageView *myImageView = [[UIImageView alloc]initWithImage:image];
    //myImageView.frame = CGRectMake(0, 0, myView.frame.size.width, myView.frame.size.height);
    
    // add view
    //[myView addSubview:myImageView];
    //[self.view addSubview:myView];

}

-(void)StoreinPlist{
    NSString *imageName = [NSString stringWithFormat:@"%d.png",random];
    NSString *iconName = [NSString stringWithFormat:@"%d.png",random];
    NSLog(@"imageName:%@",imageName);
    NSLog(@"iconName:%@",iconName);
    
    // save data to plist
    NSDictionary *dict = @{@"Name":imageName, @"iconName":iconName, @"Lv":@"1"};
    
    NSArray *array = [[NSArray alloc]initWithObjects:dict, nil];
    
    NSLog(@"array:%@",array);
    
    [[myPlist shareInstanceWithplistName:@"MyPokemon"]saveDataWithArray:array];

}

@end
