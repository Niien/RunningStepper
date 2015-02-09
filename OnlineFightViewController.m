//
//  OnlineFightViewController.m
//  runningCounter
//
//  Created by Longfatown on 2/6/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import "OnlineFightViewController.h"

@interface OnlineFightViewController () <UIAlertViewDelegate,onlineFightModelDelegate>
{
    LoginVC *LogIn;
    onlineFightModel *onlineFight;
    //
    NSMutableArray *teamArray;
    NSMutableArray *teamImageArray;
    NSMutableArray *EnemyArray;
    NSMutableArray *EnemyImageArray;
    NSMutableArray *skillArray;
    //
    UILabel *WaitingForLinkingLabel;    //拖延下載時間(讓使用者認為正在搜尋)
    UILabel *attackLabel;
    UIImageView *image;
    UIImageView *EnemyImageView;
    UIImageView *teamImageView;
    // 進畫面移動
    NSTimer *pokeImgMove;
    NSTimer *EnemyPokeImgMove;
    int myPokeFrameX,enemyPokeFrameX;
    UIImageView *myPokeImage,*enemyPoekImage;
    
    //
    NSInteger enemyHP;
    NSInteger enemyTotalHP;
    NSString *enemyLV;
    NSString *enemyName;
    NSInteger enemyAttack;
    int enemyIndex;
    
    //
    NSInteger myHP;
    NSInteger myTotalHP;
    NSString *myLV;
    NSString *myName;
    NSInteger myAttack;
    int myIndex;
    
    //
    NSString *selectedSkill;
    
    //
    NSTimer *shake;
    int frameShake;
}

@property (weak, nonatomic) IBOutlet UIProgressView *myHpProgress;
@property (weak, nonatomic) IBOutlet UILabel *myPokeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myHpLabel;

@property (weak, nonatomic) IBOutlet UIButton *FirstSkillButton;
@property (weak, nonatomic) IBOutlet UIButton *SecondSkillButton;
@property (weak, nonatomic) IBOutlet UIButton *CommandATKButton;

@property (weak, nonatomic) IBOutlet UIProgressView *enemyHpProgress;
@property (weak, nonatomic) IBOutlet UILabel *enemyPokeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *enemyHpLabel;

@end

@implementation OnlineFightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    teamArray = [NSMutableArray new];
    teamImageArray = [NSMutableArray new];
    EnemyArray = [NSMutableArray new];
    EnemyImageArray = [NSMutableArray new];
    
    onlineFight = [[onlineFightModel alloc]init];
    onlineFight.delegate = self;
    
    enemyIndex = 0;
    myIndex = 0;
    frameShake = 0;
    
    self.FirstSkillButton.enabled = NO;
    self.SecondSkillButton.enabled = NO;
    self.CommandATKButton.enabled = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    
    //
    if ([PFUser currentUser]) {
        //
        NSLog(@"DID LOGIN");
        NSLog(@"%@",[PFUser currentUser].username);
        [self DidExistInFightUserOrNot];
        [self getEnemy];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"請確認是否登入" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([teamArray count] == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"確認隊伍是否有角色" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
        [alert show];
    }
    
    WaitingForLinkingLabel = [[UILabel alloc]initWithFrame:CGRectMake(
                                                            self.view.frame.size.width/3,
                                                            self.view.frame.size.height/3,
                                                            self.view.frame.size.width/4+30,
                                                            self.view.frame.size.height/4-50)];
    
    [WaitingForLinkingLabel setText:@"搜尋對手..."];
    [WaitingForLinkingLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:WaitingForLinkingLabel];
    [self.view bringSubviewToFront:WaitingForLinkingLabel];
    
    image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"magnifier_50.png"]];
    [image setFrame:CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height/3, self.view.frame.size.width/3-self.view.frame.size.width/4, self.view.frame.size.height/4-50)];
    [self.view addSubview:image];
    [self.view bringSubviewToFront:image];
    
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


#pragma mark 抓取對手資料
- (void)getEnemy{
    PFQuery *getID = [[PFQuery alloc]initWithClassName:@"FightUser"];
    //
    [getID findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        int i = arc4random()%objects.count;
        EnemyArray = [objects[i]valueForKey:@"Team"];
        NSLog(@"Enemy:%@",[objects[i]valueForKey:@"Team"]);
        
        //把東西抓下來需要一段時間
        if ([EnemyArray count] != 0) {
            
            [self performSelector:@selector(GameStart) withObject:nil afterDelay:1.0];
        }
        
    }];
}


