//
//  SessionHelper.h
//  P2PTest
//
//  Created by KAKEGAWA Atsushi on 2013/10/05.
//  Copyright (c) 2013年 KAKEGAWA Atsushi. All rights reserved.
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


@end

@interface SessionHelper : NSObject

@property (nonatomic, readonly) MCSession *session;
@property (nonatomic, readonly) NSString *serviceType;
@property (nonatomic, readonly) NSUInteger connectedPeersCount;
@property (nonatomic, weak) id <SessionHelperDelegate> delegate;
@property (nonatomic, readonly) MCPeerID *peerID;

- (instancetype)initWithDisplayName:(NSString *)displayName;

- (MCPeerID *)connectedPeerIDAtIndex:(NSUInteger)index;

//- (void)sendImage:(UIImage *)image peerID:(MCPeerID *)peerID;
- (void)sendData:(NSData *)data peerID:(MCPeerID *)peerID;

@end
