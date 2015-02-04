//
//  Game1ViewController.m
//  runningCounter
//
//  Created by Longfatown on 1/21/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//
#import "location.h"
#import "Game1ViewController.h"
#import "ViewController.h"
@import AudioToolbox;

//目前神奇寶貝總數

@interface Game1ViewController (){
    

    //
    int goal,myPressPoint;
    float time;
    //
    int randomMonster;
    NSString *imageName;
    NSString *iconName;
    NSDictionary *POKEMONDict;
    //Pokeimgmove
    NSTimer *pokeImgMove;
    NSTimer *timeCountDown;
    float changeFrameTime;
    int pokeFrameX;
    int peopleFrameX;
    UIImage *pokeImage;
    UIImageView *pokeImageView;
    UIImage *peopleImage;
    UIImageView *peopleImageView;
    //
}
@property (weak, nonatomic) IBOutlet UIImageView *firstVCImage;
@property (weak, nonatomic) IBOutlet UILabel *targetGoal;
@property (weak, nonatomic) IBOutlet UILabel *myPoint;
@property (weak, nonatomic) IBOutlet UIButton *BtnLabelleft;
@property (weak, nonatomic) IBOutlet UIButton *BtnLabelright;
@property (weak, nonatomic) IBOutlet UILabel *mytimeLabel;

@end

@implementation Game1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"battle01-1.jpeg" ofType:nil];
//    _firstVCImage.image = [UIImage imageWithContentsOfFile:imagePath];
    
    [_BtnLabelleft setImage:[UIImage imageNamed:@"RedBtn1.png"] forState:UIControlStateNormal];
    [_BtnLabelleft setImage:[UIImage imageNamed:@"RedBtn2.png"] forState:UIControlStateHighlighted];
    [_BtnLabelright setImage:[UIImage imageNamed:@"RedBtn1.png"] forState:UIControlStateNormal];
    [_BtnLabelright setImage:[UIImage imageNamed:@"RedBtn2.png"] forState:UIControlStateHighlighted];
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
-(void)viewDidAppear:(BOOL)animated{
    //隨機目標數
    time = 10.0;
    goal = 5;//arc4random()%50+30;
    myPressPoint = 0;
    changeFrameTime = 1.5;
    [self getPokemonNo];
    [_BtnLabelleft setEnabled:NO];
    [_BtnLabelright setEnabled:NO];

    
    //顯示目標 分數 時間
    _targetGoal.text = [NSString stringWithFormat:@"Mission Target: %ld",(long)goal];
    _myPoint.text = [NSString stringWithFormat:@"%ld",(long)myPressPoint];
    _mytimeLabel.text = [NSString stringWithFormat:@"= %.1f =",time];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedBtnleft:(id)sender {
    myPressPoint++;
    _myPoint.text = [NSString stringWithFormat:@"%ld",(long)myPressPoint-1];
    //NSLog(@"%d",myPressPoint);
    
    //按了按鈕才開始
    if (myPressPoint == 1) {
        //設一個倒數計時器 並在分數達標時停止並響鈴
        NSLog(@"timer1");
        timeCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(myCountDown:) userInfo:nil repeats:YES];
    }
}

- (IBAction)pressedBtnRight:(id)sender {
    myPressPoint++;
    _myPoint.text = [NSString stringWithFormat:@"%ld",(long)myPressPoint-1];
    //NSLog(@"%d",myPressPoint);

    //按了按鈕才開始
    if (myPressPoint == 1) {
        //設一個倒數計時器 並在分數達標時停止並響鈴
        NSLog(@"timer2");
        timeCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(myCountDown:) userInfo:nil repeats:YES];
    }
    
}

-(void)myCountDown:(NSTimer *)timer{
    
    time -=0.1;
    _mytimeLabel.text = [NSString stringWithFormat:@"= %.1f =",time];
    if (time >= 0) {
        if (myPressPoint >= goal) {
            //還有時間 且 已達標
            NSLog(@"win");
            [_BtnLabelleft setEnabled:NO];
            [_BtnLabelright setEnabled:NO];
            [timeCountDown invalidate];
            myPressPoint = goal;
//            [self SaveToPlist];
            //結束震動
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Captured" message:nil delegate:self cancelButtonTitle:@"Keep poking" otherButtonTitles:nil];
            alert.tag = 1;  //要分辨多個 Alert 且加動作 就需設tag
            [alert show];
        }
    }else{
        [_BtnLabelleft setEnabled:NO];
        [_BtnLabelright setEnabled:NO];
        [timeCountDown invalidate];
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
                [self SaveToPlist];
                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getLocation" object:nil];
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

-(void)viewDidDisappear:(BOOL)animated{
    [timeCountDown invalidate];
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

    NSString *id = [NSString stringWithFormat:@"%d",randomMonster];
    NSString *lat = [NSString stringWithFormat:@"%f",[[location share]userLocation].coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",[[location share]userLocation].coordinate.longitude];
    
    NSDictionary *dict = @{@"name":[POKEMONDict objectForKey:id], @"image":imageName, @"iconName":iconName, @"Lv":@"1", @"exp":@"0", @"id":id,@"attack":@"100", @"lat":lat, @"lon":lon};

    NSLog(@"G1:%@",dict);
    
    NSArray *array = [[NSArray alloc]initWithObjects:dict, nil];
    
    [[myPlist shareInstanceWithplistName:@"MyPokemon"]saveDataWithArray:array];
    [[myPlist shareInstanceWithplistName:@"hadGetPokemon"]saveDataWithArray:array];

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
    pokeFrameX += self.view.frame.size.width /15;
    pokeImageView.frame = CGRectMake(pokeFrameX, 20, 100, 100);
    [self.view addSubview:pokeImageView];
    
    peopleFrameX -= self.view.frame.size.width /15;
    peopleImageView.frame = CGRectMake(self.view.frame.size.width-100+peopleFrameX, self.view.frame.size.height/2-110, 100, 100);
    [self.view addSubview:peopleImageView];
    
    if (pokeFrameX>=self.view.frame.size.width-100) {
        [pokeImgMove invalidate];
        //固定
        pokeImageView.frame = CGRectMake(self.view.frame.size.width-100, 20, 100, 100);
        peopleImageView.frame = CGRectMake(0, self.view.frame.size.height/2-110, 100, 100);
        [_BtnLabelleft setEnabled:YES];
        [_BtnLabelright setEnabled:YES];
    }
    
}

@end