- (void) GameStart {
    
    image.alpha = 0;
    WaitingForLinkingLabel.alpha = 0;
    
    [self showMyData];
    [self showEnemyData];
    
}


- (void) viewWillDisappear:(BOOL)animated{
    //Cleaner
    EnemyArray = nil;
}


#pragma mark - get pokemon data
- (void)showEnemyData {
    NSLog(@"enemyIndex:%d",enemyIndex);
    
    if (enemyIndex < [EnemyArray count]) {
        
        enemyName = [EnemyArray[enemyIndex]objectForKey:@"name"];
        enemyHP = [[EnemyArray[enemyIndex]objectForKey:@"hp"]integerValue];
        enemyTotalHP = [[EnemyArray[enemyIndex]objectForKey:@"hp"]integerValue];
        enemyLV = [EnemyArray[enemyIndex]objectForKey:@"LV"];
        enemyAttack = [[EnemyArray[enemyIndex]objectForKey:@"attack"] integerValue];
        
        [self.enemyHpProgress setProgress:(float)enemyHP/enemyTotalHP ];
        self.enemyHpLabel.text = [NSString stringWithFormat:@"%ld",(long)enemyHP];
        self.enemyPokeNameLabel.text = enemyName;
        
        [self showEnemyPokeImage];
        
        skillArray = [NSMutableArray new];
        [skillArray addObject:@"command"];
        [skillArray addObject:[EnemyArray[enemyIndex] objectForKey:@"skill1"]];
        [skillArray addObject:[EnemyArray[enemyIndex] objectForKey:@"skill2"]];
        
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"戰況" message:@"you win" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        
    }
    enemyIndex++;
    
}

- (void)showMyData {
    NSLog(@"myIndex:%d",myIndex);
    
    if (myIndex < [teamArray count]) {
        
        myName = [teamArray[myIndex]objectForKey:@"name"];
        myHP = [[teamArray[myIndex]objectForKey:@"hp"]integerValue];
        myTotalHP = [[teamArray[myIndex]objectForKey:@"hp"]integerValue];
        myLV = [teamArray[myIndex]objectForKey:@"LV"];
        myAttack = [[teamArray[myIndex]objectForKey:@"attack"]integerValue];
        
        [self.myHpProgress setProgress:(float)myHP/myTotalHP ];
        self.myHpLabel.text = [NSString stringWithFormat:@"%ld",(long)myHP];
        self.myPokeNameLabel.text = myName;
        [self.FirstSkillButton setTitle:[teamArray[myIndex]objectForKey:@"skill1"] forState:UIControlStateNormal];
        [self.SecondSkillButton setTitle:[teamArray[myIndex]objectForKey:@"skill2"] forState:UIControlStateNormal];
        
        [self showPokemonImage];
        
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"戰況" message:@"you lose" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        
    }
    myIndex++;
    
    self.FirstSkillButton.enabled = YES;
    self.SecondSkillButton.enabled = YES;
    self.CommandATKButton.enabled = YES;
    
}


#pragma mark - enemy method
- (void)enemyAttack {
    
    int i = arc4random()%3;
    
    if (i == 1) {
        
        enemyAttack += arc4random()%5+1;
        selectedSkill = [skillArray objectAtIndex:i];
        NSLog(@"selectedSkill:%@",selectedSkill);
        
    }
    else if (i == 2) {
        
        enemyAttack += arc4random()%7+1;
        selectedSkill = [skillArray objectAtIndex:i];
        NSLog(@"selectedSkill:%@",selectedSkill);
        
    }
    else {
        
        selectedSkill = [skillArray objectAtIndex:0];
    }
    
    NSLog(@"enemyAttack:%ld",(long)enemyAttack);
    NSLog(@"myHP:%ld",(long)myHP);
    
    [onlineFight AttackToEnemy:enemyAttack EnemyHP:myHP By:@"enemy"];
    
}


#pragma mark - my attack

- (IBAction)AttackButton:(UIButton *)sender {
    
    if (sender.tag == 1) {
        
        myAttack += arc4random()%5+1;
        selectedSkill = self.FirstSkillButton.titleLabel.text;
        
    }
    else if (sender.tag == 2) {
        
        myAttack += arc4random()%7+1;
        selectedSkill = self.SecondSkillButton.titleLabel.text;
        
    }
    else {
        
        selectedSkill = @"普通攻擊";
        
    }
    
    NSLog(@"myAttack:%ld",(long)myAttack);
    NSLog(@"enemyHP:%ld",(long)enemyHP);
    
    self.FirstSkillButton.enabled = NO;
    self.SecondSkillButton.enabled = NO;
    self.CommandATKButton.enabled = NO;
    
    [onlineFight AttackToEnemy:myAttack EnemyHP:enemyHP By:@"me"];
    
}



