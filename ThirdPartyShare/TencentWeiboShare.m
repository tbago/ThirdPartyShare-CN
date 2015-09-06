//
//  TencentWeiboShare.m
//  tbago
//
//  Created by tbago on 14-9-9.
//  Copyright (c) 2015 tbago. All rights reserved.
//

#import "TencentWeiboShare.h"
#import "ThirdPartyShareKey.h"
#import "WeiboApi.h"

@interface TencentWeiboShare()<WeiboRequestDelegate>

@property(nonatomic,strong) WeiboApi *weiboApi;

@property(nonatomic) BOOL alreadyAuthorized;

@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) NSData   *imageData;
@end

@implementation TencentWeiboShare

+ (instancetype)sharedInstance {
    static TencentWeiboShare *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.weiboApi = [[WeiboApi alloc] initWithAppKey:kTencentWeiboAppKey andSecret:kTencentWeiboAppSecret andRedirectUri:kTencentWeiboRedirectURI andAuthModeFlag:0 andCachePolicy:0];
        self.alreadyAuthorized = NO;
    }
    return self;
}

- (BOOL)sharedMessageToTencentWeibo:(NSString *) message
                          imageData:(NSData *) imageData
                 rootViewController:(UIViewController *) rootViewController
{
    self.message = message;
    self.imageData = imageData;
    if (!self.alreadyAuthorized)
    {
        [self.weiboApi  cancelAuth];
        [self.weiboApi loginWithDelegate:self andRootController:rootViewController];
    }
    else {
        [self sendWeiboMessage];
    }
    return YES;
}

- (void)sendWeiboMessage
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"json",@"format",
                                   self.message, @"content",
                                   self.imageData, @"pic",
                                   nil];
    [self.weiboApi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
}

#pragma mark WeiboAuthDelegate
/**
 * @brief   重刷授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthRefreshed:(WeiboApiObject *)wbobj
{
    //UISwitch
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r",wbobj.accessToken, wbobj.openid, wbobj.appKey, wbobj.appSecret];
    
    NSLog(@"result = %@",str);
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

/**
 * @brief   重刷授权失败后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthRefreshFail:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        self.responseResultBlock(NO, str);
    });
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthFinished:(WeiboApiObject *)wbobj
{
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r\n openid = %@\r\n appkey=%@ \r\n appsecret=%@ \r\n refreshtoken=%@ ", wbobj.accessToken, wbobj.openid, wbobj.appKey, wbobj.appSecret, wbobj.refreshToken];
    
    NSLog(@"result = %@",str);
    self.alreadyAuthorized = YES;
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendWeiboMessage];
    });
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi   weiboapi 对象，取消授权后，授权信息会被清空
 * @return  无返回
 */
- (void)DidAuthCanceled:(WeiboApi *)wbapi_ {
    self.alreadyAuthorized = NO;
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthFailWithError:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"get token error, errcode = %@",error.userInfo];
    self.alreadyAuthorized = NO;
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        self.responseResultBlock(NO, str);
    });
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
-(void)didCheckAuthValid:(BOOL)bResult suggest:(NSString *)strSuggestion
{
    NSString *str = [[NSString alloc] initWithFormat:@"ret=%d, suggestion = %@", bResult, strSuggestion];
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", str);
    });
}

#pragma mark WeiboRequestDelegate

/**
 * @brief   接口调用成功后的回调
 * @param   INPUT   data    接口返回的数据
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    NSString *strResult = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"result = %@",strResult);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.responseResultBlock(YES, nil);
    });
}

/**
 * @brief   接口调用失败后的回调
 * @param   INPUT   error   接口返回的错误信息
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSString *strResult = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
     NSLog(@"result = %@",strResult);
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        self.responseResultBlock(NO, strResult);
    });
}
@end
