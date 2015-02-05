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

@end

@implementation pokemonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pokemonDict = [NSMutableDictionary new];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    data = [[myPlist shareInstanceWithplistName:@"MyPokemon"]getDataFromPlist];
    
    // 取出目前顯示的那筆資料
    pokemonDict = [data objectAtIndex:self.numberOfIndex];
    NSLog(@"pokemonDict:%@",pokemonDict);
    
//    self.pokemonImage.image = [UIImage imageNamed:[pokemonDict objectForKey:@"image"]];
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
    
    self.LvLabel.text = [NSString stringWithFormat:@"LV:%@",[pokemonDict objectForKey:@"Lv"]];
    
    exp = [[pokemonDict objectForKey:@"exp"]integerValue];
    
    
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
    
    NSInteger Lv = [[pokemonDict objectForKey:@"Lv"] integerValue];
    
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
        NSInteger inputNumber = [textfield.text integerValue];
        
        //            if (inputNumber <= [StepCounter shareStepCounter].power) {
        //
        //                [StepCounter shareStepCounter].power -= inputNumber;
        //                exp += inputNumber;
        //
        //                if (exp > 2000) {
        //                    Lv += (exp /2000);
        //                    exp = exp % 2000;
        //                }
        //            } else {
        //
        //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"精力不夠" message:nil delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
        //                [alert show];
        //
        //            }
        
        exp += inputNumber;
        
        if (exp >= 2000) {
            Lv += (exp /2000);
            exp = exp % 2000;
        }
        
        NSString *EXP = [NSString stringWithFormat:@"%ld",(long)exp];
        NSString *LvStr = [NSString stringWithFormat:@"%ld",(long)Lv];
        
        [pokemonDict setObject:EXP forKey:@"exp"];
        [pokemonDict setObject:LvStr forKey:@"Lv"];
        
        [[myPlist shareInstanceWithplistName:@"MyPokemon"]saveDataByOverRide:data];
        
        self.LvLabel.text = [NSString stringWithFormat:@"等級%@",LvStr];
        }
    }
    else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            
            [data removeObject:pokemonDict];
            
            [StepCounter shareStepCounter].power += (Lv*1000);
            
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
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"輸入給予的精力" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert show];
    
    textfield = [alert textFieldAtIndex:0];
}

#pragma mark 賣出
- (IBAction)SaleButton:(id)sender {
    
    NSInteger Lv = [[pokemonDict objectForKey:@"Lv"] integerValue];
    NSString *message = [NSString stringWithFormat:@"可回收%ld精力",Lv*1000];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"確定要賣掉" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
    alert.tag = 2;
    [alert show];
    
}

#pragma mark 加入隊伍
- (IBAction)addToTeam:(id)sender {
    NSDictionary *empty01 = [NSDictionary new];
    empty01 = @{@"image":@""};
    TeamArray = [[NSMutableArray alloc]initWithArray:[[myPlist shareInstanceWithplistName:@"team"]getDataFromPlist]];
    //NSLog(@"teamArray:%@",TeamArray);
    //
//    int CountBeforeAdd = [TeamArray count];
//    if ([TeamArray count]<=5 || TeamArray == nil) {
//        for (int i=0; i<(5-[TeamArray count]); i++) {
//            [TeamArray addObject:empty01];
//        }
//        [TeamArray removeObjectAtIndex:(5-CountBeforeAdd)];
//    }
    if ([TeamArray count]<=5 || TeamArray == nil) {
    
        [TeamArray addObject:pokemonDict];
        
        [[myPlist shareInstanceWithplistName:@"team"]saveDataWithArray:TeamArray];
        
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
