//
//  Game3ViewController.m
//  runningCounter
//
//  Created by chiawei on 2015/1/25.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//
#import "location.h"
#import "LocalDBManager.h"
#import "ViewController.h"
@import AudioToolbox;
#import "Game3ViewController.h"

@interface Game3ViewController (){
    //Target Direction
    UIImageView *upview;
    UIImageView *leftview;
    UIImageView *downview;
    UIImageView *rightview;
    UIImageView *BallView;
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
    NSTimer *BallMove;
    NSTimer *fakePokeImgMoveTimer;
    NSTimer *fakePokeImgMoveTimer2;
    NSTimer *fakePokeImgMoveTimer3;
    NSTimer *fakePokeImgMoveTimer4;
    float time;
    float changeFrameTime;
    int pokeFrameX;
    int peopleFrameX;
    UIImage *pokeImage;
    UIImageView *pokeImageView;
    UIImage *peopleImage;
    UIImageView *peopleImageView;
    //
    UISwipeGestureRecognizer *swipeRight;
    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeUp;
    UISwipeGestureRecognizer *swipeDown;
    //改變frame的參數
    int ballmoveXY;
    int ChangeFakeImgParameterX;
    int ChangeFakeImgParameterY;
    //
    NSMutableArray *tmpArray;           //暫存陣列
    NSMutableArray *targetArray;        //比對暫存陣列
    //
    BOOL GameFinal;             // 判斷遊戲成敗
    int WinTimes;
    int LoseTimes;
    //
    int GameMode;               //遊戲模式(1~4)
}

@end

@implementation Game3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    //
    GameFinal = NO;
    WinTimes = 0;
    LoseTimes = 0;
    ballmoveXY = 0;
    ChangeFakeImgParameterX = 0;
    ChangeFakeImgParameterY = 0;
}

#pragma mark 隨機放圖
-(void)randonInputImage{
    //複製一份到暫存陣列
    tmpArray = [NSMutableArray new];
    targetArray = [NSMutableArray  new];
    for (int k = 0 ; k < [fakeMonArray count] ; k++) {
        [tmpArray addObject:[fakeMonArray objectAtIndex:k]];
    }
    NSLog(@"tmpArray:%@",tmpArray); //for check
    //洗牌 並從暫存陣列移除
    for (int i = 4; i>0; i--) {
        int ii = arc4random()%i;
        [targetArray addObject:[tmpArray objectAtIndex:ii]];
        [tmpArray removeObjectAtIndex:ii];
    }
    NSLog(@"targetArray:%@",targetArray);//確定洗牌成功!GOOD
    
    //置圖
    upview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[targetArray objectAtIndex:0]]];
    leftview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[targetArray objectAtIndex:1]]];
    downview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[targetArray objectAtIndex:2]]];
    rightview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[targetArray objectAtIndex:3]]];
    
    //持續改變FakePokeImage
    fakePokeImgMoveTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ChangeFakePokeImage) userInfo:nil repeats:YES];
}

