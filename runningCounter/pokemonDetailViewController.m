//
//  pokemonDetailViewController.m
//  runningCounter
//
//  Created by chiawei on 2015/2/1.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "pokemonDetailViewController.h"

@interface pokemonDetailViewController () <UIAlertViewDelegate>
{
    NSMutableArray *data;
    
    NSMutableDictionary *pokemonDict;
    
    UITextField *textfield;
    
    NSInteger exp;
    NSInteger atk;
    NSInteger hp;
    
    NSMutableArray *TeamArray;
    UIImageView *TeamImageView1;
    UIImageView *TeamImageView2;
    UIImageView *TeamImageView3;
    UIImageView *TeamImageView4;
    UIImageView *TeamImageView5;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *pokemonImage;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *LvLabel;
@property (weak, nonatomic) IBOutlet UILabel *FightLabel;
@property (weak, nonatomic) IBOutlet UILabel *Skill1Label;
@property (weak, nonatomic) IBOutlet UILabel *Skill2Label;
@property (weak, nonatomic) IBOutlet UILabel *HPLabel;


@property (weak, nonatomic) IBOutlet UIButton *addTeamButton;
@property (weak, nonatomic) IBOutlet UIButton *saleButton;
@property (weak, nonatomic) IBOutlet UIButton *expButton;

@property (weak, nonatomic) IBOutlet UIProgressView *expProgress;


@end

@implementation pokemonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pokemonDict = [NSMutableDictionary new];
    
    self.expProgress.trackTintColor = [UIColor greenColor];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    data = [[myPlist shareInstanceWithplistName:@"MyPokemon"]getDataFromPlist];

    TeamArray = [[NSMutableArray alloc]initWithArray:[[myPlist shareInstanceWithplistName:@"team"]getDataFromPlist]];
    
    // 取出目前顯示的那筆資料
    pokemonDict = [data objectAtIndex:self.numberOfIndex];
    NSLog(@"pokemonDict:%@",pokemonDict);
    
    if ([TeamArray containsObject:pokemonDict]) {
        
        self.addTeamButton.hidden = YES;
        self.saleButton.hidden = YES;
        self.expButton.hidden = YES;
        
    }
    
    
    UIImage *tmpImage = [UIImage imageNamed:[pokemonDict objectForKey:@"image"]];
    //開始加入邊框
    UIImage *frameImage = [UIImage imageNamed:@"poke_frame(500).png"];
    UIGraphicsBeginImageContext(tmpImage.size);
    [tmpImage drawInRect:CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height)];
    [frameImage drawInRect:CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //加入邊框結束
    self.pokemonImage.image = resultImage;
    
    self.NameLabel.text = [pokemonDict objectForKey:@"name"];
    self.LvLabel.text = [NSString stringWithFormat:@"LV:%@",[pokemonDict objectForKey:@"LV"]];
    self.Skill1Label.text = [pokemonDict objectForKey:@"skill1"];
    self.Skill2Label.text = [pokemonDict objectForKey:@"skill2"];
    
    hp = [[pokemonDict objectForKey:@"hp"]integerValue];
    self.HPLabel.text = [NSString stringWithFormat:@"HP:%ld",(long)hp];
    
    atk = [[pokemonDict objectForKey:@"attack"]integerValue];
    self.FightLabel.text = [NSString stringWithFormat:@"戰力:%ld",(long)atk];
    
    exp = [[pokemonDict objectForKey:@"exp"]integerValue];
    [self.expProgress setProgress:(float)exp/2000];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// hide status bar
- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSInteger Lv = [[pokemonDict objectForKey:@"LV"] integerValue];
    
    if (alertView.tag == 1) { // Lv up
        if (buttonIndex == 1) {
        NSInteger inputNumber = [textfield.text integerValue];
        
//                if (inputNumber <= [StepCounter shareStepCounter].power) {
//        
//                    [StepCounter shareStepCounter].power -= inputNumber;
//                    exp += inputNumber;
//        
//                    if (exp > 2000) {
//                        Lv += (exp /2000);
//                        exp = exp % 2000;
//                        
//                        for (int i = 0; i < (exp /2000); i++) {
//                            
//                            atk += arc4random()%3+3;
//                            hp += arc4random()%6+5;
//                            
//                        }
//                    }
//                }
//                else {
//
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"能量不足" message:nil delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
//                    [alert show];
//        
//                }
        
        exp += inputNumber;
    
        if (exp >= 2000) {
            Lv += (exp /2000);
            exp = exp % 2000;
            atk += arc4random()%3+3;
            hp += arc4random()%6+5;
        }
        
            NSString *EXP = [NSString stringWithFormat:@"%ld",(long)exp];
            NSString *atkStr = [NSString stringWithFormat:@"%ld",(long)atk];
            NSString *LvStr = [NSString stringWithFormat:@"%ld",(long)Lv];
            NSString *hpStr = [NSString stringWithFormat:@"%ld",(long)hp];
            
            [pokemonDict setObject:hpStr forKey:@"hp"];
            [pokemonDict setObject:EXP forKey:@"exp"];
            [pokemonDict setObject:LvStr forKey:@"LV"];
            [pokemonDict setObject:atkStr forKey:@"attack"];
            
            data[self.numberOfIndex] = pokemonDict;
            NSLog(@"data:%@",data);
            
            [[myPlist shareInstanceWithplistName:@"MyPokemon"]saveDataByOverRide:data];
        
            self.LvLabel.text = [NSString stringWithFormat:@"等級%@",LvStr];
            self.HPLabel.text = [NSString stringWithFormat:@"HP:%ld",(long)hp];
            self.FightLabel.text = [NSString stringWithFormat:@"戰力:%ld",(long)atk];
            [self.expProgress setProgress:(float)exp/2000];
            
        }
    }
    else if (alertView.tag == 2) { //sale
        if (buttonIndex == 1) {
            
            [data removeObject:pokemonDict];
            
            [StepCounter shareStepCounter].power += (Lv*500);
            
            [[myPlist shareInstanceWithplistName:@"MyPokemon"]saveDataByOverRide:data];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    }
}

#pragma mark - button Action
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 增加經驗值
- (IBAction)expButton:(id)sender {
    
    NSString *remainingSTEP = [NSString stringWithFormat:@"還可以使用的能量：%ld",(long)[StepCounter shareStepCounter].power];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"輸入想轉移的能量" message:remainingSTEP delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert show];
    
    textfield = [alert textFieldAtIndex:0];
}

