//
//  RoomViewController.h
//  runningCounter
//
//  Created by ChingHua on 2015/2/7.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionHelper.h"

@interface RoomViewController : UIViewController<MCBrowserViewControllerDelegate,MCAdvertiserAssistantDelegate,SessionHelperDelegate>

@property SessionHelper *sessionHelper;


@end
