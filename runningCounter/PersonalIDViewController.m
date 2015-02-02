//
//  PersonalIDViewController.m
//  runningCounter
//
//  Created by chiawei on 2015/1/26.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "PersonalIDViewController.h"
#import "LoginVC.h"

@interface PersonalIDViewController ()<UITextFieldDelegate,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>
{
    NSArray *personalData;
    
    NSString *status;
    
    BOOL islogin;
    
    LoginVC *logIn;
    
}

@property (weak, nonatomic) IBOutlet UIButton *LogInButton;

@property (weak, nonatomic) IBOutlet UITextField *heightTextField;

@property (weak, nonatomic) IBOutlet UITextField *weightTextField;

@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@end

@implementation PersonalIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //跟Parse溝通 (猶豫是否放這兒)
    [Parse setApplicationId:@"37sMr08M1ovb6en1nQ7mm6wMa0wZS9w8EBrb8203"
                  clientKey:@"VPIfQhgqixZKALeTzbhIurFTwYOrLZZPqRYS9oRn"];
    
    //
    
    personalData = [[myPlist shareInstanceWithplistName:@"MyPersonalProfile"]getDataFromPlist];

    NSLog(@"personalData:%@",personalData);
    
    if (personalData != nil) {
        
        self.heightTextField.text = [[personalData objectAtIndex:0]objectForKey:@"height"];
        
        self.weightTextField.text = [[personalData objectAtIndex:0]objectForKey:@"weight"];
        
        self.ageTextField.text = [[personalData objectAtIndex:0]objectForKey:@"age"];
        
    }
    
    
}
//進畫面即判斷 是否登入
-(void)viewDidAppear:(BOOL)animated{
    //
    if ([PFUser currentUser]) {
        //若登入
        PFUser *user = [PFUser user];
        NSLog(@"username:%@",user.username);
        _LogInButton.titleLabel.text = @"登出";
    }else{
        //若沒登入
        _LogInButton.titleLabel.text = @"登入";
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//收鍵盤
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.heightTextField resignFirstResponder];
    [self.weightTextField resignFirstResponder];
    [self.ageTextField resignFirstResponder];
    
}


#pragma mark 登入按鈕
- (IBAction)LogInButton:(id)sender {

    if ([PFUser currentUser]) {
        [PFUser logOut];    //若以登入 按了就登出
        NSUserDefaults *usertmp = [NSUserDefaults standardUserDefaults];
        [usertmp setObject:nil forKey:@"username"];
    }
    //繼承自 "已經繼承Parse登入物件的" LoginVC
    logIn = [[LoginVC alloc] init];
    
    logIn.fields = (PFLogInFieldsUsernameAndPassword
                    | PFLogInFieldsLogInButton
                    | PFLogInFieldsSignUpButton
                    | PFLogInFieldsPasswordForgotten
                    | PFLogInFieldsDismissButton);
    
    [logIn.signUpController setFields:(PFSignUpFieldsUsernameAndPassword
                                     | PFSignUpFieldsSignUpButton
                                     | PFSignUpFieldsDismissButton)];

    //要響應：成功與否方法所加
    logIn.delegate = self;
    logIn.signUpController.delegate = self;
    
    //秀出來
    [self presentViewController:logIn animated:YES completion:nil];
    
}

#pragma mark OK返回鈕
- (IBAction)okButton:(id)sender {
    
    if (islogin) {
        status = @"YES";
    }else {
        status = @"NO";
    }
    
    personalData = [[NSArray alloc]initWithObjects:@{@"account":@0,
                                                     @"password":@0,
                                                     @"status":status,
                                                     @"height":self.heightTextField.text,
                                                     @"weight":self.weightTextField.text,
                                                     @"age":self.ageTextField.text,
                                                     }, nil];
    
    
    [[myPlist shareInstanceWithplistName:@"MyPersonalProfile"]saveDataByOverRide:personalData];
    
    NSLog(@"personalData:%@",personalData);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Parse 登入判斷區 (都是餵給delegate吃!)
- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
    NSLog(@"Did Login");
    //把使用者資訊一併抓下來
    NSUserDefaults *usertmp = [NSUserDefaults standardUserDefaults];
    [usertmp setObject:user.username forKey:@"username"];

    NSLog(@"username:%@,password:%@",[usertmp objectForKey:@"username"],[usertmp objectForKey:@"password"]);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"Cancel login");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"Did sign");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"Cancel sign");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
