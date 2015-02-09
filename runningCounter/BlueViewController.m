//
//  BlueViewController.m
//  runningCounter
//
//  Created by ChingHua on 2015/2/4.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "BlueViewController.h"
#import "myPlist.h"

@interface BlueViewController ()
{
    NSString *displayName;
    
    MCPeerID *enemyPeerID,*myPeerID;
    NSDictionary *myDict,*enemyDict;
    int myHP,enemyHP,myAttack;
    int myFixedHP,enemyFixedHP;// 固定的血
    NSString *myPokeName,*enemyPokeName;
    
    //是否第一次拿資料
    BOOL first;
    
    NSArray *checkArray;
    // 招數次數
    int skillOne,skillTwo;
    // 進畫面移動
    NSTimer *pokeImgMove;
    NSTimer *EnemyPokeImgMove;
    NSTimer *shake;
    int frameShake; // 攻擊動畫
    int myPokeFrameX,enemyPokeFrameX;
    UIImageView *myPokeImage,*enemyPoekImage;
    // 自己隊伍資料
    NSArray *teamarray;
    
    UILabel *attackLabel;
    int LabelTime;
}
@property (weak, nonatomic) IBOutlet UILabel *enemyName;
@property (weak, nonatomic) IBOutlet UIProgressView *enemyHPProgress;
@property (weak, nonatomic) IBOutlet UILabel *enemyHPLabel;

@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UIProgressView *myHPProgress;
@property (weak, nonatomic) IBOutlet UILabel *myHPLabel;

@property (weak, nonatomic) IBOutlet UIButton *skill1Btn;
@property (weak, nonatomic) IBOutlet UIButton *skill2Btn;
@property (weak, nonatomic) IBOutlet UIButton *commondBtn;

@property SessionHelper *sessionHelper;
@end

@implementation BlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    first = NO;
    skillOne = 2;
    skillTwo = 2;
    enemyPokeFrameX = 0;
    myPokeFrameX = 0;
    frameShake = 0;
    LabelTime = 1;
    
    // 設定peerID名字
    myPeerID = [[MCPeerID alloc] initWithDisplayName:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    // 自己戰隊顯示
    teamarray = [[myPlist shareInstanceWithplistName:@"team"] getDataFromPlist];
    myDict = [teamarray objectAtIndex:0];
    myHP = [[myDict objectForKey:@"hp"] intValue];
    myFixedHP = myHP;
    myAttack = [[myDict objectForKey:@"attack"]intValue];
    myPokeName = [myDict objectForKey:@"name"];
    _myHPLabel.text = [NSString stringWithFormat:@"%@HP : %d",myPokeName,myHP];
    
    _myName.text = [NSString stringWithFormat:@"%@",myPeerID.displayName];
    
    NSString *myskill1 = [myDict objectForKey:@"skill1"];
    NSString *btnTitle = [NSString stringWithFormat:@"%@ %d次",myskill1,skillOne];
    [_skill1Btn setTitle:btnTitle forState:UIControlStateNormal];
    
    NSString *myskill2 = [myDict objectForKey:@"skill2"];
    NSString *btn2Title = [NSString stringWithFormat:@"%@ %d次",myskill2,skillTwo];
    [_skill2Btn setTitle:btn2Title forState:UIControlStateNormal];
    
    [_commondBtn setTitle:@"Attack" forState:UIControlStateNormal];
    [self.myHPProgress setProgress:(float)myHP/myFixedHP];
    
    //秀出自己圖片
    [self showPokemonImage];
    
    //好屌好屌
    [self.commondBtn setNeedsLayout];
    [self.commondBtn layoutIfNeeded];
    
    self.commondBtn.layer.cornerRadius = self.commondBtn.frame.size.width/2;

    self.sessionHelper = [SessionHelper shareInstance];
    self.sessionHelper.delegate = self;
    
    _skill1Btn.userInteractionEnabled = NO;
    _skill2Btn.userInteractionEnabled = NO;
    _commondBtn.userInteractionEnabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)attackAllBtn:(UIButton *)sender {
    
    NSString *attack ,*name;
    if (sender.tag == 1) {
        skillOne--;
        NSString *myskill1 = [myDict objectForKey:@"skill1"];
        NSString *btnTitle = [NSString stringWithFormat:@"%@ %d次",myskill1,skillOne];
        [_skill1Btn setTitle:btnTitle forState:UIControlStateNormal];
        
        attack = [NSString stringWithFormat:@"%d",myAttack+arc4random()%5+1];
        name = [NSString stringWithFormat:@"%@",myskill1];
        
        if (skillOne == 0) {
            _skill1Btn.backgroundColor = [UIColor grayColor];
        }
    }
    else if (sender.tag == 2)
    {
        skillTwo --;
        NSString *myskill2 = [myDict objectForKey:@"skill2"];
        NSString *btnTitle = [NSString stringWithFormat:@"%@ %d次",myskill2,skillTwo];
        [_skill2Btn setTitle:btnTitle forState:UIControlStateNormal];
        
        attack = [NSString stringWithFormat:@"%d",myAttack+arc4random()%7+1];
        name = [NSString stringWithFormat:@"%@",myskill2];
        if (skillTwo == 0) {
            _skill2Btn.backgroundColor = [UIColor grayColor];
        }
    }
    else if (sender.tag == 3)
    {
        NSString *myskill3 = [NSString stringWithFormat:@"普通攻擊"];
        attack = [NSString stringWithFormat:@"%d",myAttack];
        name = [NSString stringWithFormat:@"%@",myskill3];
    }
    
    _skill1Btn.userInteractionEnabled = NO;
    _skill2Btn.userInteractionEnabled = NO;
    _commondBtn.userInteractionEnabled = NO;
    NSArray *attackArray = [[NSArray alloc]initWithObjects:attack,name,nil];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:attackArray];
    
    [self.sessionHelper sendData:data peerID:enemyPeerID];
    
    [self checkBigOrSmall:attackArray whoPeerID:myPeerID];

}

