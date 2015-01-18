//
//  AppDelegate.m
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface AppDelegate (){
    AVAudioPlayer *audioPlayer;
    NSInteger *number;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        NSLog(@"@regf");
        number = 0;
       // [self registerNotifications];
    }
    else
    {
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        // Override point for customization after application launch.
    }
    


    
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
     [self clearNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%@",deviceToken] forKey:@"pushkey"];
    self.pushId = [NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"my fucking push key %@",self.pushId);
    [defaults synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%d",0] forKey:@"pushkey"];
    self.pushId = @"0";
    [defaults synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo {
    NSLog(@"%@", userInfo);
  /*      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:
                        [userInfo objectForKey:@"inAppMessage"] delegate:nil cancelButtonTitle:
                         @"OK" otherButtonTitles:nil, nil];
        [alert show];*/
    
    UIApplicationState state = [application applicationState];
    NSLog(@"User Info : %@", [userInfo description]);
    NSLog(@"User Info Alert Message : %@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    NSString *messageString = [NSString stringWithFormat:@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
    NSString *playSoundOnAlert = [NSString stringWithFormat:@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"sound"]];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],playSoundOnAlert]];
    NSDictionary *obj = [userInfo objectForKey:@"object"];
    NSString *alertType = [NSString stringWithFormat:@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"type"]];
    NSError *error;
    if (state == UIApplicationStateActive)
    {
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
        [self clearNotifications];
        
    }
    else
    {
        number ++;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
     
    }
    
    
//#ifdef __IPHONE_8_0
    [self doLocalNotification:userInfo:application];
//#endif
    
    [self.delegate sendData:obj:alertType:messageString];
    


}




#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString   *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

#endif


-(void)doLocalNotification: (NSDictionary *)userInfo :(UIApplication *)application
{
 

}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    NSLog(@"handleActionWithIdentifier: %@", identifier);
    
    if ([identifier isEqualToString:@"open_action"])
    {
        [[[UIAlertView alloc] initWithTitle:@"Opened!" message:@"This action only open the app... 😀" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    
    if (completionHandler)
    {
        completionHandler();
    }
}



- (void) clearNotifications {
    number = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
