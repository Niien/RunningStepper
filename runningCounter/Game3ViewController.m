//
//  Game3ViewController.m
//  runningCounter
//
//  Created by chiawei on 2015/1/25.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "ViewController.h"
@import AudioToolbox;
#import "Game3ViewController.h"

@interface Game3ViewController (){
    //Target Direction
    UIImageView *upview;
    UIImageView *leftview;
    UIImageView *downview;
    UIImageView *rightview;
    //
    int randomMonster;
    NSString *imageName;
    NSString *iconName;
    NSDictionary *POKEMONDict;
    //
    NSMutableArray *fakeMonArray;
    //Pokeimgmove
    NSTimer *pokeImgMove;
    NSTimer *timeCountDown;
    float time;
    float changeFrameTime;
    int pokeFrameX;
    int peopleFrameX;
    UIImage *pokeImage;
    UIImageView *pokeImageView;
    UIImage *peopleImage;
    UIImageView *peopleImageView;
    //

}

@end

@implementation Game3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    upview = [[UIImageView alloc]initWithFrame:
              CGRectMake(self.view.frame.size.width/2-40, 0, 80, 80)];
    leftview = [[UIImageView alloc]initWithFrame:
                CGRectMake(0, self.view.frame.size.height/2-40, 80, 80)];
    downview = [[UIImageView alloc]initWithFrame:
                CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height-40, 80, 80)];
    rightview = [[UIImageView alloc]initWithFrame:
                 CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height/2-40, 80, 80)];
    POKEMONDict =
    @{@"1":@"喵蛙粽子",@"2":@"消火龍",@"3":@"傑尼菇",@"4":@"嗶嗶鳥",@"5":@"皮卡啾",
      @"6":@"雷啾",@"7":@"六條",@"8":@"九條",@"9":@"胖弟",@"10":@"扣打鴨",
      @"11":@"風速GO",@"12":@"聞香個頭",@"13":@"聞香哇",@"14":@"開心",@"15":@"喇叭Yeah",
      @"16":@"大水母",@"17":@"消火馬",@"18":@"小河馬",@"19":@"貴斯",@"20":@"打岩蛇",
      @"21":@"三點蛋",@"22":@"小蛋蛋",@"23":@"海星",@"24":@"飛飛螳螂",@"25":@"你魚want",
      @"26":@"變變怪",@"27":@"一步",@"28":@"閃電步",@"29":@"胖子",@"30":@"蜜妮long",
      };
    
    //刪除通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyD" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    //重置
    time = 10.0;
    fakeMonArray = [NSMutableArray new];
    [self getPokemonNo];
}

-(void)randonInputImage{
//    NSArray *showArray = [NSArray new];
//    for (<#type *object#> in <#collection#>) {
//        <#statements#>
//    }
    
    
}






-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
            
        case 1:     // Successed Alert
            if (buttonIndex == 0) {
//                [self SaveToPlist];
                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getLocation" object:nil];
                [self dismissViewControllerAnimated:YES completion:^{
                    //成功動作
                }];
            }
            break;
//        case 2:     // Failed Alert
//            if (buttonIndex == 0) {
//                [self dismissViewControllerAnimated:YES completion:^{
//                    //失敗動作
//                }];
//            }
//            break;
        default:
            break;
    }
}







#pragma mark 隨機選取怪獸
- (void)getPokemonNo {
    
    randomMonster = arc4random()% ALL_POKEMON_COUNT +1;
    
    imageName = [NSString stringWithFormat:@"%d.png",randomMonster];
    iconName = [NSString stringWithFormat:@"%ds.png",randomMonster];
    NSLog(@"imageName:%@",imageName);
    NSLog(@"iconName:%@",iconName);
    //
    [fakeMonArray addObject:imageName];
    
    for (int fakeNO = 0; fakeNO<3; fakeNO++) {

        int check = arc4random()% ALL_POKEMON_COUNT +1;
        if (check == randomMonster) {   //如果相等就改變
            check = (check+1)/2;
        }
        imageName = [NSString stringWithFormat:@"%d.png",check];
        [fakeMonArray addObject:imageName];
    }
    
    NSLog(@"fakeMonArray:%@",fakeMonArray);
    
    [self showPokemonImage];
}

#pragma mark 存入Plist
-(void)SaveToPlist{
    NSString *id = [NSString stringWithFormat:@"%d",randomMonster];
    // save data to plist
    NSDictionary *dict = @{@"name":[POKEMONDict objectForKey:id], @"image":imageName, @"iconName":iconName, @"Lv":@"1", @"exp":@"0", @"id":id};
    NSLog(@"G1:%@",dict);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getLocation" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getLocation" object:nil];
    
}

#pragma mark 設置圖位置
-(void)showPokemonImage{
    //add pokeimageview
    pokeImage = [UIImage imageNamed:imageName];
    pokeImageView = [[UIImageView alloc]initWithImage:pokeImage];
    pokeImageView.frame = CGRectMake(0, 20, 100, 100);
    [self.view addSubview:pokeImageView];
    
    //add pepleimageview
    peopleImage = [UIImage imageNamed:@"GG2.jpg"];
    peopleImageView = [[UIImageView alloc]initWithImage:peopleImage];
    peopleImageView.frame = CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height/2-110, 100, 100);
    [self.view addSubview:peopleImageView];
    
    //time
    pokeImgMove = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changePokeImage) userInfo:nil repeats:YES];
    
}

#pragma mark 改變圖位置
-(void)changePokeImage{
    //    changeFrameTime -= 0.1;
    pokeFrameX += self.view.frame.size.width /20;
    pokeImageView.frame = CGRectMake(pokeFrameX, 20, 100, 100);
    [self.view addSubview:pokeImageView];
    
    peopleFrameX -= self.view.frame.size.width /20;
    peopleImageView.frame = CGRectMake(self.view.frame.size.width-100+peopleFrameX, self.view.frame.size.height/2-110, 100, 100);
    [self.view addSubview:peopleImageView];
    
    if (pokeFrameX>=self.view.frame.size.width) {
        [pokeImgMove invalidate];
        //固定
        //改成讓他不見
        pokeImageView.frame = CGRectMake(self.view.frame.size.width, 20, 100, 100);
        peopleImageView.frame = CGRectMake(-100, self.view.frame.size.height/2-110, 100, 100);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Captured" message:nil delegate:self cancelButtonTitle:@"Keep poking" otherButtonTitles:nil];
        alert.tag = 1;  //要分辨多個 Alert 且加動作 就需設tag
        [alert show];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [pokeImgMove invalidate];
    [timeCountDown invalidate];
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
