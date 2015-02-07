//
//  RoomViewController.m
//  runningCounter
//
//  Created by ChingHua on 2015/2/7.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "RoomViewController.h"
#import "BlueViewController.h"

@interface RoomViewController ()


@end

@implementation RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sessionHelper = [[SessionHelper alloc] initWithDisplayName:
                          [[UIDevice currentDevice]name]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openBrowser:(id)sender {
    
    MCBrowserViewController *bvc = [[MCBrowserViewController alloc] initWithServiceType:@"Blue" session:self.sessionHelper.session];
    
    //    bvc.maximumNumberOfPeers = 2;
    
    bvc.delegate =self;
    
    [self presentViewController:bvc animated:YES completion:nil];
    
}

- (IBAction)Advertiser:(id)sender {
    
    [self.sessionHelper advertiserAssistantShare];
}


// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self dismissViewControllerAnimated:YES completion:^{
        BlueViewController *bvc = [self.storyboard instantiateViewControllerWithIdentifier:@"BlueView"];
        [self presentViewController:bvc animated:YES completion:^{
            //
        }];
    }];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}


- (void)sessionHelperDidChangeConnectedPeers:(SessionHelper *)sessionHelper {
    
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
