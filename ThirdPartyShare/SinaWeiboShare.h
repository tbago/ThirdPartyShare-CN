//
//  SinaWeiboShare.h
//  Tbago
//
//  Created by tbago on 14-9-5.
//  Copyright (c) 2015 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SinaWeiboShare : NSObject

+ (instancetype)sharedInstance;

- (BOOL)sharedMessageToSinaWeibo:(NSString *) message
                       imageData:(NSData *) imageData;

- (BOOL)isWeiboAppInstalled;
@end
