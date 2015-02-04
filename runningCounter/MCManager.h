//
//  MCManager.h
//  runningCounter
//
//  Created by ChingHua on 2015/2/4.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MultipeerConnectivity;

@interface MCManager : NSObject<MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;


-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;

-(void)setupMCBrowser;

-(void)advertiseSelf;

@end
