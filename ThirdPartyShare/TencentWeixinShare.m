//
//  TencentWeixinShare.m
//  WirelessKunshan
//
//  Created by anxs on 14-9-9.
//  Copyright (c) 2014年 ygcomputer. All rights reserved.
//

#import "TencentWeixinShare.h"
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "ThirdPartyShareKey.h"

@interface TencentWeixinShare() <WXApiDelegate>

@property(atomic) enum WXScene scene;

@end

@implementation TencentWeixinShare

+ (TencentWeixinShare *)sharedInstance
{
    @synchronized(self)
    {
        static TencentWeixinShare *tencentWeixinShare = nil;
        if (tencentWeixinShare == nil)
        {
            tencentWeixinShare = [[self alloc] init];
        }
        return tencentWeixinShare;
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.scene = WXSceneSession;
        //向微信注册
        [WXApi registerApp:kWeixinSDKAppKey withDescription:kWeixinSDKDescription];
    }
    return self;
}

- (BOOL)sharedMessageToTencentWeixin:(NSString *) message
                           imageData:(NSData *) imageData
                         messageType:(enum WXMessageType) messageType
{
    if (messageType == WXSession) {
        self.scene = WXSceneSession;
    }
    else if (messageType == WXTimeline) {
        self.scene = WXSceneTimeline;
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = nil;
    
    WXMediaMessage *mediaMessage = [WXMediaMessage message];
    mediaMessage.title = message;
    mediaMessage.description = message;

    NSInteger maxTryCount = 5;
    while ([imageData length] >= 32 * 1024 && maxTryCount > 0)
    {
        UIImage *tempImage = [UIImage imageWithData:imageData scale:0.5];
        imageData = UIImageJPEGRepresentation(tempImage, 0.5);
        maxTryCount--;
    }
    WXImageObject   *imageObject = [WXImageObject object];
    imageObject.imageData = imageData;
    mediaMessage.mediaObject = imageObject;
    
    req.message = mediaMessage;
    req.bText = NO;
    req.scene = self.scene;
    
    [WXApi sendReq:req];
    return YES;
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
