//
//  TencentWeiboShare.h
//  tbago
//
//  Created by tbago on 14-9-9.
//  Copyright (c) 2015 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ResponseResultBlock)(BOOL result, NSString *errorString);

@interface TencentWeiboShare : NSObject

+ (instancetype)sharedInstance;

- (BOOL)sharedMessageToTencentWeibo:(NSString *) message
                          imageData:(NSData *) imageData
                 rootViewController:(UIViewController *) rootViewController;

@property (readwrite, nonatomic, copy) ResponseResultBlock responseResultBlock;
@end
