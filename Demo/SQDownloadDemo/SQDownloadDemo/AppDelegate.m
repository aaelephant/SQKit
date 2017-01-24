//
//  AppDelegate.m
//  SQDownloadDemo
//
//  Created by qbshen on 2017/1/19.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import "AppDelegate.h"
#import "SQMultiDownloadController.h"

@interface AppDelegate ()
@property (strong, nonatomic) UILocalNotification *localNotification;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerLocalNotfiForDownload:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

-(void)registerLocalNotfiForDownload:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SQMultiDownloadController sharedInstance];
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        self.localNotification.repeatInterval = 0;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        self.localNotification.repeatInterval = 0;
    }
    
    UILocalNotification *localNotification = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        [self application:application didReceiveLocalNotification:localNotification];
    }

}

#pragma mark - Local Notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下载通知"
                                                    message:notification.alertBody
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
    // 图标上的数字减1
    application.applicationIconBadgeNumber -= 1;
}



- (void)initLocalNotification {
    self.localNotification = [[UILocalNotification alloc] init];
    self.localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
    self.localNotification.alertAction = nil;
    self.localNotification.soundName = UILocalNotificationDefaultSoundName;
    self.localNotification.alertBody = @"下载完成了！";
    self.localNotification.applicationIconBadgeNumber = 1;
    self.localNotification.repeatInterval = 0;
}

- (void)sendLocalNotification {
    [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // 图标上的数字减1
    application.applicationIconBadgeNumber -= 1;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}


-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    completionHandler();
//    [[SQMultiDownloadController sharedInstance] setBackCompletionHandler:completionHandler];
}

//- (void)application:(UIApplication *)application
//handleEventsForBackgroundURLSession:(NSString *)identifier
//  completionHandler:(void (^)())completionHandler {
//    NSURLSession *backgroundSession = [self backgroundURLSession];
//    NSLog(@"Rejoining session with identifier %@ %@", identifier, backgroundSession);
//    // 保存 completion handler 以在处理 session 事件后更新 UI
//    [self addCompletionHandler:completionHandler forSession:identifier];
//}
//- (void)addCompletionHandler:(CompletionHandlerType)handler
//                  forSession:(NSString *)identifier {
//    if ([self.completionHandlerDictionary objectForKey:identifier]) {
//        NSLog(@"Error: Got multiple handlers for a single session identifier.  This should not happen.\n");
//    }
//    [self.completionHandlerDictionary setObject:handler forKey:identifier];
//}
@end
