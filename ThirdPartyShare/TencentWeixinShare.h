//
//  TencentWeixinShare.h
//  tbago
//
//  Created by tbago on 14-9-9.
//  Copyright (c) 2015 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"

enum WXMessageType
{
    WXSession  = 0,        /**< 聊天界面    */
    WXTimeline = 1,        /**< 朋友圈      */
};

typedef void (^ResponseResultBlock)(BOOL result, NSString *errorString);

@interface TencentWeixinShare : NSObject<WXApiDelegate>

+ (instancetype)sharedInstance;

- (BOOL)sharedMessageToTencentWeixin:(NSString *) message
                           imageData:(NSData *) imageData
                         messageType:(enum WXMessageType) messageType;

- (BOOL)isWXAppInstalled;

@property (readwrite, nonatomic, copy) ResponseResultBlock responseResultBlock;
@end
