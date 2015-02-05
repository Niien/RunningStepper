//
//  TeamVC.m
//  runningCounter
//
//  Created by Longfatown on 2/5/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import "TeamVC.h"
#import "myPlist.h"

@interface TeamVC (){
    //
    UIImageView *TeamImageView1;
    UIImageView *TeamImageView2;
    UIImageView *TeamImageView3;
    UIImageView *TeamImageView4;
    UIImageView *TeamImageView5;
    
    NSArray *TeamArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *TeamView1;
@property (weak, nonatomic) IBOutlet UIImageView *TeamView2;
@property (weak, nonatomic) IBOutlet UIImageView *TeamView3;
@property (weak, nonatomic) IBOutlet UIImageView *TeamView4;
@property (weak, nonatomic) IBOutlet UIImageView *TeamView5;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *MyTeamView;

@end

@implementation TeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    //秀出隊伍圖片
    TeamArray = [[myPlist shareInstanceWithplistName:@"team"]getDataFromPlist];
    NSLog(@"teamVC:%@",TeamArray);
    
    for (int i=0; i<5; i++) {
        
        UIImageView *imageView = (UIImageView *)self.MyTeamView[i];
        
        imageView.image = nil;
    }

    
    if ([TeamArray count] && [TeamArray count] <= 5) {
        
        for (int i=0; i<[TeamArray count]; i++) {
            
            UIImageView *imageView = (UIImageView *)self.MyTeamView[i];
            
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[TeamArray objectAtIndex:i]valueForKey:@"image"]]];
        }

        /*
        _TeamView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[TeamArray objectAtIndex:0]valueForKey:@"image"]]];
        */
    }

    
    

    
    
    


//    for (NSDictionary *Dict in TeamArray) {
//        int i = 0;
////        allPokemons [i-1] = [Dict objectForKey:@"image"];
////        myPokemonsName [i-1] = [dict objectForKey:@"name"];
//    }
    
    
//    if ([TeamArray objectAtIndex:0]){
//        _TeamView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[TeamArray objectAtIndex:0]valueForKey:@"image"]]];
//    }
//    if ([TeamArray objectAtIndex:1]) {
//        _TeamView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[TeamArray objectAtIndex:1]valueForKey:@"image"]]];
//    }
//    if ([TeamArray objectAtIndex:2]) {
//        _TeamView3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[TeamArray objectAtIndex:2]valueForKey:@"image"]]];
//    }
//    if ([TeamArray objectAtIndex:3]) {
//        _TeamView4.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[TeamArray objectAtIndex:3]valueForKey:@"image"]]];
//    }
//    if ([TeamArray objectAtIndex:4]) {
//        _TeamView5.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[TeamArray objectAtIndex:4]valueForKey:@"image"]]];
//    }
    //設定圖片位置
//    int WideAddParameter = self.view.frame.size.width/5;
//    TeamImageView1.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width/5, self.view.frame.size.height/2);
    //    TeamImageView2.frame = CGRectMake(0+WideAddParameter*1, self.view.frame.size.height/2, self.view.frame.size.width/5, self.view.frame.size.height/2);
    //    TeamImageView3.frame = CGRectMake(0+WideAddParameter*2, self.view.frame.size.height/2, self.view.frame.size.width/5, self.view.frame.size.height/2);
    //    TeamImageView4.frame = CGRectMake(0+WideAddParameter*3, self.view.frame.size.height/2, self.view.frame.size.width/5, self.view.frame.size.height/2);
    //    TeamImageView5.frame = CGRectMake(0+WideAddParameter*4, self.view.frame.size.height/2, self.view.frame.size.width/5, self.view.frame.size.height/2);

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
