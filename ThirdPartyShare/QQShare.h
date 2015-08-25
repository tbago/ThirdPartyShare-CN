//
//  QQZoneShare.h
//  tbago
//
//  Created by tbago on 14-9-9.
//  Copyright (c) 2015 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>

enum QQShareType
{
    QQShareMessage  = 0,         /**< 聊天界面    */
    QQShareZone = 1,             /**< QQ空间      */
};

@interface QQShare : NSObject

+ (instancetype)sharedInstance;

- (BOOL)sharedMessageToQQ:(NSString *) message
                detailUrl:(NSString *) detailUrl
                imageData:(NSData *) imageData
                shareType:(enum QQShareType) sharedType;

- (BOOL)isQQInstalled;
@end
