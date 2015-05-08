//
//  ViewController.m
//  ThirdPartyShareDemo
//
//  Created by anxs on 15/5/7.
//  Copyright (c) 2015年 tbago. All rights reserved.
//

#import "ViewController.h"
#import "QQShare.h"
#import "SinaWeiboShare.h"
#import "TencentWeiboShare.h"
#import "TencentWeixinShare.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

@end