#pragma mark 干擾怪物移動
-(void)ChangeFakePokeImage{
    ChangeFakeImgParameterX += self.view.frame.size.width/10;
    ChangeFakeImgParameterY += self.view.frame.size.height/10;
    //左跟下記得減掉自己位置
    upview.frame = CGRectMake(self.view.frame.size.width/2-30+ChangeFakeImgParameterX, ChangeFakeImgParameterY, 60, 60);
    leftview.frame = CGRectMake(ChangeFakeImgParameterX, self.view.frame.size.height/2-30-ChangeFakeImgParameterY, 60, 60);
    downview.frame = CGRectMake(self.view.frame.size.width/2-30-ChangeFakeImgParameterX, self.view.frame.size.height-60-ChangeFakeImgParameterY, 60, 60);
    rightview.frame = CGRectMake(self.view.frame.size.width-60-ChangeFakeImgParameterX, self.view.frame.size.height/2-30+ChangeFakeImgParameterY, 60, 60);
    //顯示
    [self.view addSubview:upview];
    [self.view addSubview:leftview];
    [self.view addSubview:downview];
    [self.view addSubview:rightview];
    
    if (ChangeFakeImgParameterX >= self.view.frame.size.width/2-15) {
        //STOP TIMER1
        [fakePokeImgMoveTimer invalidate];
        ChangeFakeImgParameterX  = 0;
        ChangeFakeImgParameterY  = 0;
        //
        if (GameMode == 1) {
            //全部結束要做的事
            [upview removeFromSuperview];
            [leftview removeFromSuperview];
            [downview removeFromSuperview];
            [rightview removeFromSuperview];
            //Ball
            UIImage *Ball = [UIImage imageNamed:@"Ball(500).png"];
            BallView = [[UIImageView alloc]initWithImage:Ball];
            BallView.frame = CGRectMake(self.view.frame.size.width/2-30, self.view.frame.size.height/2-30, 60 , 60);
            [self.view addSubview:BallView];
            [self setSwipe:self.view];
        }else{
            fakePokeImgMoveTimer2 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ChangeFakePokeImage2) userInfo:nil repeats:YES];
        }
        
    }
}
-(void)ChangeFakePokeImage2{
    ChangeFakeImgParameterX += self.view.frame.size.width/10;
    ChangeFakeImgParameterY += self.view.frame.size.height/10;
    //
    upview.frame = CGRectMake(self.view.frame.size.width-60-ChangeFakeImgParameterX, self.view.frame.size.height/2-30+ChangeFakeImgParameterY, 60, 60);
    leftview.frame = CGRectMake(self.view.frame.size.width/2-30+ChangeFakeImgParameterX, ChangeFakeImgParameterY, 60, 60);
    downview.frame = CGRectMake(ChangeFakeImgParameterX, self.view.frame.size.height/2-30-ChangeFakeImgParameterY, 60, 60);
    rightview.frame = CGRectMake(self.view.frame.size.width/2-30-ChangeFakeImgParameterX, self.view.frame.size.height-60-ChangeFakeImgParameterY, 60, 60);
    //顯示
    [self.view addSubview:upview];
    [self.view addSubview:leftview];
    [self.view addSubview:downview];
    [self.view addSubview:rightview];
    
    if (ChangeFakeImgParameterX >= self.view.frame.size.width/2-15) {
        //STOP TIMER2
        [fakePokeImgMoveTimer2 invalidate];
        ChangeFakeImgParameterX  = 0;
        ChangeFakeImgParameterY  = 0;
        //
        if (GameMode == 2) {
            //全部結束要做的事
            [upview removeFromSuperview];
            [leftview removeFromSuperview];
            [downview removeFromSuperview];
            [rightview removeFromSuperview];
            //Ball
            UIImage *Ball = [UIImage imageNamed:@"Ball(500).png"];
            BallView = [[UIImageView alloc]initWithImage:Ball];
            BallView.frame = CGRectMake(self.view.frame.size.width/2-30, self.view.frame.size.height/2-30, 60 , 60);
            [self.view addSubview:BallView];
            [self setSwipe:self.view];
        }else{
            fakePokeImgMoveTimer3 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ChangeFakePokeImage3) userInfo:nil repeats:YES];
        }
    }
}
-(void)ChangeFakePokeImage3{
    ChangeFakeImgParameterX += self.view.frame.size.width/10;
    ChangeFakeImgParameterY += self.view.frame.size.height/10;
    //
    upview.frame = CGRectMake(self.view.frame.size.width/2-30-ChangeFakeImgParameterX, self.view.frame.size.height-60-ChangeFakeImgParameterY, 60, 60);
    leftview.frame = CGRectMake(self.view.frame.size.width-60-ChangeFakeImgParameterX, self.view.frame.size.height/2-30+ChangeFakeImgParameterY, 60, 60);
    downview.frame = CGRectMake(self.view.frame.size.width/2-30+ChangeFakeImgParameterX, ChangeFakeImgParameterY, 60, 60);
    rightview.frame = CGRectMake(ChangeFakeImgParameterX, self.view.frame.size.height/2-30-ChangeFakeImgParameterY, 60, 60);
    //顯示
    [self.view addSubview:upview];
    [self.view addSubview:leftview];
    [self.view addSubview:downview];
    [self.view addSubview:rightview];
    
    if (ChangeFakeImgParameterX >= self.view.frame.size.width/2-15) {
        //STOP TIMER1
        [fakePokeImgMoveTimer3 invalidate];
        ChangeFakeImgParameterX  = 0;
        ChangeFakeImgParameterY  = 0;
        //
        if (GameMode == 3) {
            //全部結束要做的事
            [upview removeFromSuperview];
            [leftview removeFromSuperview];
            [downview removeFromSuperview];
            [rightview removeFromSuperview];
            //Ball
            UIImage *Ball = [UIImage imageNamed:@"Ball(500).png"];
            BallView = [[UIImageView alloc]initWithImage:Ball];
            BallView.frame = CGRectMake(self.view.frame.size.width/2-30, self.view.frame.size.height/2-30, 60 , 60);
            [self.view addSubview:BallView];
            [self setSwipe:self.view];
        }else{
        fakePokeImgMoveTimer4 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ChangeFakePokeImage4) userInfo:nil repeats:YES];
        }
    }
}
-(void)ChangeFakePokeImage4{
    ChangeFakeImgParameterX += self.view.frame.size.width/10;
    ChangeFakeImgParameterY += self.view.frame.size.height/10;
    //
    upview.frame = CGRectMake(ChangeFakeImgParameterX, self.view.frame.size.height/2-30-ChangeFakeImgParameterY, 60, 60);
    leftview.frame = CGRectMake(self.view.frame.size.width/2-30-ChangeFakeImgParameterX, self.view.frame.size.height-60-ChangeFakeImgParameterY, 60, 60);
    downview.frame = CGRectMake(self.view.frame.size.width-60-ChangeFakeImgParameterX, self.view.frame.size.height/2-30+ChangeFakeImgParameterY, 60, 60);
    rightview.frame = CGRectMake(self.view.frame.size.width/2-30+ChangeFakeImgParameterX, ChangeFakeImgParameterY, 60, 60);
    //顯示
    [self.view addSubview:upview];
    [self.view addSubview:leftview];
    [self.view addSubview:downview];
    [self.view addSubview:rightview];
    
    if (ChangeFakeImgParameterX >= self.view.frame.size.width/2+50) {
        //STOP TIMER1
        [fakePokeImgMoveTimer4 invalidate];
        ChangeFakeImgParameterX  = 0;
        ChangeFakeImgParameterY  = 0;
        //全部結束要做的事
        [upview removeFromSuperview];
        [leftview removeFromSuperview];
        [downview removeFromSuperview];
        [rightview removeFromSuperview];
        //Ball
        UIImage *Ball = [UIImage imageNamed:@"Ball(500).png"];
        BallView = [[UIImageView alloc]initWithImage:Ball];
        BallView.frame = CGRectMake(self.view.frame.size.width/2-30, self.view.frame.size.height/2-30, 60 , 60);
        [self.view addSubview:BallView];
        [self setSwipe:self.view];
    }
}

