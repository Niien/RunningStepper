//
//  SettingViewController.m
//  runningCounter
//
//  Created by chiawei on 2015/1/25.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "SettingViewController.h"




@interface SettingViewController ()<UITabBarDelegate,UITabBarControllerDelegate>
{
    NSMutableArray *content;
    
    NSString *Acount;
    NSString *Password;
    NSString *height;
    NSString *weight;
    NSString *age;
    
    UIView *myView;
    
}
@property AppDelegate *appDelegate;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    content = [[NSMutableArray alloc]initWithObjects:@"個人資料",@"世界地圖",@"連線對戰",@"藍芽對戰",@"圖鑑", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [content count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [content objectAtIndex:indexPath.row];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:   // 個人資料
            
            [self ToPersonalID];
            
            break;
            
        case 1:  // 世界地圖
            
            [self ToWorldMap];
            
            break;
            
        case 2:  // 連線對戰
            //
            [self OnlineFight];
            break;
            
        case 3:  // 藍芽對戰
            
            [self openRoom];
            break;
            
        case 4:  //圖鑑
            
            [self toIllustratedHandBook];
            
            break;
            
        default:
            break;
    }
    
}



#pragma mark - switch method

- (void)ToPersonalID {
    
    PersonalIDViewController *ID = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalID"];
    
    [self presentViewController:ID animated:YES completion:nil];
    
}


- (void)ToWorldMap {
    
    WorldMapViewController *wmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WorldMap"];
    
    [self presentViewController:wmvc animated:YES completion:nil];
    
}

- (void)OnlineFight {
    
    NSArray *teamArray = [[myPlist shareInstanceWithplistName:@"team"]getDataFromPlist];
    NSLog(@"team:%@",teamArray);
    if ([teamArray count] == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"確認隊伍是否有角色" delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
        [alert show];
        
    }
    else {
        
        OnlineFightViewController *online = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineVC"];
        [self presentViewController:online animated:YES completion:nil];
        
    }
    
}

- (void)openRoom {
    
    NSArray *teamArray = [[myPlist shareInstanceWithplistName:@"team"]getDataFromPlist];
    NSLog(@"team:%@",teamArray);
    if ([teamArray count] == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"確認隊伍是否有角色" delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
        [alert show];
        
    }
    else {
        
        RoomViewController * roomvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Room"];
        [self presentViewController:roomvc animated:YES completion:^{
            //
        }];
        
    }
    
    //    BlueViewController *bvc = [self.storyboard instantiateViewControllerWithIdentifier:@"BlueView"];
    //    [self presentViewController:bvc animated:NO completion:nil];
    
}

- (void)toIllustratedHandBook {
    
    illustratedHandBook *ivc = [self.storyboard instantiateViewControllerWithIdentifier:@"illustratedHandBook"];
    
    [self presentViewController:ivc animated:YES completion:nil];
}



#pragma mark - button
- (IBAction)back:(id)sender {
    
    
    
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
