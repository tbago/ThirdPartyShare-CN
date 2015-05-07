//
//  TencentWeiboShare.h
//  WirelessKunshan
//
//  Created by anxs on 14-9-9.
//  Copyright (c) 2014年 ygcomputer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TencentWeiboShare : NSObject

+ (TencentWeiboShare *)sharedInstance;

- (BOOL)sharedMessageToTencentWeibo:(NSString *) message
                          imageData:(NSData *) imageData
                 rootViewController:(UIViewController *) rootViewController;

@end