#pragma mark 新增手勢
-(void)setSwipe:(UIView*)view{
    swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    
    swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [view addGestureRecognizer:swipeRight];
    [view addGestureRecognizer:swipeLeft];
    [view addGestureRecognizer:swipeUp];
    [view addGestureRecognizer:swipeDown];
}

#pragma mark 手勢後動作
-(void)handleGesture:(UISwipeGestureRecognizer*)recognizer{
    //remove
    [self.view removeGestureRecognizer:swipeUp];
    [self.view removeGestureRecognizer:swipeLeft];
    [self.view removeGestureRecognizer:swipeDown];
    [self.view removeGestureRecognizer:swipeRight];
    //
    switch (recognizer.direction) {

        //想法是 從何處出發 進行第幾個GameMode後 要運算回原來的出發地數字
        case UISwipeGestureRecognizerDirectionUp:
            BallMove = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(BallImageMoveUp) userInfo:nil repeats:YES];
            //
            int targetNOUp = 0+GameMode-4;
            if (targetNOUp<0) {
                targetNOUp += 4;
            }
            [self ConfirmTarget:targetNOUp];
//            targetNOUp = 0;
            //
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            BallMove = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(BallImageMoveLeft) userInfo:nil repeats:YES];
            //
            int targetNOLeft = 1+GameMode-4;
            if (targetNOLeft<0) {
                targetNOLeft += 4;
            }
            [self ConfirmTarget:targetNOLeft];
