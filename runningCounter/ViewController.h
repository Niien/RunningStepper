//
//  ViewController.h
//  runningCounter
//
//  Created by Longfatown on 1/20/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;
@import CoreLocation;

@interface ViewController : UIViewController

//====== User Info
@property (strong, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *UserLVLabel;
@property (strong, nonatomic) IBOutlet UILabel *UserPowerLabel;
@property (strong, nonatomic) IBOutlet UILabel *UserAdwardLabel;
@property (strong, nonatomic) IBOutlet UIImageView *UserImageView;

@property (strong,nonatomic) NSString *power;
//====== User Info



@end