- (void)checkBigOrSmall1:(NSArray *)nsArray whoPeerID:(MCPeerID *)peerID
{
    if (checkArray == nil) {
        checkArray = nsArray;
        if (peerID == myPeerID) {
            
        }
        else
        {
            
        }
    }
    else
    {
        NSString *str = [checkArray objectAtIndex:0];
        NSString *str2 = [nsArray objectAtIndex:0];
        if (peerID == myPeerID)
        {
            myHP -= [str intValue];
            enemyHP -= [str2 intValue];
            if (myHP<=0) {
                myHP = 0;
            }else if (enemyHP<=0){
                enemyHP = 0;
            }
            _myHPLabel.text = [NSString stringWithFormat:@"%@HP : %d",myPokeName,myHP];
            _enemyHPLabel.text = [NSString stringWithFormat:@"%@HP : %d",enemyPokeName,enemyHP];
            [self.myHPProgress setProgress:(float)myHP/myFixedHP];
            [self.enemyHPProgress setProgress:(float)enemyHP/enemyFixedHP];
            NSLog(@"peerID like %@,%@",str,str2);
        }
        else
        {
            myHP -= [str2 intValue];
            enemyHP -= [str intValue];
            if (myHP<=0) {
                myHP = 0;
            }else if (enemyHP<=0){
                enemyHP = 0;
            }
            _myHPLabel.text = [NSString stringWithFormat:@"%@HP : %d",myPokeName,myHP];
            _enemyHPLabel.text = [NSString stringWithFormat:@"%@HP : %d",enemyPokeName,enemyHP];
            [self.myHPProgress setProgress:(float)myHP/myFixedHP];
            [self.enemyHPProgress setProgress:(float)enemyHP/enemyFixedHP];
            NSLog(@"peerID NO %@,%@",str,str2);
        }
        if (skillOne > 0 & skillTwo > 0) {
            _skill1Btn.userInteractionEnabled = YES;
            _skill2Btn.userInteractionEnabled = YES;
            _commondBtn.userInteractionEnabled = YES;
        }else if (skillOne == 0 & skillTwo > 0)
        {
            _skill2Btn.userInteractionEnabled = YES;
            _commondBtn.userInteractionEnabled = YES;
        }else if (skillTwo == 0 & skillOne>0){
            _skill1Btn.userInteractionEnabled = YES;
            _commondBtn.userInteractionEnabled = YES;
        }
        else if (skillOne == 0 & skillTwo == 0){
            _commondBtn.userInteractionEnabled = YES;
        }
        checkArray = nil;
    }
    [self alertWhoHPisZero];
    
}
- (void)checkBigOrSmall:(NSArray *)nsArray whoPeerID:(MCPeerID *)peerID
{
    NSString *str = [nsArray objectAtIndex:0];
    if (peerID == myPeerID) {
        enemyHP -= [str intValue];
        if (enemyHP<=0)  enemyHP = 0;
        _enemyHPLabel.text = [NSString stringWithFormat:@"%@HP : %d",enemyPokeName,enemyHP];
        [self.enemyHPProgress setProgress:(float)enemyHP/enemyFixedHP];
        NSLog(@"對敵人傷害 %@",str);
    }
    else
    {
        myHP -= [str intValue];
        if (myHP<=0)  myHP = 0;
        _myHPLabel.text = [NSString stringWithFormat:@"%@HP : %d",myPokeName,myHP];
        [self.myHPProgress setProgress:(float)myHP/myFixedHP];
        NSLog(@"受到傷害 %@",str);
    }
    [self attackSpecially:nsArray whoPeerID:peerID];
    [self alertWhoHPisZero];
}