//            targetNOLeft = 1;
            //
            break;
        case UISwipeGestureRecognizerDirectionDown:
            BallMove = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(BallImageMoveDown) userInfo:nil repeats:YES];
            //
            int targetNODown = 2+GameMode-4;
            if (targetNODown<0) {
                targetNODown += 4;
            }
            [self ConfirmTarget:targetNODown];
//            targetNODown = 2;
            //
            break;
        case UISwipeGestureRecognizerDirectionRight:
            BallMove = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(BallImageMoveRight) userInfo:nil repeats:YES];
            int targetNORight = 3+GameMode-4;
            if (targetNORight<0) {
                targetNORight += 4;
            }
            [self ConfirmTarget:targetNORight];
//            targetNORight = 3;
            break;
    }
}

-(void)ConfirmTarget:(int)index{
    if ([targetArray objectAtIndex:index] == [fakeMonArray objectAtIndex:0]) {
        NSLog(@"good");
        WinTimes ++;
    }else{
        NSLog(@"wrong");
        LoseTimes ++;
    }
}

#pragma mark 球移動
-(void)BallImageMoveUp{
    ballmoveXY += self.view.frame.size.height/10;
    BallView.frame = CGRectMake(self.view.frame.size.width/2-30, self.view.frame.size.height/2-30-ballmoveXY, 60, 60);
    [self.view addSubview:BallView];
    if (ballmoveXY>=self.view.frame.size.height/2-30) {
        [BallMove invalidate];
        [BallView removeFromSuperview];
        [self WinOrNot];
        ballmoveXY = 0;     //重置球增加參數位置
    }
}
-(void)BallImageMoveLeft{
    ballmoveXY += self.view.frame.size.width/10;
    BallView.frame = CGRectMake(self.view.frame.size.width/2-30-ballmoveXY, self.view.frame.size.height/2-30, 60, 60);
    [self.view addSubview:BallView];
    if (ballmoveXY>=self.view.frame.size.width/2-30) {
        [BallMove invalidate];
        [BallView removeFromSuperview];
        [self WinOrNot];
        ballmoveXY = 0;     //重置球增加參數位置
    }
}
-(void)BallImageMoveDown{
    ballmoveXY += self.view.frame.size.height/10;
    BallView.frame = CGRectMake(self.view.frame.size.width/2-30, self.view.frame.size.height/2-30+ballmoveXY, 60, 60);
    [self.view addSubview:BallView];
    if (ballmoveXY>=self.view.frame.size.height/2-30) {
        [BallMove invalidate];
        [BallView removeFromSuperview];
        [self WinOrNot];
        ballmoveXY = 0;     //重置球增加參數位置
    }
}
-(void)BallImageMoveRight{
    ballmoveXY += self.view.frame.size.width/10;
    BallView.frame = CGRectMake(self.view.frame.size.width/2-30+ballmoveXY, self.view.frame.size.height/2-30, 60, 60);
    [self.view addSubview:BallView];
    if (ballmoveXY>=self.view.frame.size.width/2-30) {
        [BallMove invalidate];
        [BallView removeFromSuperview];
        [self WinOrNot];
        ballmoveXY = 0;     //重置球增加參數位置
    }
}