#pragma mark - onlineFight delegate
- (void)wasKilledBy:(NSString *)name {
    
    if ([name isEqualToString:@"me"]) {
        
        NSLog(@"killed enemy");
        [self.enemyHpProgress setProgress:0.0];
        self.enemyHpLabel.text = @"0";
        
        shake = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(myShakeimage) userInfo:nil repeats:YES];
        
        [self attackSpecially:@"kill" withSkill:selectedSkill By:myName to:enemyName];
        
        [self performSelector:@selector(showEnemyData) withObject:nil afterDelay:1.0];
        //[self showEnemyData];
        
        if (enemyIndex <= 5) {
            
            [self performSelector:@selector(enemyAttack) withObject:nil afterDelay:3.0];
            
        }
        
    }
    else  {
        
        [self.myHpProgress setProgress:0.0];
        self.myHpLabel.text = @"0";
        NSLog(@"was killed");
        
        shake = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(enemyShakeimage) userInfo:nil repeats:YES];
        
        [self attackSpecially:@"kill" withSkill:selectedSkill By:enemyName to:myName];
        
        [self performSelector:@selector(showMyData) withObject:nil afterDelay:1.0];
        //[self showMyData];
        
        
    }
    
}

- (void)wasAttacked:(NSInteger)resultHP By:(NSString *)name {
    
    if ([name isEqualToString:@"me"]) {
        NSLog(@"attack enemy");
        NSLog(@"enemyHP:%ld",(long)resultHP);
        
        enemyHP = resultHP;
        
        [self.enemyHpProgress setProgress:(float)enemyHP/enemyTotalHP ];
        self.enemyHpLabel.text = [NSString stringWithFormat:@"%ld",(long)enemyHP];
        
        [self attackSpecially:@"attack" withSkill:selectedSkill By:myName to:enemyName];
        
        shake = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(myShakeimage) userInfo:nil repeats:YES];
        
        [self performSelector:@selector(enemyAttack) withObject:nil afterDelay:2.0];
    }
    else {
        
        NSLog(@"was attacked");
        NSLog(@"myHP:%ld",(long)resultHP);
        
        myHP = resultHP;
        [self.myHpProgress setProgress:(float)myHP/myTotalHP ];
        self.myHpLabel.text = [NSString stringWithFormat:@"%ld",(long)myHP];
        
        [self attackSpecially:@"attack" withSkill:selectedSkill By:enemyName to:myName];
        
        shake = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(enemyShakeimage) userInfo:nil repeats:YES];
        
        self.FirstSkillButton.enabled = YES;
        self.SecondSkillButton.enabled = YES;
        self.CommandATKButton.enabled = YES;
        
    }
    
}


#pragma mark 攻擊效果
-(void) myShakeimage
{
    if (0 <= frameShake && frameShake < 15) {
        CGRect frame = CGRectMake(myPokeImage.frame.origin.x+15,myPokeImage.frame.origin.y-15,myPokeImage.frame.size.width,myPokeImage.frame.size.height);
        myPokeImage.frame = frame;
        frameShake += 15;
        NSLog(@"aa %d",frameShake);
    }
    else if (15 <= frameShake && frameShake< 30)
    {
        CGRect frame = CGRectMake(myPokeImage.frame.origin.x-15,myPokeImage.frame.origin.y+15,myPokeImage.frame.size.width,myPokeImage.frame.size.height);
        myPokeImage.frame = frame;
        frameShake += 15;
        NSLog(@"a %d",frameShake);
    }
    else if (frameShake >= 30)
    {
        [shake invalidate];
        frameShake = 0;
    }
}

-(void) enemyShakeimage
{
    if (0 <= frameShake && frameShake < 15) {
        CGRect frame = CGRectMake(enemyPoekImage.frame.origin.x-15,enemyPoekImage.frame.origin.y+15, enemyPoekImage.frame.size.width, enemyPoekImage.frame.size.height);
        enemyPoekImage.frame = frame;
        frameShake += 15;
    }
    else if (15 <= frameShake && frameShake < 30)
    {
        CGRect frame = CGRectMake(enemyPoekImage.frame.origin.x+15,enemyPoekImage.frame.origin.y-15, enemyPoekImage.frame.size.width, enemyPoekImage.frame.size.height);
        enemyPoekImage.frame = frame;
        frameShake += 15;
        NSLog(@"b %d",frameShake);
    }
    else if (frameShake >= 30)
    {
        [shake invalidate];
        frameShake = 0;
    }
}

