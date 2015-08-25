//
//  SinaWeiboShare.m
//  Tbago
//
//  Created by tbago on 14-9-5.
//  Copyright (c) 2015 tbago. All rights reserved.
//

#import "SinaWeiboShare.h"
#import "ThirdPartyShareKey.h"
#import "WeiboSDK.h"

@implementation SinaWeiboShare

#pragma mark - init
+ (instancetype)sharedInstance
{
    static SinaWeiboShare *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
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

#pragma mark - public method
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
    
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    return [WeiboSDK sendRequest:request];
}

- (BOOL)isWeiboAppInstalled {
    return [WeiboSDK isWeiboAppInstalled];
}
@end