-(void) showLabel:(MCPeerID*)peerID
{
    attackLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,
                                                           self.view.frame.size.height/3*2+20,
                                                           self.view.frame.size.width-20,
                                                           self.view.frame.size.height/3-10)];
    attackLabel.font = [UIFont boldSystemFontOfSize:20];
    attackLabel.textAlignment = NSTextAlignmentCenter;
    attackLabel.backgroundColor = [UIColor whiteColor];
    if (peerID == myPeerID) {
        attackLabel.text = [NSString stringWithFormat:@"%@ 準備進行攻擊",enemyPokeName];
    }
    else
    {
        attackLabel.text = [NSString stringWithFormat:@"%@ 準備進行攻擊",myPokeName];
    }
    
    [self.view addSubview:attackLabel];
    [self.view bringSubviewToFront:attackLabel];
}

#pragma mark 攻擊效果
-(void) attackSpecially:(NSArray *)array whoPeerID:(MCPeerID *)peerID
{
    if (LabelTime == 1) {
        [self showLabel:peerID];
        if (peerID == myPeerID) {
            NSString *skill = [array objectAtIndex:1];
            attackLabel.text = [NSString stringWithFormat:@"%@ 使出 %@",myPokeName,skill];
            shake = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(myShakeimage) userInfo:nil repeats:YES];
        }
        else
        {
            NSString *skill = [array objectAtIndex:1];
            attackLabel.text = [NSString stringWithFormat:@"%@ 使出 %@",enemyPokeName,skill];
            shake = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(enemyShakeimage) userInfo:nil repeats:YES];
        }
        [self showLabel:peerID];
        LabelTime ++;
    }
    else
    {
        if (peerID == myPeerID) {
            NSString *skill = [array objectAtIndex:1];
            attackLabel.text = [NSString stringWithFormat:@"%@ 使出 %@",myPokeName,skill];
            shake = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(myShakeimage) userInfo:nil repeats:YES];
        }
        else
        {
            NSString *skill = [array objectAtIndex:1];
            attackLabel.text = [NSString stringWithFormat:@"%@ 使出 %@",enemyPokeName,skill];
            shake = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(enemyShakeimage) userInfo:nil repeats:YES];
        }
        [self performSelector:@selector(cancelAttackSpecially) withObject:nil afterDelay:2];
        LabelTime = 0;
    }
    /*
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    view.backgroundColor = [UIColor redColor];
    view.alpha = 0.1;
    
    UIImage *mypoke = [UIImage imageNamed:[myDict objectForKey:@"image"]];
    UIImageView *myPokeImage = [[UIImageView alloc]initWithImage:mypoke];
    myPokeImage.frame = CGRectMake(0, 15, 100, 100);
    [self.view addSubview:myPokeImage];
    
    UIImage *enemypoke = [UIImage imageNamed:[enemyDict objectForKey:@"image"]];
    UIImageView *enemyPoekImage = [[UIImageView alloc]initWithImage:enemypoke];
    enemyPoekImage.frame = CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height/2-165, 100, 100);
    [self.view addSubview:enemyPoekImage];
    
    //time
    pokeImgMove = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changePokeImage) userInfo:nil repeats:YES];
  */
}