-(void)attackSpecially:(NSString *)status withSkill:(NSString *)skillName By:(NSString *)name to:(NSString *)targetName
{
    if ([status isEqualToString:@"attack"]) {
        attackLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,
                                                               self.view.frame.size.height/3*2+20,
                                                               self.view.frame.size.width-20,
                                                               self.view.frame.size.height/3-10)];
        
        attackLabel.text = [NSString stringWithFormat:@"%@ 使出 %@",name,skillName];
        attackLabel.font = [UIFont boldSystemFontOfSize:20];
        attackLabel.textAlignment = NSTextAlignmentCenter;
        attackLabel.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:attackLabel];
        [self.view bringSubviewToFront:attackLabel];
        [self performSelector:@selector(cancelAttackSpecially) withObject:nil afterDelay:1.0];
    }
    else if ([status isEqualToString:@"kill"]) {
        
        attackLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,
                                                               self.view.frame.size.height/3*2+20,
                                                               self.view.frame.size.width-20,
                                                               self.view.frame.size.height/3-10)];
        
        attackLabel.text = [NSString stringWithFormat:@"%@ 擊殺 %@",name,targetName];
        attackLabel.font = [UIFont boldSystemFontOfSize:20];
        attackLabel.textAlignment = NSTextAlignmentCenter;
        attackLabel.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:attackLabel];
        [self.view bringSubviewToFront:attackLabel];
        [self performSelector:@selector(cancelAttackSpecially) withObject:nil afterDelay:1.0];
    }
    
}


-(void)cancelAttackSpecially {
    
    [attackLabel removeFromSuperview];
    
}



#pragma mark - 設置自己位置
-(void)showPokemonImage{
    
    [myPokeImage removeFromSuperview];
    UIImage *mypoke = [UIImage imageNamed:[[teamArray objectAtIndex:myIndex] objectForKey:@"image"]];
    myPokeImage = [[UIImageView alloc]initWithImage:mypoke];
    myPokeImage.frame = CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height/2, 100, 100);
    [self.view addSubview:myPokeImage];
    
    //timer
    pokeImgMove = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changePokeImage) userInfo:nil repeats:YES];
}


#pragma mark 改變自己位置
-(void)changePokeImage{
    //    changeFrameTime -= 0.1;
    myPokeFrameX += self.view.frame.size.width /15;
    myPokeImage.frame = CGRectMake(self.view.frame.size.width-100-myPokeFrameX, self.view.frame.size.height/2, 100, 100);
    [self.view addSubview:myPokeImage];
    
    if (myPokeFrameX >= self.view.frame.size.width-100) {
        [pokeImgMove invalidate];
        //固定在左右
        myPokeImage.frame = CGRectMake(0, self.view.frame.size.height/2, 100, 100);
        //歸零
        myPokeFrameX = 0;
    }
}


#pragma mark 設置對手位置
-(void)showEnemyPokeImage{
    
    [enemyPoekImage removeFromSuperview];
    UIImage *enemypoke = [UIImage imageNamed:[[EnemyArray objectAtIndex:enemyIndex] objectForKey:@"image"]];
    enemyPoekImage = [[UIImageView alloc]initWithImage:enemypoke];
    enemyPoekImage.frame = CGRectMake(0, 20, 100, 100);
    [self.view addSubview:enemyPoekImage];
    
    //timer
    EnemyPokeImgMove = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeEnemyPokeImage) userInfo:nil repeats:YES];
    
}


#pragma mark 改變對手位置
-(void)changeEnemyPokeImage{
    enemyPokeFrameX += self.view.frame.size.width /15;
    enemyPoekImage.frame = CGRectMake(enemyPokeFrameX, 20, 100, 100);
    [self.view addSubview:enemyPoekImage];
    
    if (enemyPokeFrameX >= self.view.frame.size.width-100) {
        [EnemyPokeImgMove invalidate];
        //固定在左右
        enemyPoekImage.frame = CGRectMake(self.view.frame.size.width-100, 20, 100, 100);
        //歸零
        enemyPokeFrameX = 0;
    }
    
}


#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
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

@end
