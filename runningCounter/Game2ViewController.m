//
//  Game2ViewController.m
//  runningCounter
//
//  Created by chiawei on 2015/1/25.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "location.h"
#import "LocalDBManager.h"
#import "Game2ViewController.h"
@import AudioToolbox;

@interface Game2ViewController ()
{
    int random,randomNO;        // 隨機取值
    int X;                      // 陣列比對位數
    NSTimer *myCountdowntimer;  //
    float time;                 // 所剩時間
    BOOL GameFinal;             // 判斷遊戲成敗
    NSArray *BaseElementArray;
    //
    int randomMonster;
    NSString *imageName;
    NSString *iconName;
    NSDictionary *POKEMONDict;
    //Pokeimgmove
    NSTimer *pokeImgMove;
    float changeFrameTime;
    int pokeFrameX;
    int peopleFrameX;
    UIImage *pokeImage;
    UIImageView *pokeImageView;
    UIImage *peopleImage;
    UIImageView *peopleImageView;
    //
}
@property (weak, nonatomic) IBOutlet UILabel *showTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *RandomLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ButtonsLabel;
@property (weak, nonatomic) IBOutlet UILabel *mytimeLabel;

@end

@implementation Game2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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

#pragma mark 參數設置
- (void)viewDidAppear:(BOOL)animated{
    //重置
    time = 5.0;
    BaseElementArray = [NSArray new];       // 底層元素(箭頭)
    NumberArray = [NSMutableArray new];     // 數字陣列
    showArrowArray = [NSMutableArray new];  // 箭頭陣列
    keyinArray = [NSMutableArray new];      // 比對陣列
    X = 0;                                  // 比對陣列序數
    GameFinal = false;                      // 遊戲輸贏判斷
    [self getPokemonNo];                    // 隨機取怪獸
    //enable buttons
    for (int i=0; i<6; i++) {
        [[_ButtonsLabel objectAtIndex:i]setEnabled:NO];
    }
    
    
    //顯示目標 分數 時間
    _mytimeLabel.text = [NSString stringWithFormat:@"= %.1f =",time];
    _showTextLabel.text = @"";
    //設一個倒數計時器 並在分數達標時停止並響鈴
    [self showRandom];
    //計時器改在動畫結束後
    
    
}
#pragma mark 隨機取值
- (void)showRandom{
    //↓←→↑AB
    BaseElementArray = @[@"↑",@"→",@"↓",@"←",@"A",@"B"];
    
    randomNO = arc4random()%4+8;
    _RandomLabel.text = @"";
    //生成 箭頭陣列 與 數字陣列
    for (int i=0; i<randomNO; i++) {
        random = arc4random()%6;
        [NumberArray addObject:[NSString stringWithFormat:@"%d",random]];
        [showArrowArray addObject:[BaseElementArray objectAtIndex:random]];
    }
    NSString *tmp1,*tmp2;
    tmp2 = @"";
//    NSLog(@"%@",NumberArray);
    //為了修正前面逗號,變一大串 XDD
    for (int i=0; i<randomNO-1; i++) {
        tmp1 = [NSString stringWithFormat:@"%@",showArrowArray[i]];
        tmp2 = [NSString stringWithFormat:@"%@%@",tmp2,tmp1];
    }
    _RandomLabel.text = [NSString stringWithFormat:@"%@%@",tmp2,[showArrowArray lastObject]];
    
}

