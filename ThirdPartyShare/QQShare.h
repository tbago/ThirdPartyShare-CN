//
//  QQZoneShare.h
//  WirelessKunshan
//
//  Created by anxs on 14-9-9.
//  Copyright (c) 2014年 ygcomputer. All rights reserved.
//

#import <Foundation/Foundation.h>

enum QQShareType
{
    QQMessage  = 0,         /**< 聊天界面    */
    QQZone = 1,             /**< QQ空间      */
};

@interface QQShare : NSObject

+ (QQShare *)sharedInstance;

- (BOOL)sharedMessageToQQ:(NSString *) message
                detailUrl:(NSString *) detailUrl
                imageData:(NSData *) imageData
                shareType:(enum QQShareType) sharedType;

@end
