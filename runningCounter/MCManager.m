//
//  MCManager.m
//  runningCounter
//
//  Created by ChingHua on 2015/2/4.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "MCManager.h"

@implementation MCManager
{
    BOOL first;
}

-(id)init{
    
    self =[super init];
    
    if (self) {
        
        _peerID = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
        
    }
    
    return self;
}

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName
{
    _peerID = [[MCPeerID alloc]initWithDisplayName:displayName]; //初始化對象displayName 設備名這個名字會出現在對等的實體上面
    
    _session = [[MCSession alloc]initWithPeer:_peerID];//初始化Ses​​sion對象所有的一切都是基於這個對象，初始化提供peerID
    _session.delegate=self;
    
}

-(void)setupMCBrowser
{
    //默認的初始化，蘋果預製的視圖控制器，顯示一個瀏覽器搜索其他對等實體。在初始化上它接受2個參數，serviceType定義瀏覽器應該尋找的類型的服務,通過一個小的文本描述。為了瀏覽器能夠發現廣播者，這個小文本應該是相同的。關於它的名字有兩個規則:1、必須是1 - 15字符。 2、只能包含ASCII小寫字母,數字和連字符。第二個參數是先前初始化的session 對象
    _browser = [[MCBrowserViewController alloc]initWithServiceType:@"chat-files" session:_session];
}

//用這個方法切換設備的廣播狀態,參數定義設備是否應該廣播自己,取決於我們的應用程序的設置。我們添加了一個UISwitch對象設置我們是否對其他設備可見。
-(void)advertiseSelf
{
    
    //serviceType文本要與瀏覽器的相匹配
    _advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:@"chat-files" discoveryInfo:nil session:_session];
    [_advertiser start];
}



#pragma mark - MCSessionDelegate
//節點改變狀態的時候調用
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    //當新的連接發生時，它會被調用，我們的工作就是用它處理所提供的信息
    NSDictionary *dic = @{@"peerID":peerID, @"state":[NSNumber numberWithInt:state]};
    
    //通過通知中心將節點以及跟節點連接的狀態信息發送到->ConnectionsViewController
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification" object:nil userInfo:dic];
    
}
//有新的數據傳輸過來的時候調用
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    //將接收到的數據發送到FirstViewController
    NSDictionary *dic = @{@"data": data , @"peerID":peerID};
    if (first != YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                            object:nil
                                                          userInfo:dic];
        first = YES;
    }
    else
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCAttack" object:nil userInfo:dic];
}
//收到資源時被調用
-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}
//收到結束時被調用
-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

@end