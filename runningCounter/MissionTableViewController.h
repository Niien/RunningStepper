//
//  MissionTableViewController.h
//  runningCounter
//
//  Created by ChingHua on 2015/1/24.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionTableViewCell.h"
#import "UserProfileSingleton.h"
#import "Game1ViewController.h"
#import "Game2ViewController.h"
#import "TimeMissionNotify.h"

@interface MissionTableViewController : UITableViewController

@property NSMutableArray *notifyArray;

@property NSIndexPath *indexTimePath;

@end
