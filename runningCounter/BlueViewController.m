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
    MCPeerID *enemyPeerID,*myPeerID;
    NSString *displayName;
    NSDictionary *myDict,*enemyDict;
    int myHP,enemyHP;
    BOOL first;
    NSArray *array;
}
@property (weak, nonatomic) IBOutlet UIButton *btnA;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIButton *btnC;

@property (weak, nonatomic) IBOutlet UILabel *myHPLabel;
@property (weak, nonatomic) IBOutlet UILabel *enemyHPLabel;

@property SessionHelper *sessionHelper;
@end

@implementation BlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    first = NO;
    myPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    [self performSelector:@selector(openBrowser) withObject:nil afterDelay:0.3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)attackbtn:(UIButton *)sender {
    enemyPeerID = [self.sessionHelper connectedPeerIDAtIndex:0];
    NSLog(@"send to peerID:%@",enemyPeerID.displayName);
    
    NSString *buttonValue = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    NSArray *attackarray = [[NSArray alloc]initWithObjects:buttonValue, nil];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:attackarray];
    _btnA.hidden = YES;
    _btnB.hidden = YES;
    [self.sessionHelper sendData:data peerID:enemyPeerID];

    [self checkBigOrSmall:attackarray whoPeerID:myPeerID];
    
}

- (IBAction)takeCbtn:(id)sender {
    enemyPeerID = [self.sessionHelper connectedPeerIDAtIndex:0];
    NSArray *teamarray = [[myPlist shareInstanceWithplistName:@"team"] getDataFromPlist];
    myDict = [teamarray objectAtIndex:0];
    myHP = [[myDict objectForKey:@"attack"] intValue]*2;
    _myHPLabel.text = [NSString stringWithFormat:@"HP : %d",myHP];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:teamarray];
    [self.sessionHelper sendData:data peerID:enemyPeerID];
    
    _btnC.hidden = YES;
}

- (void)checkBigOrSmall:(NSArray *)NSArray whoPeerID:(MCPeerID *)peerID{
    
    if (array == nil) {
            array = NSArray;
        }
        else
        {
    
            NSString *str = [array objectAtIndex:0];
            NSString *str2 = [NSArray objectAtIndex:0];
    
            if (peerID == myPeerID) {
                if ([str integerValue]<[str2 integerValue]) {
                    _btnA.hidden = NO;
                    _btnB.hidden = NO;
                    NSLog(@"Win");
                    enemyHP -= [[myDict objectForKey:@"attack"] intValue];
                    _enemyHPLabel.text = [NSString stringWithFormat:@"Enemy HP : %d",enemyHP];
                    NSLog(@"I : %d E : %d",myHP,enemyHP);
                }
                else
                {
                    _btnA.hidden=NO;
                    _btnB.hidden = NO;
                    NSLog(@"lost");
                    myHP -= [[enemyDict objectForKey:@"attack"] intValue];
                    _myHPLabel.text = [NSString stringWithFormat:@"My HP : %d",myHP];
                    NSLog(@"I : %d E : %d",myHP,enemyHP);
                }
            }
            else
            {
                if ([str integerValue]>[str2 integerValue]) {
                    _btnA.hidden = NO;
                    _btnB.hidden = NO;
                    NSLog(@"I win");
                    enemyHP -= [[myDict objectForKey:@"attack"] intValue];
                    _enemyHPLabel.text = [NSString stringWithFormat:@"Enemy HP : %d",enemyHP];
                    NSLog(@"I : %d E : %d",myHP,enemyHP);
                }
                else
                {
                    _btnA.hidden=NO;
                    _btnB.hidden = NO;
                    NSLog(@"I lost");
                    myHP -= [[enemyDict objectForKey:@"attack"] intValue];
                    _myHPLabel.text = [NSString stringWithFormat:@"My HP : %d",myHP];
                    NSLog(@"I : %d E : %d",myHP,enemyHP);
                }
            }
            array = nil;
            if (myHP ==0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"lose" message:@"you bad" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.delegate = self;
                [alert show];
            }else if (enemyHP == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Win" message:@"you good" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.delegate = self;
                [alert show];
            }
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
// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
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


- (void)sessionHelperDidRecieveArray:(NSArray *)Array peer:(MCPeerID *)peerID {
    
    //NSLog(@"receive array:%@",Array);
    if (first == NO) {
        enemyDict = [Array objectAtIndex:0];
        enemyHP = [[enemyDict objectForKey:@"attack"] intValue]*2;
        _enemyHPLabel.text = [NSString stringWithFormat:@"enemy HP : %d",enemyHP];
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
