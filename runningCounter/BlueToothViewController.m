//
//  BlueToothViewController.m
//  runningCounter
//
//  Created by Longfatown on 2/4/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import "BlueToothViewController.h"
#import "AppDelegate.h"
#import "myPlist.h"

@interface BlueToothViewController ()
{
    NSDictionary *dict , *endict;
    int hp;
    int enHP;
}

@property (weak, nonatomic) IBOutlet UILabel *Label01;
@property (weak, nonatomic) IBOutlet UILabel *Label02;
@property (weak, nonatomic) IBOutlet UIButton *btnA;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIButton *btnC;

@property NSData *datain;
@property AppDelegate *appDelegate;

@end

@implementation BlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
  
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AttackEnemy:)
                                                 name:@"MCAttack"
                                               object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BtnA:(id)sender {
    NSString *str = @"1";
    NSData * dataToSend = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSArray * allPeers = [[[_appDelegate mcManager] session] connectedPeers];
    NSError *error;
    
    //Mode参数 是2种模式，reliable 和unreliable 一种是不会丢包一种是会丢包
    [[[_appDelegate mcManager] session] sendData:dataToSend toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        
        NSLog(@"%@",[error localizedDescription]);
    }
    _btnA.enabled = NO;
    _btnB.enabled = NO;
    [self whowin:dataToSend whoPeerID:self.appDelegate.mcManager.peerID];
}

- (IBAction)BtnB:(id)sender {
    NSString *str = @"2";
    NSData * dataToSend = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSArray * allPeers = [[[_appDelegate mcManager] session] connectedPeers];
    NSError *error;
    
    //Mode参数 是2种模式，reliable 和unreliable 一种是不会丢包一种是会丢包
    [[[_appDelegate mcManager] session] sendData:dataToSend toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        
        NSLog(@"%@",[error localizedDescription]);
    }
    _btnA.enabled = NO;
    _btnB.enabled = NO;
    [self whowin:dataToSend whoPeerID:self.appDelegate.mcManager.peerID];
}

- (IBAction)BtnC:(id)sender {
    
    NSArray *teamarray = [[myPlist shareInstanceWithplistName:@"team"] getDataFromPlist];
    dict = [teamarray objectAtIndex:0];
    hp = [[dict objectForKey:@"attack"] intValue]*2;
    _Label01.text = [NSString stringWithFormat:@"HP : %d",hp];
    
    NSArray * allPeers = [[[_appDelegate mcManager] session] connectedPeers];
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:teamarray];
     [[[_appDelegate mcManager] session] sendData:data toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    
    _btnC.enabled = NO;
}

#pragma mark 攻擊判斷
-(void)whowin:(NSData *)data whoPeerID:(MCPeerID *)peerID
{
    if (_datain == nil) {
        _datain = data;
    }
    else{
        
        NSString *str = [[NSString alloc] initWithData:_datain encoding:NSUTF8StringEncoding];
        NSString *str2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (peerID == self.appDelegate.mcManager.peerID) {
            if ([str integerValue]<[str2 integerValue]) {
                _btnA.enabled = YES;
                _btnB.enabled = YES;
                NSLog(@"Win %@ < %@",str,str2);
                _Label02.text = [NSString stringWithFormat:@"Enymy HP : %d",enHP - [[dict objectForKey:@"attack"] intValue]];
            }
            else
            {
                _btnA.enabled=YES;
                _btnB.enabled = YES;
                NSLog(@"lost %@ , %@",str,str2);
                _Label01.text = [NSString stringWithFormat:@"HP : %d",hp-[[endict objectForKey:@"attack"] intValue]];
            }
        }
        else
        {
            if ([str integerValue]>[str2 integerValue]) {
                _btnA.enabled = YES;
                _btnB.enabled = YES;
                NSLog(@"woo win %@ , %@",str,str2);
                _Label02.text = [NSString stringWithFormat:@"Enymy HP : %d",enHP - [[dict objectForKey:@"attack"] intValue]];
            }
            else
            {
                _btnA.enabled=YES;
                _btnB.enabled = YES;
                NSLog(@"woo lost %@ , %@",str,str2);
                _Label01.text = [NSString stringWithFormat:@"HP : %d",hp-[[endict objectForKey:@"attack"] intValue]];
            }
        }
        _datain = nil;
    }
    
}
#pragma mark Notification
-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData * receivedData = [[notification userInfo] objectForKey:@"data"];
//    NSString * receivedText = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
//        NSString * receivedText = [[NSString alloc]initWithFormat:@"%@",[array objectAtIndex:0]];
    endict = [array objectAtIndex:0];
    enHP = [[endict objectForKey:@"attack"] intValue] *2;
    _Label02.text = [NSString stringWithFormat:@"Enymy HP : %d",enHP];
    
}

//通知中心传过来的设备连接信息
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification
{
    NSLog(@"%@,%@",[[notification userInfo] objectForKey:@"peerID"],[[notification userInfo] objectForKey:@"state"]);
    
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString * peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] integerValue];
    
    //如果不是正在连接,那么就是已经连接了或者未连接
    if (state != MCSessionStateConnecting) {
        
        if (state == MCSessionStateConnected) {
            
           //
        }
    }else if (state == MCSessionStateNotConnected){//如果未连接从数组中移除
        
     //
        
    }
    
}

-(void) AttackEnemy:(NSNotification *)notification
{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData * receivedData = [[notification userInfo] objectForKey:@"data"];
    //    NSString * receivedText = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
//    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
    //        NSString * receivedText = [[NSString alloc]initWithFormat:@"%@",[array objectAtIndex:0]];
    
        [self whowin:receivedData whoPeerID:peerID];
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
