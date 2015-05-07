//
//  SinaWeiboShare.h
//  WirelessKunshan
//
//  Created by anxs on 14-9-5.
//  Copyright (c) 2014年 ygcomputer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SinaWeiboShare : NSObject

+ (SinaWeiboShare *)sharedInstance;

- (BOOL)sharedMessageToSinaWeibo:(NSString *) message
                       imageData:(NSData *) imageData;
@end
