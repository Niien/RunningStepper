//
//  BlueViewController.h
//  runningCounter
//
//  Created by ChingHua on 2015/2/4.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionHelper.h"

@interface BlueViewController : UIViewController<SessionHelperDelegate,UIAlertViewDelegate>

@property BOOL enemyall;

@end
