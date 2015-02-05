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
    NSString *myPokeName,*enemyPokeName;
    
    //是否第一次拿資料
    BOOL first;
    
    NSArray *checkArray;
    // 招數次數
    int skillOne,skillTwo;
}
@property (weak, nonatomic) IBOutlet UILabel *enemyName;
@property (weak, nonatomic) IBOutlet UIProgressView *enemyHPProgress;
@property (weak, nonatomic) IBOutlet UILabel *enemyHP;

@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UIProgressView *myHPProgress;
@property (weak, nonatomic) IBOutlet UILabel *myHP;

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
    skillOne = 1;
    skillTwo = 2;
    // 設定peerID名字 & 延遲觸發
    myPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    [self performSelector:@selector(openBrowser) withObject:nil afterDelay:0.3];
    
    _commondBtn.layer.cornerRadius = self.commondBtn.frame.size.width/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)attackAllBtn:(UIButton *)sender {
    NSString *buttonValue = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    NSString *attack = [NSString new];
    if ([buttonValue intValue] == 1) {
        attack = [NSString stringWithFormat:@"%d",myAttack+arc4random()%5+1];
        skillOne--;
        if (skillOne == 0) {
            _skill1Btn.backgroundColor = [UIColor grayColor];
            _skill1Btn.enabled = NO;
        }
    }
    else if ([buttonValue intValue] == 2)
    {
        attack = [NSString stringWithFormat:@"%d",myAttack+arc4random()%7+1];
        skillTwo--;
        if (skillTwo == 0) {
            _skill2Btn.backgroundColor = [UIColor grayColor];
            _skill2Btn.enabled = NO;
        }
    }
    else if ([buttonValue intValue] == 3)
    {
        attack = [NSString stringWithFormat:@"%d",myAttack];
    }
    
    NSArray *attackArray = [[NSArray alloc]initWithObjects:attack, nil];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:attackArray];
    
    [self.sessionHelper sendData:data peerID:enemyPeerID];
    
    [self checkBigOrSmall:attackArray whoPeerID:myPeerID];

}

- (void)checkBigOrSmall:(NSArray *)nsArray whoPeerID:(MCPeerID *)peerID{
    
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
            _myHP.text = [NSString stringWithFormat:@"%@HP : %d",myPokeName,myHP];
            _enemyHP.text = [NSString stringWithFormat:@"%@HP : %d",enemyPokeName,enemyHP];
            NSLog(@"peerID like %@,%@",str,str2);
        }
        else
        {
            myHP -= [str2 intValue];
            enemyHP -= [str intValue];
            _myHP.text = [NSString stringWithFormat:@"%@HP : %d",myPokeName,myHP];
            _enemyHP.text = [NSString stringWithFormat:@"%@HP : %d",enemyPokeName,enemyHP];
            NSLog(@"peerID NO %@,%@",str,str2);
        }
    }
    [self alertWhoHPisZero];
    
}

-(void) attackSpecially
{
//    UIView *view
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
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

-(void) openBrowser
{
    self.sessionHelper = [[SessionHelper alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.sessionHelper.delegate = self;
    
    MCBrowserViewController *bvc = [[MCBrowserViewController alloc] initWithServiceType:@"Blue" session:self.sessionHelper.session];
    
//    bvc.maximumNumberOfPeers = 2;
    
    bvc.delegate =self;
    
    [self presentViewController:bvc animated:YES completion:nil];
}

#pragma mark Browser
// Notifies the delegate, when the user taps the done button  送出隊伍資料
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [browserViewController dismissViewControllerAnimated:YES completion:^{
        enemyPeerID = [self.sessionHelper connectedPeerIDAtIndex:0];
        NSArray *teamarray = [[myPlist shareInstanceWithplistName:@"team"] getDataFromPlist];
        myDict = [teamarray objectAtIndex:0];
        myHP = [[myDict objectForKey:@"hp"] intValue];
        myAttack = [[myDict objectForKey:@"attack"]intValue];
        myPokeName = [myDict objectForKey:@"name"];
        _myHP.text = [NSString stringWithFormat:@"%@HP : %d",myPokeName,myHP];
        
        _myName.text = [NSString stringWithFormat:@"%@",myPeerID.displayName];
        _skill1Btn.titleLabel.text = [NSString stringWithFormat:@"%@ %d次",
                                      [myDict objectForKey:@"skill1"],skillOne];
        _skill2Btn.titleLabel.text = [NSString stringWithFormat:@"%@ %d次",
                                      [myDict objectForKey:@"skill2"],skillTwo];
        _commondBtn.titleLabel.text = [NSString stringWithFormat:@"Attack"];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:teamarray];
        [self.sessionHelper sendData:data peerID:enemyPeerID];
    }];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

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
        enemyPeerID = peerID;
        enemyDict = [Array objectAtIndex:0];
        enemyHP = [[enemyDict objectForKey:@"hp"] intValue];
        enemyPokeName = [enemyDict objectForKey:@"name"];
        _enemyHP.text = [NSString stringWithFormat:@"%@HP : %d",enemyPokeName,enemyHP];
        first = YES;
    }
    else
    {
        
        [self checkBigOrSmall:Array whoPeerID:peerID];
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
