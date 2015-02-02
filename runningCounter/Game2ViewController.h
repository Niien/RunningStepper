//
//  Game2ViewController.h
//  runningCounter
//
//  Created by chiawei on 2015/1/25.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//
#import "myPlist.h"
#import <UIKit/UIKit.h>

@interface Game2ViewController : UIViewController{
    NSMutableArray *NumberArray;        // 存數字字串
    NSMutableArray *showArrowArray;     // 存無法辨識的字串(秀出來的箭頭)
    NSMutableArray *keyinArray;         // 用來跟數字字串比對

}

@end
