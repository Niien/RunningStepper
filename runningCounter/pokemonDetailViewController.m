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
    
    self.pokemonImage.image = [UIImage imageNamed:[pokemonDict objectForKey:@"image"]];
    
    self.NameLabel.text = [pokemonDict objectForKey:@"name"];
    
    self.LvLabel.text = [NSString stringWithFormat:@"等級%@",[pokemonDict objectForKey:@"Lv"]];
    
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
        
        NSInteger inputNumber = [textfield.text integerValue];
        
        //            if (inputNumber <= [StepCounter shareStepCounter].power) {
        //
        //                [StepCounter shareStepCounter].power -= inputNumber;
        //                exp += inputNumber;
        //
        //                if (exp > 2000) {
        //
        //                    Lv += (exp /2000);
        //                    exp = exp % 2000;
        //
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

- (IBAction)expButton:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"輸入給予的精力" message:nil delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert show];
    
    textfield = [alert textFieldAtIndex:0];
}


- (IBAction)SaleButton:(id)sender {
    
    NSInteger Lv = [[pokemonDict objectForKey:@"Lv"] integerValue];
    NSString *message = [NSString stringWithFormat:@"可回收%d精力",Lv*1000];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"確定要賣掉" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
    alert.tag = 2;
    [alert show];
    
}

- (IBAction)addToTeam:(id)sender {
    
    NSMutableArray *TeamArray = [[myPlist shareInstanceWithplistName:@"team"]getDataFromPlist];
    
    if ([TeamArray count]<=5) {
        
        [TeamArray addObject:pokemonDict];
        
        [[myPlist shareInstanceWithplistName:@"team"]saveDataWithArray:TeamArray];
        
    }
    
}


- (IBAction)removeTeam:(id)sender {
    
    NSMutableArray *TeamArray = [[myPlist shareInstanceWithplistName:@"team"]getDataFromPlist];
    
    [TeamArray removeObject:pokemonDict];
    
    [[myPlist shareInstanceWithplistName:@"team"]saveDataByOverRide:TeamArray];
    
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
