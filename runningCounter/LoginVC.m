//
//  LoginVC.m
//  runningCounter
//
//  Created by Longfatown on 1/29/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import "LoginVC.h"


@interface LoginVC ()<PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>{
    BOOL didLogInUser : YES;
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //客制外觀
    self.logInView.logInButton.frame = CGRectMake(100,30, 30, 200);
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"25.png"]];
    self.logInView.logo = logoView; // logo can be any UIView

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
