//
//  AppDelegate.m
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 1. 24..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalHeader.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *databaseName = @"bible_kr.db";
    //도큐먼트 디렉토리 위치를  얻는다.
    NSString* documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:databaseName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 도큐먼트에 .sqlite 파일 복사
    BOOL dbexits = [fileManager fileExistsAtPath:filePath];
    if (!dbexits)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:databaseName];
        NSError *error;
        
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:filePath error:&error];
        if (!success) {
            NSAssert1(0,@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    // APNS 등록
    if([defaults stringForKey:TOKEN_KEY].length == 0){
        if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
                if( !error ){
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                }
            }];
        }else{
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }
    
    return YES;
}

#pragma mark -
#pragma mark Push Notification

// 애플리케이션이 푸시서버에 성공적으로 등록되었을때 호출됨
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    NSString *devToken = [[[[deviceToken description]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"device token : %@", devToken);
    [defaults setObject:devToken forKey:TOKEN_KEY];
}

// registerForRemoteNotificationTyles 결과 실패했을 때 호출됨
- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    //NSLog(@"didFailToRegisterForRemoteNotificationsWithError : %@", error);
}

// 어플리케이션이 실행줄일 때 노티피케이션을 받았을떄 호출됨
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userInfo %@", userInfo);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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

@end
