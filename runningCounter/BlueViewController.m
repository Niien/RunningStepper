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
    int myPokeFrameX,enemyPokeFrameX;
    UIImageView *myPokeImage,*enemyPoekImage;
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
    // 設定peerID名字 & 延遲觸發
    myPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    [self performSelector:@selector(openBrowser) withObject:nil afterDelay:0.3];
    
    //好屌好屌
    [self.commondBtn setNeedsLayout];
    [self.commondBtn layoutIfNeeded];
    
    self.commondBtn.layer.cornerRadius = self.commondBtn.frame.size.width/2;



    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gosetting) name:@"GoSetting" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)attackAllBtn:(UIButton *)sender {
    
    NSString *attack ;
    if (sender.tag == 1) {
        skillOne--;
        attack = [NSString stringWithFormat:@"%d",myAttack+arc4random()%5+1];
        
        NSString *myskill1 = [myDict objectForKey:@"skill1"];
        NSString *btnTitle = [NSString stringWithFormat:@"%@ %d次",myskill1,skillOne];
        [_skill1Btn setTitle:btnTitle forState:UIControlStateNormal];
        
        if (skillOne == 0) {
            _skill1Btn.backgroundColor = [UIColor grayColor];
        }
    }
    else if (sender.tag == 2)
    {
        skillTwo --;
        attack = [NSString stringWithFormat:@"%d",myAttack+arc4random()%7+1];

        NSString *myskill2 = [myDict objectForKey:@"skill2"];
        NSString *btnTitle = [NSString stringWithFormat:@"%@ %d次",myskill2,skillTwo];
        [_skill2Btn setTitle:btnTitle forState:UIControlStateNormal];
        
        if (skillTwo == 0) {
            _skill2Btn.backgroundColor = [UIColor grayColor];
        }
    }
    else if (sender.tag == 3)
    {
        attack = [NSString stringWithFormat:@"%d",myAttack];
    }
    
    _skill1Btn.userInteractionEnabled = NO;
    _skill2Btn.userInteractionEnabled = NO;
    _commondBtn.userInteractionEnabled = NO;
    NSArray *attackArray = [[NSArray alloc]initWithObjects:attack, nil];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:attackArray];
    
    [self.sessionHelper sendData:data peerID:enemyPeerID];
    
    [self checkBigOrSmall:attackArray whoPeerID:myPeerID];

}

- (void)checkBigOrSmall:(NSArray *)nsArray whoPeerID:(MCPeerID *)peerID
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

#pragma mark 攻擊效果
-(void) attackSpecially
{
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
/*
-(void) openBrowser
{
    self.sessionHelper = [[SessionHelper alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.sessionHelper.delegate = self;
    
    MCBrowserViewController *bvc = [[MCBrowserViewController alloc] initWithServiceType:@"Blue" session:self.sessionHelper.session];
    
//    bvc.maximumNumberOfPeers = 2;
    
    bvc.delegate =self;
    
    [self presentViewController:bvc animated:YES completion:nil];
}
*/
/*
#pragma mark Browser
// Notifies the delegate, when the user taps the done button  送出隊伍資料
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [browserViewController dismissViewControllerAnimated:YES completion:^{
        enemyPeerID = [self.sessionHelper connectedPeerIDAtIndex:0];
        NSArray *teamarray = [[myPlist shareInstanceWithplistName:@"team"] getDataFromPlist];
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
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:teamarray];
        [self.sessionHelper sendData:data peerID:enemyPeerID];
        
    }];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [browserViewController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoSetting" object:nil];
    }];
}
*/
#pragma mark - SessionHelper delegate

- (void)sessionHelperDidChangeConnectedPeers:(SessionHelper *)sessionHelper {
    
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
    
    //NSLog(@"receive array:%@",Array);
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
        first = YES;
    }
    else
    {
        [self checkBigOrSmall:Array whoPeerID:peerID];
        NSLog(@"receive success");
    }
    
}

// 回到 Setting
-(void)gosetting
{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
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
    [self.view addSubview:myPokeImage];
    
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
    [self.view addSubview:enemyPoekImage];
    
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