-(void) myShakeimage
{
    if (0 <= frameShake && frameShake < 15) {
        CGRect frame = CGRectMake(myPokeImage.frame.origin.x+15,myPokeImage.frame.origin.y-15,myPokeImage.frame.size.width,myPokeImage.frame.size.height);
        myPokeImage.frame = frame;
        frameShake += 15;
        NSLog(@"aa %d",frameShake);
    }
    else if (15 <= frameShake && frameShake< 30)
    {
        CGRect frame = CGRectMake(myPokeImage.frame.origin.x-15,myPokeImage.frame.origin.y+15,myPokeImage.frame.size.width,myPokeImage.frame.size.height);
        myPokeImage.frame = frame;
        frameShake += 15;
        NSLog(@"a %d",frameShake);
    }
    else if (frameShake >= 30)
    {
        [shake invalidate];
        frameShake = 0;
    }
}

-(void) enemyShakeimage
{
    if (0 <= frameShake && frameShake < 15) {
        CGRect frame = CGRectMake(enemyPoekImage.frame.origin.x-15,enemyPoekImage.frame.origin.y+15, enemyPoekImage.frame.size.width, enemyPoekImage.frame.size.height);
        enemyPoekImage.frame = frame;
        frameShake += 15;
    }
    else if (15 <= frameShake && frameShake < 30)
    {
        CGRect frame = CGRectMake(enemyPoekImage.frame.origin.x+15,enemyPoekImage.frame.origin.y-15, enemyPoekImage.frame.size.width, enemyPoekImage.frame.size.height);
        enemyPoekImage.frame = frame;
        frameShake += 15;
        NSLog(@"b %d",frameShake);
    }
    else if (frameShake >= 30)
    {
        [shake invalidate];
        frameShake = 0;
    }
}

-(void)cancelAttackSpecially
{
    [attackLabel removeFromSuperview];
}