#pragma mark 賣出
- (IBAction)SaleButton:(id)sender {
    
    NSInteger Lv = [[pokemonDict objectForKey:@"LV"] integerValue];
    NSString *message = [NSString stringWithFormat:@"可回收%ld能量",Lv*500];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"確定要賣掉" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
    alert.tag = 2;
    [alert show];
    
}

#pragma mark 加入隊伍
- (IBAction)addToTeam:(id)sender {
    
    TeamArray = [[NSMutableArray alloc]initWithArray:[[myPlist shareInstanceWithplistName:@"team"]getDataFromPlist]];
    NSLog(@"teamArray:%@",TeamArray);

    if ([TeamArray count]<5) {
    
        [TeamArray addObject:pokemonDict];
        
        [[myPlist shareInstanceWithplistName:@"team"]saveDataByOverRide:TeamArray];
        
        self.addTeamButton.hidden = YES;
        self.saleButton.hidden = YES;
        self.expButton.hidden = YES;
        
    } else if ([TeamArray count] >= 5) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"隊伍已經滿了" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray: [[myPlist shareInstanceWithplistName:@"team"]getDataFromPlist]];
    NSLog(@"arr:%@",arr);
    
}

#pragma mark 移出隊伍
- (IBAction)removeTeam:(id)sender {
    
    TeamArray = [[NSMutableArray alloc]initWithArray:[[myPlist shareInstanceWithplistName:@"team"]getDataFromPlist]];
    
    NSLog(@"teamArray:%@",TeamArray);
    
    [TeamArray removeObject:pokemonDict];
    
    [[myPlist shareInstanceWithplistName:@"team"]saveDataByOverRide:TeamArray];
    
    self.addTeamButton.hidden = NO;
    self.saleButton.hidden = NO;
    self.expButton.hidden = NO;
    
    NSMutableArray *arr = [[myPlist shareInstanceWithplistName:@"team"]getDataFromPlist];
    NSLog(@"arr:%@",arr);
    
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
