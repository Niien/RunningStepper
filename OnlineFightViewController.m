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
}

@end

@implementation OnlineFightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //使用delegate的方法

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if ([PFUser currentUser]) {
        //
        NSLog(@"DID LOGIN");
        NSLog(@"%@",[PFUser currentUser].username);
        [self DidExistInFightUserOrNot];
        [self getEnemy];
    }
}

- (void) DidExistInFightUserOrNot{
    NSArray *teamArray = [[myPlist shareInstanceWithplistName:@"team"] getDataFromPlist];
    NSLog(@"team:%@",teamArray);
    PFQuery *checkID = [[PFQuery alloc]initWithClassName:@"FightUser"];
    PFUser *user = [PFUser currentUser];
    [checkID whereKey:@"username" equalTo:user.username];
    [checkID findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([objects count] != 0){
            for(PFObject *obj in objects){
                [obj deleteInBackground];
                NSLog(@"remove");
            }
        }
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
        [objects[i]valueForKey:@"Team"];
        NSLog(@"Enemy:%@",[objects[i]valueForKey:@"Team"]);
    }];

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