#pragma mark 勝負判斷
-(void)WinOrNot{
    if (WinTimes>=3) {
        //勝利震動
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [BallView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好耶, 抓到了" message:nil delegate:self cancelButtonTitle:@"Keep poking" otherButtonTitles:nil];
        alert.tag = 1;  //要分辨多個 Alert 且加動作 就需設tag
        [alert show];
    }else if (LoseTimes>=2){
        //失敗震動
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [BallView removeFromSuperview];
        UIAlertView *failalert = [[UIAlertView alloc]initWithTitle:@"糟糕, Poke跑掉了" message:nil delegate:self cancelButtonTitle:@"Keep Poking" otherButtonTitles:nil];
        failalert.tag = 2;  //要分辨多個 Alert 且加動作 就需設tag
        [failalert show];
    }
    else {
        //移除前一次的怪
        [upview removeFromSuperview];
        [leftview removeFromSuperview];
        [rightview removeFromSuperview];
        [downview removeFromSuperview];
        [BallView removeFromSuperview];
        //還沒結束 再取亂數抓怪
        [self getmorefake];
        //在生怪進畫面
        [self randonInputImage];
    }
}

#pragma mark 隨機選取怪獸
-(void)getPokemonNo {
    
    randomMonster = arc4random()% ALL_POKEMON_COUNT +1;
    
    imageName = [NSString stringWithFormat:@"%d.png",randomMonster];
    iconName = [NSString stringWithFormat:@"%ds.png",randomMonster];
    NSLog(@"imageName:%@",imageName);
    NSLog(@"iconName:%@",iconName);
    //
    [self getmorefake];
    [self showPokemonImage];    //  秀動畫
}
-(void)getmorefake{
    //每次呼叫先new並加入主要怪
    fakeMonArray = [NSMutableArray new];
    [fakeMonArray addObject:imageName];
    //
    for (int fakeNO = 0; fakeNO<3; fakeNO++) {
        int check = arc4random()% (ALL_POKEMON_COUNT+1);
        if (check == randomMonster && check >= 2) {   //如果相等就改變
            check = (check+1)/2;
        }else if (check < 2){   //0跟1是很神奇的Bug
            check = check + (arc4random()%20)+5;
        }
        NSString *fakeimageName = [NSString stringWithFormat:@"%d.png",check];
        [fakeMonArray addObject:fakeimageName];
    }
    NSLog(@"fakeMonArray:%@",fakeMonArray);
    //
    GameMode = arc4random()%4+1;        //1~4
}

#pragma mark 存入Plist
-(void)SaveToPlist{
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
    
    if (pokeFrameX>=self.view.frame.size.width-100) {
        [pokeImgMove invalidate];
        //固定
        pokeImageView.frame = CGRectMake(self.view.frame.size.width-100, 20, 100, 100);
        peopleImageView.frame = CGRectMake(0, self.view.frame.size.height/2-110, 100, 100);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"快把精靈球丟向這隻Poke吧" message:@"三次才抓得到唷" delegate:self cancelButtonTitle:@"Go" otherButtonTitles:nil];
        alert.tag = 3;
        [alert show];
    }
}

#pragma mark 提示設定
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
            
        case 1:     // Successed Alert
            if (buttonIndex == 0) {
                [self SaveToPlist];
                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getLocation" object:nil];
                [self dismissViewControllerAnimated:YES completion:^{
                    //成功動作
                }];
            }
            break;
        case 2:     // Failed Alert
            if (buttonIndex == 0) {
                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getLocation" object:nil];
                [self dismissViewControllerAnimated:YES completion:^{
                    //失敗動作
                }];
            }
            break;
        case 3:
            if (buttonIndex == 0) {
                pokeImageView.frame = CGRectMake(self.view.frame.size.width, 20, 100, 100);
                peopleImageView.frame = CGRectMake(-100, self.view.frame.size.height/2-110, 100, 100);
                [self randonInputImage];
            }
            break;
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [pokeImgMove invalidate];
    [timeCountDown invalidate];
    [BallMove invalidate];
    //
    [upview removeFromSuperview];
    [leftview removeFromSuperview];
    [downview removeFromSuperview];
    [rightview removeFromSuperview];
    [BallView removeFromSuperview];
    [peopleImageView removeFromSuperview];
    [pokeImageView removeFromSuperview];
    //
    [self.view removeGestureRecognizer:swipeUp];
    [self.view removeGestureRecognizer:swipeLeft];
    [self.view removeGestureRecognizer:swipeDown];
    [self.view removeGestureRecognizer:swipeRight];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
