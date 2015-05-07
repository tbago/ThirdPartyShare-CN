//
//  TencentWeixinShare.h
//  tbago
//
//  Created by tbago on 14-9-9.
//  Copyright (c) 2015年 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>

enum WXMessageType
{
    WXSession  = 0,        /**< 聊天界面    */
    WXTimeline = 1,        /**< 朋友圈      */
};

@interface TencentWeixinShare : NSObject

+ (TencentWeixinShare *)sharedInstance;

- (BOOL)sharedMessageToTencentWeixin:(NSString *) message
                           imageData:(NSData *) imageData
                         messageType:(enum WXMessageType) messageType;

@end
