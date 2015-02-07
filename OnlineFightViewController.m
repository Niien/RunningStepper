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
    //
    NSMutableArray *teamArray;
    NSMutableArray *teamImageArray;
    NSMutableArray *EnemyArray;
    NSMutableArray *EnemyImageArray;
    //
    UILabel *WaitingForLinkingLabel;        //拖延下載時間(讓使用者認為正在搜尋)
    UIImageView *EnemyImageView;
    UIImageView *teamImageView;
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

- (void)viewWillAppear:(BOOL)animated{
    teamArray = [NSMutableArray new];
    teamImageArray = [NSMutableArray new];
    EnemyArray = [NSMutableArray new];
    EnemyImageArray = [NSMutableArray new];
    //
    if ([PFUser currentUser]) {
        //
        NSLog(@"DID LOGIN");
        NSLog(@"%@",[PFUser currentUser].username);
        [self DidExistInFightUserOrNot];
        [self getEnemy];
        
    }
    
    //延遲
    
}
#pragma mark 判斷是否已存在使用者
- (void)DidExistInFightUserOrNot{
    //從Plist抓資料下來
    teamArray = [[myPlist shareInstanceWithplistName:@"team"] getDataFromPlist];
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
                NSLog(@"DID remove");
            }
        }
        //把自己的Team放上去
        PFObject *object = [[PFObject alloc]initWithClassName:@"FightUser"];
        [object setObject:teamArray forKey:@"Team"];
        [object setObject:user.username forKey:@"username"];
        [object saveInBackground];
        NSLog(@"DID update myTeam");
    }];
}


- (void)getEnemy{
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
//    [self dismissViewControllerAnimated:YES completion:nil];
    if ([EnemyArray count]==0) {
        NSLog(@"nill");
    }else{
        NSLog(@"GOT");
        [self SetPokeImage];
    }
}


- (void)SetPokeImage{
    
    //
    for(int i=0;i<[EnemyArray count];i++){
        [EnemyImageArray addObject:[[EnemyArray objectAtIndex:i]valueForKey:@"image"]];
    }
    NSLog(@"DID got:%@",EnemyImageArray);
    EnemyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[EnemyImageArray objectAtIndex:0]]];
    EnemyImageView.frame = CGRectMake(self.view.frame.size.width-100, 20, 100, 100);
    [self.view addSubview:EnemyImageView];
    
    teamImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[[teamArray objectAtIndex:0]valueForKey:@"image"]]];
    teamImageView.frame = CGRectMake(0, self.view.frame.size.height/2, 100, 100);
    [self.view addSubview:teamImageView];
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
