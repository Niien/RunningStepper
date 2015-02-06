//
//  OnlineFightViewController.m
//  runningCounter
//
//  Created by Longfatown on 2/6/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import "OnlineFightViewController.h"

@interface OnlineFightViewController (){
    LoginVC *LogIn;
    NSMutableArray *EnemyArray;
}

@end

@implementation OnlineFightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    EnemyArray = [NSMutableArray new];
    //
    if ([PFUser currentUser]) {
        //
        NSLog(@"DID LOGIN");
        NSLog(@"%@",[PFUser currentUser].username);
        [self DidExistInFightUserOrNot];
        [self getEnemy];
    }
}
#pragma mark 判斷是否已存在使用者
- (void) DidExistInFightUserOrNot{
    //從Plist抓資料下來
    NSArray *teamArray = [[myPlist shareInstanceWithplistName:@"team"] getDataFromPlist];
    NSLog(@"Plist_team:%@",teamArray);
    //取得
    PFQuery *checkID = [[PFQuery alloc]initWithClassName:@"FightUser"];
    PFUser *user = [PFUser currentUser];
    //確認是否有重複
    [checkID whereKey:@"username" equalTo:user.username];
    [checkID findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //若不為空值 便清空 再置入
        if([objects count] != 0){
            for(PFObject *obj in objects){
                [obj deleteInBackground];
                NSLog(@"remove");
            }
        }
        //
        PFObject *object = [[PFObject alloc]initWithClassName:@"FightUser"];
        [object setObject:teamArray forKey:@"Team"];
        [object setObject:user.username forKey:@"username"];
        [object saveInBackground];
        NSLog(@"got");
    }];
}


- (void) getEnemy{
    PFQuery *getID = [[PFQuery alloc]initWithClassName:@"FightUser"];
    //
    [getID findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i = arc4random()%objects.count;
        EnemyArray = [objects[i]valueForKey:@"Team"];
        NSLog(@"Enemy:%@",[objects[i]valueForKey:@"Team"]);
//        [EnemyArray addObjectsFromArray:[objects[i]valueForKey:@"Team"]];
        //把東西抓下來需要一段時間
    }];
}

- (IBAction)Back:(id)sender {
    //暫放
    NSLog(@"EnemyArray:%@",EnemyArray);
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void) viewWillDisappear:(BOOL)animated{
    //Cleaner
    EnemyArray = [NSMutableArray new];
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
