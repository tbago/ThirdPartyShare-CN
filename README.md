# ThirdPartyShare
国内三方分享ios代码实现，支持QQ，QQ空间，新浪微博，腾讯微博，腾讯微信分享。采用最新的三方sdk。
详细使用说明参照：[三方分享指南](http://www.tbago.com/ios/thirdpartshareguide/)
### 说明：
demo工程采用xcode 6.2编译，采用size class和auto layout做代码实现，使用object c作为代码实现。

### 参考调用方法如下：
```objective-c
- (IBAction)sharedButtonClick:(id)sender
{
    NSString *sharedContent = @"这里设置分享的内容";
 
///<以屏幕截图作为分享的图片
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    NSData * imageData = UIImageJPEGRepresentation(screenshot, 1.0);
 
    switch ([sender tag])
    {
        case 0: //<qq消息
        {
            QQShare *qqShare = [QQShare sharedInstance];
            [qqShare sharedMessageToQQ:sharedContent detailUrl:[self getOfficialWebsite] imageData:imageData shareType:QQMessage];
            break;
        }
        case 1: //<qq空间
        {
            QQShare *qqShare = [QQShare sharedInstance];
            [qqShare sharedMessageToQQ:sharedContent detailUrl:[self getOfficialWebsite] imageData:imageData shareType:QQZone];
            break;
        }
        case 2:  //<腾讯微博
        {
            TencentWeiboShare *tencentWeiboShare = [TencentWeiboShare sharedInstance];
            [tencentWeiboShare sharedMessageToTencentWeibo:sharedContent
                                                 imageData:imageData
                                        rootViewController:self.navigationController];
            break;
        }
        case 3:  //<腾讯微信
        {
            TencentWeixinShare *tencentWeixinShare = [TencentWeixinShare sharedInstance];
            [tencentWeixinShare sharedMessageToTencentWeixin:sharedContent imageData:imageData messageType:WXSession];
            break;
        }
        case 4: //<新浪微博
        {
            SinaWeiboShare *sinaWeiboShare = [SinaWeiboShare sharedInstance];
            [sinaWeiboShare sharedMessageToSinaWeibo:sharedContent
                                           imageData:imageData];
            break;
        }
    }
}
-(NSString *)getOfficialWebsite
{
    return @"http://www.tbago.com/";
}
```
## 返回结果：
### 腾讯微信：
1、需要在AppDelegate.m中实现如下方法：
```objective-c
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [WXApi handleOpenURL:url delegate:[TencentWeixinShare sharedInstance]];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:[TencentWeixinShare sharedInstance]];
    return YES;
}
```
返回结果通过block的方式返回,例如：
```objective-c
    [[TencentWeiboShare sharedInstance] setResponseResultBlock:^(BOOL result, NSString *errorString) {
        if (result) {
            NSLog(@"Share image to WeChat success.");
        }
        else {
            NSLog(errorString);
        }
    }];
```

