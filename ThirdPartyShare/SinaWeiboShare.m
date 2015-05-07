//
//  SinaWeiboShare.m
//  Tbago
//
//  Created by tbago on 14-9-5.
//  Copyright (c) 2014年 tbago. All rights reserved.
//

#import "SinaWeiboShare.h"
#import "ThirdPartyShareKey.h"
#import "WeiboSDK.h"

@implementation SinaWeiboShare

+ (SinaWeiboShare *)sharedInstance
{
    @synchronized(self)
    {
        static SinaWeiboShare *sinaWeiboShare = nil;
        if (sinaWeiboShare == nil)
        {
            sinaWeiboShare = [[self alloc] init];
        }
        return sinaWeiboShare;
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [WeiboSDK enableDebugMode:YES];
        [WeiboSDK registerApp:kWeiboAppKey];
    }
    return self;
}

- (BOOL)sharedMessageToSinaWeibo:(NSString *) message
                     imageData:(NSData *) imageData
{
    WBMessageObject *wbMessageObject = [WBMessageObject message];
    if (wbMessageObject != nil)
    {
        wbMessageObject.text = message;
    }
    
    if ([imageData length] > 0)
    {
        WBImageObject *image = [WBImageObject object];
        image.imageData = imageData;
        wbMessageObject.imageObject = image;
    }
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:wbMessageObject];
    request.userInfo = @{@"ShareMessageFrom": @"SinaWeiboShare"};
    
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = YES;
    [WeiboSDK sendRequest:request];
    return YES;
}
@end
