//
//  TencentWeiboShare.h
//  tbago
//
//  Created by tbago on 14-9-9.
//  Copyright (c) 2014年 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TencentWeiboShare : NSObject

+ (TencentWeiboShare *)sharedInstance;

- (BOOL)sharedMessageToTencentWeibo:(NSString *) message
                          imageData:(NSData *) imageData
                 rootViewController:(UIViewController *) rootViewController;

@end
