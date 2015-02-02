//
//  StoreViewController.m
//  runningCounter
//
//  Created by chiawei on 2015/1/26.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "StoreViewController.h"

@interface StoreViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *retailArray;
    NSMutableArray *costArray;
    
    NSInteger cost;
    NSInteger gain;
}

@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // get total power
    
    retailArray = [NSMutableArray new];
    costArray = [NSMutableArray new];
    
    for (int i = 0; i < 5 ; i++) {
        
        [retailArray addObject:[NSString stringWithFormat:@"購買%d能量",(i+1)*200]];
        [costArray addObject:[NSString stringWithFormat:@"需消耗%d步數",(i+1)*600]];
        
    }
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //NSLog(@"step:%ld",(long)[StepCounter shareStepCounter].power);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// hide status bar
- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [retailArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    storeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell addLabelwithtext:[retailArray objectAtIndex:indexPath.row] subTitle:[costArray objectAtIndex:indexPath.row]];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 180;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cost = (indexPath.row+1)*600;
    gain = (indexPath.row+1)*200;

    if ([StepCounter shareStepCounter].stepNB > cost ) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"購買" message:@"確定購買嗎？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
        
        [alert show];

    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"不夠喔" message:@"去多走幾步再來吧" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
        
        [alert show];

    }
    
}


#pragma mark - alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"button:%ld",(long)buttonIndex);
    
    if (buttonIndex == 1) {
        
        [StepCounter shareStepCounter].stepNB -= cost;
        
        [StepCounter shareStepCounter].power += gain;
    }
}


#pragma mark - button
- (IBAction)backButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