#pragma mark 按鈕事件
- (IBAction)Buttons:(UIButton *)sender {
    
    NSString *keytmp = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    NSLog(@"%@",keytmp);
    
    if ([keytmp isEqualToString:NumberArray[X]]) {
        //對的話做的事
        NSLog(@"Correct");
        NSString *correcttmp =
        [NSString stringWithFormat:@"%@",[showArrowArray objectAtIndex:X]];
        _showTextLabel.text = [NSString stringWithFormat:@"%@%@",_showTextLabel.text,correcttmp];
        X++;
        if (X == [NumberArray count]) {
            NSLog(@"end");
            //結束動作
            GameFinal = true;
        }
    }else {NSLog(@"error");}//打錯字做的事
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 倒數計時
-(void)myCountDown:(NSTimer *)timer{
    
    time -=0.1;
    _mytimeLabel.text = [NSString stringWithFormat:@"= %.1f =",time];

    if (time >= 0) {
        if (GameFinal) {
            //還有時間 且 已達標
            [myCountdowntimer invalidate];
            //隱藏按鈕
            for (int i=0; i<6; i++) {
                [[_ButtonsLabel objectAtIndex:i]setEnabled:NO];
            }
            [self SaveToPlist];
            //震動
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Succeed" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = 1;
            [alert show];
        }
    }else{
        _mytimeLabel.text = [NSString stringWithFormat:@"= 0.0 ="];
        [myCountdowntimer invalidate];
        //隱藏按鈕
        for (int i=0; i<6; i++) {
            [[_ButtonsLabel objectAtIndex:i]setEnabled:NO];
        }
        //結束震動
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIAlertView *failalert = [[UIAlertView alloc]initWithTitle:@"PokeMon Was Gone" message:nil delegate:self cancelButtonTitle:@"Keep Poking" otherButtonTitles:nil];
        failalert.tag = 2;  //要分辨多個 Alert 且加動作 就需設tag
        [failalert show];

    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:     // Successed Alert
            if (buttonIndex == 0) {
                [self dismissViewControllerAnimated:YES completion:^{
                    //成功動作
                }];
            }
            break;
        case 2:     // Failed Alert
            if (buttonIndex == 0) {
                [self dismissViewControllerAnimated:YES completion:^{
                    //失敗動作
                }];
            }
            break;
        default:
            break;
    }
}
#pragma mark 畫面消失
-(void)viewDidDisappear:(BOOL)animated{
    [myCountdowntimer invalidate];
    [pokeImgMove invalidate];
}


#pragma mark 隨機選取怪獸
- (void)getPokemonNo {
    
    randomMonster = arc4random()% ALL_POKEMON_COUNT +1;
    
    imageName = [NSString stringWithFormat:@"%d.png",randomMonster];
    iconName = [NSString stringWithFormat:@"%ds.png",randomMonster];
    NSLog(@"imageName:%@",imageName);
    NSLog(@"iconName:%@",iconName);

    [self showPokemonImage];
}

#pragma mark 存入Plist
-(void)SaveToPlist{
    // save data to plist
    NSMutableArray *array = [NSMutableArray new];
    NSString *id = [NSString stringWithFormat:@"%d",randomMonster];
    NSString *lat = [NSString stringWithFormat:@"%f",[[location share]userLocation].coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",[[location share]userLocation].coordinate.longitude];
    
    if ([[LocalDBManager sharedInstance]queryCatchedPokemon:@(randomMonster)]) {
        
        NSLog(@"Catch Pokemon!!!!!!!!!");
        array = [[LocalDBManager sharedInstance]queryCatchedPokemon:@(randomMonster)];
        NSLog(@"array:%@",array);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary *)[array objectAtIndex:0]];
        NSLog(@"dict:%@",dict);
        [dict setObject:lat forKey:@"lat"];
        [dict setObject:lon forKey:@"lon"];
        [dict setObject:id forKey:@"id"];
        NSLog(@"dict:%@",dict);
        
        array = [[NSMutableArray alloc]initWithObjects:dict, nil];
        NSLog(@"array:%@",array);
        
        [[myPlist shareInstanceWithplistName:@"MyPokemon"]saveDataWithArray:array];
        [[myPlist shareInstanceWithplistName:@"hadGetPokemon"]saveDataWithArray:array];
        
    }
}

#pragma mark 設置圖位置
-(void)showPokemonImage{
    //add pokeimageview
    pokeImage = [UIImage imageNamed:imageName];
    pokeImageView = [[UIImageView alloc]initWithImage:pokeImage];
    pokeImageView.frame = CGRectMake(0, 15, 100, 100);
    [self.view addSubview:pokeImageView];

    
    //add pepleimageview
    peopleImage = [UIImage imageNamed:@"GG2.jpg"];
    peopleImageView = [[UIImageView alloc]initWithImage:peopleImage];
    peopleImageView.frame = CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height/2-165, 100, 100);
    [self.view addSubview:peopleImageView];
    
    //time
    pokeImgMove = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changePokeImage) userInfo:nil repeats:YES];
    
}

#pragma mark 改變圖位置
-(void)changePokeImage{
    //    changeFrameTime -= 0.1;
    pokeFrameX += self.view.frame.size.width /15;
    pokeImageView.frame = CGRectMake(pokeFrameX, 15, 100, 100);
    [self.view addSubview:pokeImageView];
    
    peopleFrameX -= self.view.frame.size.width /15;
    peopleImageView.frame = CGRectMake(self.view.frame.size.width-100+peopleFrameX, self.view.frame.size.height/2-165, 100, 100);
    [self.view addSubview:peopleImageView];
    
    if (pokeFrameX >= self.view.frame.size.width-100) {
        [pokeImgMove invalidate];
        //固定在左右
        pokeImageView.frame = CGRectMake(self.view.frame.size.width-100, 15, 100, 100);
        peopleImageView.frame = CGRectMake(0, self.view.frame.size.height/2-165, 100, 100);
        //使按鈕可用
        for (int i=0; i<6; i++) {
            [[_ButtonsLabel objectAtIndex:i]setEnabled:YES];
        }
        //遊戲開始倒數計時器
        myCountdowntimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(myCountDown:) userInfo:nil repeats:YES];
    }
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
