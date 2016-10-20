//
//  AppDelegate.m
//  AlipayTest
//
//  Created by xiaohaijian on 16/5/11.
//  Copyright © 2016年 xiaohaijian. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ViewController.h"
#import "SuccessViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
    
        //1.创建一个导航控制器
         UINavigationController *nav=[[UINavigationController alloc]init];
        //2.设置导航控制器为window的根视图
         self.window.rootViewController=nav;
   
    
        //3.添加子控制器到导航控制器中
         //创建一些控制器
         ViewController *c1=[[ViewController alloc]init];
         //设置c1这个控制器的视图颜色
         c1.view.backgroundColor=[UIColor whiteColor];
  
   
     //把这些控制器添加到导航控制器中
         [nav pushViewController:c1 animated:YES];

    
         [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = (%@)",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            
            NSDictionary * result = resultDic;
            NSLog(@"result === [%@]",result[@"resultStatus"]);
            if ([result[@"resultStatus"] isEqualToString:@"9000"]) {
                
                
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"订单" message:@"支付成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                
                
                [alertview show];
                
                
            }else{
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"订单" message:@"支付失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                
                
                [alertview show];
            
            
            
            }
            
            
        }];
    }
    return YES;
}





@end
