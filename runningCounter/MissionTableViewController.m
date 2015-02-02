//
//  MissionTableViewController.m
//  runningCounter
//
//  Created by ChingHua on 2015/1/24.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "MissionTableViewController.h"


@interface MissionTableViewController ()<TimeMissionNotifyDelegate>
{
    MissionTableViewCell *cell;
    
}

@end

@implementation MissionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateNew) name:@"USER_Notify" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeDelete) name:@"Delete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateNew) name:@"DateNow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyDelete) name:@"notifyD" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    _notifyArray = [[UserProfileSingleton shareUserProfile] notifydateArray];
    NSLog(@"%lu",(unsigned long)[_notifyArray count]);
    
    [self.tableView reloadData];
    
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
    return [_notifyArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%d 秒",[[_notifyArray objectAtIndex:indexPath.row]timeCut] ];
    
//    TimeMissionNotify *missionDelegate = [[[UserProfileSingleton shareUserProfile] notifydateArray]objectAtIndex:indexPath.row];
//    missionDelegate.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexTimePath = indexPath;
    Game1ViewController *vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Game1"];
    Game2ViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"Game2"];
    //UIViewController *VC;
    int random = arc4random()%2;//隨機跳遊戲
    switch (random) {
        case 0:
            [self presentViewController:vc1 animated:YES completion:^{
                //
            }];
            break;
        case 1:
            [self presentViewController:vc2 animated:YES completion:^{
                //
            }];
        default:
            break;
    }
//    [self presentViewController:VC animated:YES completion:^{
//        //
//    }];
}

-(void) dateNew
{
//    int timeCut = [[_notifyArray objectAtIndex:_indexTimePath.row] timeCut];
//    cell.timeLabel.text = [NSString stringWithFormat:@"%d 秒",timeCut];
    _notifyArray = [[UserProfileSingleton shareUserProfile] notifydateArray];
    [self.tableView reloadData];
}

-(void) timeDelete
{
//    _notifyArray =  [[UserProfileSingleton shareUserProfile] notifydateArray];
//    [self.tableView reloadData];
    [_notifyArray removeObjectAtIndex:0];
    [[UserProfileSingleton shareUserProfile] setNotifydateArray:_notifyArray];
    [self.tableView reloadData];
}

-(void) notifyDelete
{
    [_notifyArray removeObjectAtIndex:_indexTimePath.row];
    [[UserProfileSingleton shareUserProfile] setNotifydateArray:_notifyArray];
    [self.tableView reloadData];
}

//-(void) CellNowTime
//{
////    cell.timeLabel.text = [NSString stringWithFormat:@"%d 分鐘",[[_notifyArray objectAtIndex:indexTimePath.row]timeCut] ];
//    if ([[_notifyArray objectAtIndexedSubscript:indexTimePath.row] timeCut] == 0) {
//        [_notifyArray removeObjectAtIndex:indexTimePath.row];
//        [self.tableView reloadData];
//    }
//}


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
