//
//  SinaWeiboShare.h
//  WirelessKunshan
//
//  Created by tbago on 14-9-5.
//  Copyright (c) 2014年 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SinaWeiboShare : NSObject

+ (SinaWeiboShare *)sharedInstance;

- (BOOL)sharedMessageToSinaWeibo:(NSString *) message
                       imageData:(NSData *) imageData;
@end
