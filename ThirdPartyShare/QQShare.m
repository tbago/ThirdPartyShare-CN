//
//  QQZoneShare.m
//  tbago
//
//  Created by anxs on 14-9-9.
//  Copyright (c) 2014年 tbago. All rights reserved.
//

#import "QQShare.h"
#import "ThirdPartyShareKey.h"

#import "TencentOpenAPI/QQApi.h"
#import "TencentOpenAPI/QQApiInterfaceObject.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"

@interface QQShare()<TencentSessionDelegate>

@property(nonatomic,strong) NSString *title;
@property(strong,nonatomic) TencentOAuth    *tencentOAuth;
@end

@implementation QQShare

+ (QQShare *)sharedInstance
{
    @synchronized(self)
    {
        static QQShare *qqZoneShare = nil;
        if (qqZoneShare == nil)
        {
            qqZoneShare = [[self alloc] init];
        }
        return qqZoneShare;
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (BOOL)sharedMessageToQQ:(NSString *) message
                detailUrl:(NSString *) detailUrl
                imageData:(NSData *) imageData
                shareType:(enum QQShareType) sharedType
{
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kTencentAppKey
                                                andDelegate:self];
    
    NSString *title = message;
    NSString *description = message;
    QQApiNewsObject *object = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:detailUrl]
                                title:title
                                description:description
                                previewImageData:imageData];
//    QQApiURLObject *object = [[QQApiURLObject alloc] initWithURL:[NSURL URLWithString:detailUrl]
//                                                           title:title
//                                                     description:description
//                                                previewImageData:imageData
//                                               targetContentType:QQApiURLTargetTypeNotSpecified];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
    
    QQApiSendResultCode sent;
    if (sharedType == QQMessage)
    {
        //将内容分享到qq
        sent = [QQApiInterface sendReq:req];
    }
    else {
        //将内容分享到qzone
        sent = [QQApiInterface SendReqToQZone:req];
    }
    if (sent == EQQAPISENDSUCESS) {
        return YES;
    }
    else {
        return NO;
    }
    return NO;
}

#pragma mark TencentLoginDelegate
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
    }
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {

    }
}

-(void)tencentDidNotNetWork
{
    
}
@end