#pragma mark AlertView Who Win
-(void) alertWhoHPisZero
{
    if (myHP <= 0 & enemyHP >0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bad News" message:@"You Lose" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        alert.delegate = self;
        
        [alert show];
    }
    else if (enemyHP <= 0 & myHP > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Good News" message:@"You Win" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        alert.delegate = self;
        
        [alert show];
    }
    else if (enemyHP <= 0 & myHP <=0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"馬麻滴~平手了" message:@"Nobody Win" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        alert.delegate = self;
        
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

#pragma mark - SessionHelper delegate
/*
-(void)sessionHelperDIdChangeNoConnected:(SessionHelper*)sessionHelper{
        [self dismissViewControllerAnimated:YES completion:^{
            //
        }];
    NSLog(@"blue no connected");
}*/

- (void)sessionHelperDidChangeConnectedPeers:(SessionHelper *)sessionHelper {
    NSLog(@"do");
    
}

//- (void)sessionHelperDidSendData:(NSData *)data {
//    
//    sendArray = [NSArray new];
//    sendArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    NSLog(@"sendArray:%@",sendArray);
//    
//    self.btnA.enabled = NO;
//    self.btnB.enabled = NO;
//    self.btnC.enabled = NO;
//    
//    [self checkBigOrSmall];
//    
//}

//對手資料
- (void)sessionHelperDidRecieveArray:(NSArray *)Array peer:(MCPeerID *)peerID {
    
    NSLog(@"receive array:%@",Array);
    if (first == NO) {
        NSLog(@"first receive");
        enemyPeerID = peerID;
        enemyDict = [Array objectAtIndex:0];
        enemyHP = [[enemyDict objectForKey:@"hp"] intValue];
        enemyFixedHP = enemyHP;
        enemyPokeName = [enemyDict objectForKey:@"name"];
        _enemyHPLabel.text = [NSString stringWithFormat:@"%@HP : %d",enemyPokeName,enemyHP];
        _enemyName.text = [NSString stringWithFormat:@"%@",peerID.displayName];
        
        [self.enemyHPProgress setProgress:(float)enemyHP/enemyFixedHP];
        [self showEnemyPokeImage];
        _skill1Btn.userInteractionEnabled = YES;
        _skill2Btn.userInteractionEnabled = YES;
        _commondBtn.userInteractionEnabled = YES;
        if (_enemyall == NO) {
            // 自己的對戰資料
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:teamarray];
            [self.sessionHelper sendData:data peerID:enemyPeerID];
            _enemyall = YES;
            _skill1Btn.userInteractionEnabled = NO;
            _skill2Btn.userInteractionEnabled = NO;
            _commondBtn.userInteractionEnabled = NO;
        }
        first =YES;
    }
    else
    {
        [self checkBigOrSmall:Array whoPeerID:peerID];
        NSLog(@"receive success");
        if (skillOne > 0 & skillTwo > 0)
        {
            _skill1Btn.userInteractionEnabled = YES;
            _skill2Btn.userInteractionEnabled = YES;
            _commondBtn.userInteractionEnabled = YES;
        }else if (skillOne == 0 & skillTwo > 0)
        {
            _skill2Btn.userInteractionEnabled = YES;
            _commondBtn.userInteractionEnabled = YES;
        }else if (skillTwo == 0 & skillOne>0)
        {
            _skill1Btn.userInteractionEnabled = YES;
            _commondBtn.userInteractionEnabled = YES;
        }else if (skillOne == 0 & skillTwo == 0)
        {
            _commondBtn.userInteractionEnabled = YES;
        }
    }
    
}


#pragma mark 設置自己位置
-(void)showPokemonImage{
    UIImage *mypoke = [UIImage imageNamed:[myDict objectForKey:@"image"]];
    myPokeImage = [[UIImageView alloc]initWithImage:mypoke];
    myPokeImage.frame = CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height/2, 100, 100);
    [self.view addSubview:myPokeImage];
    
    //timer
    pokeImgMove = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changePokeImage) userInfo:nil repeats:YES];
}

#pragma mark 改變自己位置
-(void)changePokeImage{
    //    changeFrameTime -= 0.1;
    myPokeFrameX += self.view.frame.size.width /15;
    myPokeImage.frame = CGRectMake(self.view.frame.size.width-100-myPokeFrameX, self.view.frame.size.height/2, 100, 100);
//    [self.view addSubview:myPokeImage];
    
    if (myPokeFrameX >= self.view.frame.size.width-100) {
        [pokeImgMove invalidate];
        //固定在左右
        myPokeImage.frame = CGRectMake(0, self.view.frame.size.height/2, 100, 100);
        //歸零
        myPokeFrameX = 0;
    }
}

#pragma mark 設置對手位置
-(void)showEnemyPokeImage{
    
    UIImage *enemypoke = [UIImage imageNamed:[enemyDict objectForKey:@"image"]];
    enemyPoekImage = [[UIImageView alloc]initWithImage:enemypoke];
    enemyPoekImage.frame = CGRectMake(0, 20, 100, 100);
    [self.view addSubview:enemyPoekImage];
    
    //timer
    EnemyPokeImgMove = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeEnemyPokeImage) userInfo:nil repeats:YES];
}

#pragma mark 改變對手位置
-(void)changeEnemyPokeImage{
    enemyPokeFrameX += self.view.frame.size.width /15;
    enemyPoekImage.frame = CGRectMake(enemyPokeFrameX, 20, 100, 100);
//    [self.view addSubview:enemyPoekImage];
    
    if (enemyPokeFrameX >= self.view.frame.size.width-100) {
        [EnemyPokeImgMove invalidate];
        //固定在左右
        enemyPoekImage.frame = CGRectMake(self.view.frame.size.width-100, 20, 100, 100);
        //歸零
        enemyPokeFrameX = 0;
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
