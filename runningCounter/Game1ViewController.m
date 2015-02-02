//
//  Game1ViewController.m
//  runningCounter
//
//  Created by Longfatown on 1/21/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import "Game1ViewController.h"
#import "ViewController.h"
@import AudioToolbox;

//目前神奇寶貝總數
#define NumOfPokeMon 30

@interface Game1ViewController (){
    
    NSTimer *pokeImgMove;
    //
    int goal,myPressPoint;
    float time;
    //
    int randomMonster;
    NSString *imageName;
    NSString *iconName;
    //Pokeimgmove
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
    
    //刪除通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyD" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    //隨機目標數
    time = 6.0;
    goal = arc4random()%50+40;
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
    _myPoint.text = [NSString stringWithFormat:@"%ld",(long)myPressPoint];
    //NSLog(@"%d",myPressPoint);
    
    //按了按鈕才開始
    if (myPressPoint == 1) {
        //設一個倒數計時器 並在分數達標時停止並響鈴
        timeCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(myCountDown:) userInfo:nil repeats:YES];
    }
    
}

- (IBAction)pressedBtnRight:(id)sender {
    myPressPoint++;
    _myPoint.text = [NSString stringWithFormat:@"%ld",(long)myPressPoint];
    //NSLog(@"%d",myPressPoint);

    //按了按鈕才開始
    if (myPressPoint == 1) {
        //設一個倒數計時器 並在分數達標時停止並響鈴
        timeCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(myCountDown:) userInfo:nil repeats:YES];
    }
    
}

-(void)myCountDown:(NSTimer *)timer{
    
    time -=0.1;
    _mytimeLabel.text = [NSString stringWithFormat:@"= %.1f =",time];
    if (time >= 0) {
        if (myPressPoint >= goal) {
            //還有時間 且 已達標
            [timeCountDown invalidate];
            [self SaveToPlist];
            //結束震動
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Succeed" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = 1;  //要分辨多個 Alert 且加動作 就需設tag
            [alert show];
        }
    }else{
        [timeCountDown invalidate];
        //結束震動
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIAlertView *failalert = [[UIAlertView alloc]initWithTitle:@"Failed" message:nil delegate:self cancelButtonTitle:@"QQ" otherButtonTitles:nil];
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

-(void)viewDidDisappear:(BOOL)animated{
    [timeCountDown invalidate];
    [pokeImgMove invalidate];
}

#pragma mark 隨機選取怪獸
- (void)getPokemonNo {
    
    randomMonster = arc4random()%NumOfPokeMon+1;
    
    imageName = [NSString stringWithFormat:@"%d.png",randomMonster];
    iconName = [NSString stringWithFormat:@"%ds.png",randomMonster];
    NSLog(@"imageName:%@",imageName);
    NSLog(@"iconName:%@",iconName);
    
    [self showPokemonImage];
}

#pragma mark 存入Plist
-(void)SaveToPlist{
    NSString *id = [NSString stringWithFormat:@"%d",randomMonster];
    // save data to plist
    NSDictionary *dict = @{@"name":imageName, @"image":imageName, @"iconName":iconName, @"Lv":@"1", @"exp":@"0", @"id":id};
    NSLog(@"G1:%@",dict);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getLocation" object:nil userInfo:dict];

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
        [_BtnLabelleft setEnabled:YES];
        [_BtnLabelright setEnabled:YES];
    }
    
}

@end
