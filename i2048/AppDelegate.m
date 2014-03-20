//
//  AppDelegate.m
//  i2048
//
//  Created by xiaoyuan wang on 3/16/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "AppDelegate.h"
#import "GameCenterManager.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialFacebookHandler.h"
#import "UMSocialTwitterHandler.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Put in applicationDidFinishLaunching
    [[GameCenterManager sharedGameCenterManager] authenticateLocalPlayer];
    
    [UMSocialData setAppKey:@"5329271256240b6b3f01b902"];
    [UMSocialConfig setSupportSinaSSO:YES];
    [UMSocialData openLog:YES];
    [UMSocialWechatHandler setWXAppId:@"wxadfab11c23939393" url:nil];
    [UMSocialFacebookHandler setFacebookAppID:@"1487228054831917" shareFacebookWithURL:@"https://itunes.apple.com/us/app/2048-go-go-go/id843568359?ls=1&mt=8"];
    [UMSocialTwitterHandler openTwitter];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
