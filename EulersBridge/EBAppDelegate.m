//
//  EBAppDelegate.m
//  EulersBridge
//
//  Created by Alan Gao on 22/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBAppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation EBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Set Global tint color
    self.window.tintColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1.0];
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"loginView"];

        
    
    // Set tint color
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:179.0/255.0 green:214.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5]];
//    [[UIToolbar appearance] setTintColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
    // Set Top bar background color.
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:47.0/255.0 green:123.0/255.0 blue:212.0/255.0 alpha:1.0]];
//    [[UIToolbar appearance] setBarTintColor:[UIColor colorWithRed:51.0/255.0 green:56.0/255.0 blue:69.0/255.0 alpha:1.0]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
    // Set Nav bar title color and font.
    UIFont *navBarFont = [UIFont fontWithName:@"MuseoSansRounded-500" size:17.0];
    NSDictionary *navBarAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                       NSFontAttributeName: navBarFont};
    
    // Back button font
    UIFont *navBarBackButtonFont = [UIFont fontWithName:@"MuseoSansRounded-300" size:17.0];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSFontAttributeName:navBarBackButtonFont} forState:UIControlStateNormal];
    
    [[UINavigationBar appearance] setTitleTextAttributes:navBarAttributes];
    
    // Status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Segmented control
    UIFont *font = [UIFont fontWithName:@"MuseoSansRounded-500" size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [[UISegmentedControl appearance] setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
    // Tab bar
    UIFont *tabBarFont = [UIFont fontWithName:@"MuseoSansRounded-500" size:10.0];
    NSDictionary *tabBarAttributes = [NSDictionary dictionaryWithObject:tabBarFont
                                                           forKey:NSFontAttributeName];
    [[UITabBarItem appearance] setTitleTextAttributes:tabBarAttributes
                                                   forState:UIControlStateNormal];
    
    // Enable network activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
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

// Custom URL scheme
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}

//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return YES;
//}

@end
