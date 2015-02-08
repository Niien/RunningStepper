//
//  BlueViewController.m
//  runningCounter
//
//  Created by ChingHua on 2015/2/4.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MultipeerConnectivity;

@class SessionHelper;

@protocol SessionHelperDelegate <NSObject>

@required
- (void)sessionHelperDidChangeConnectedPeers:(SessionHelper *)sessionHelper;
- (void)sessionHelperDidRecieveArray:(NSArray *)Array peer:(MCPeerID *)peerID;
//- (void)sessionHelperDidRecieveImage:(UIImage *)image peer:(MCPeerID *)peerID;
- (void)sessionHelperDidSendData:(NSData *)data;
-(void)sessionHelperDIdChangeConnecting:(SessionHelper*)sessionHelper;
-(void)sessionHelperDIdChangeNoConnected:(SessionHelper*)sessionHelper;



@end

@interface SessionHelper : NSObject

@property (nonatomic, readonly) MCSession *session;
@property (nonatomic, readonly) NSString *serviceType;
@property (nonatomic, readonly) NSUInteger connectedPeersCount;
@property (nonatomic, weak) id <SessionHelperDelegate> delegate;
@property (nonatomic, readonly) MCPeerID *peerID;

+(SessionHelper*)shareInstance;

- (instancetype)initWithDisplayName:(NSString *)displayName;

-(void) advertiserAssistantShare;

- (MCPeerID *)connectedPeerIDAtIndex:(NSUInteger)index;

//- (void)sendImage:(UIImage *)image peerID:(MCPeerID *)peerID;
- (void)sendData:(NSData *)data peerID:(MCPeerID *)peerID;

- (void)deallocAdverAndSessionStop;
@end
