//
//  EBAppDelegate.m
//  EulersBridge
//
//  Created by Alan Gao on 22/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBAppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "EBContentViewController.h"
#import "AWSCore.h"
#import "AWSS3.h"
#import "AWSSNS.h"

@implementation EBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Setup Amazon s3
    AWSStaticCredentialsProvider *credentialsProvider = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:@"AKIAJNFUHYIZGWPMIZWA" secretKey:@"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"];
    AWSServiceConfiguration *defaultServiceConfiguration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionAPSoutheast2 credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = defaultServiceConfiguration;
    
    
        
    
    // Override point for customization after application launch.
    // Set Global tint color
    self.window.tintColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1.0];
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    
    // Set screen size
    self.screenSize = [UIScreen mainScreen].bounds.size;
        
    
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
    
    // Setup push
//    [self setupPushNotification];
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

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler {
    /* Store the completion handler.*/
    [AWSS3TransferUtility interceptApplication:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
}

// Custom URL scheme
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}

- (void)instantiateTabBarController
{
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"tabBarView"];
    
    EBContentViewController *contentVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    contentVC.contentViewType = EBContentViewTypeProfile;
    contentVC.isSelfProfile = YES;
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBarController.viewControllers[3];
    nav.viewControllers = @[contentVC];
    
    // Tabbar custom image
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    CGFloat inset = 5.0;
    
    tabBarItem1.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0);
    tabBarItem2.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0);
    tabBarItem3.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0);
    tabBarItem4.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0);
    
    tabBarItem1.selectedImage = [UIImage imageNamed:@"Feed Higlighted"];
    tabBarItem2.selectedImage = [UIImage imageNamed:@"Election Higlighted"];
    tabBarItem3.selectedImage = [UIImage imageNamed:@"Poll Higlighted"];
    tabBarItem4.selectedImage = [UIImage imageNamed:@"Profile Higlighted"];
}

//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return YES;
//}

// Push notification

- (void)setupPushNotificationWithDelegate:(id<SetupPushNotificationDelegate>)delegate {
    self.pushDelegate = delegate;
    // Sets up Mobile Push Notification
    UIMutableUserNotificationAction *readAction = [UIMutableUserNotificationAction new];
    readAction.identifier = @"READ_IDENTIFIER";
    readAction.title = @"Read";
    readAction.activationMode = UIUserNotificationActivationModeForeground;
    readAction.destructive = NO;
    readAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *deleteAction = [UIMutableUserNotificationAction new];
    deleteAction.identifier = @"DELETE_IDENTIFIER";
    deleteAction.title = @"Delete";
    deleteAction.activationMode = UIUserNotificationActivationModeForeground;
    deleteAction.destructive = YES;
    deleteAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *ignoreAction = [UIMutableUserNotificationAction new];
    ignoreAction.identifier = @"IGNORE_IDENTIFIER";
    ignoreAction.title = @"Ignore";
    ignoreAction.activationMode = UIUserNotificationActivationModeForeground;
    ignoreAction.destructive = NO;
    ignoreAction.authenticationRequired = NO;
    
    UIMutableUserNotificationCategory *messageCategory = [UIMutableUserNotificationCategory new];
    messageCategory.identifier = @"MESSAGE_CATEGORY";
    [messageCategory setActions:@[readAction, deleteAction] forContext:UIUserNotificationActionContextMinimal];
    [messageCategory setActions:@[readAction, deleteAction, ignoreAction] forContext:UIUserNotificationActionContextDefault];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:[NSSet setWithArray:@[messageCategory]]];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceTokenString: %@", deviceTokenString);
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AWSSNS *sns = [AWSSNS defaultSNS];
    AWSSNSCreatePlatformEndpointInput *request = [AWSSNSCreatePlatformEndpointInput new];
    request.token = deviceTokenString;
    request.platformApplicationArn = SNSPlatformApplicationArn;
    [[sns createPlatformEndpoint:request] continueWithBlock:^id(AWSTask *task) {
        if (task.error != nil) {
            NSLog(@"Error: %@",task.error);
            [self.pushDelegate setupPushNoficationFinishedWithSuccess:NO withARN:@"" deviceToken:@""];
        } else {
            AWSSNSCreateEndpointResponse *createEndPointResponse = task.result;
            NSLog(@"endpointArn: %@",createEndPointResponse);
            [[NSUserDefaults standardUserDefaults] setObject:createEndPointResponse.endpointArn forKey:@"endpointArn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.pushDelegate setupPushNoficationFinishedWithSuccess:YES withARN:createEndPointResponse.endpointArn deviceToken:deviceTokenString];
        }
        
        return nil;
    }];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [self.pushDelegate setupPushNoficationFinishedWithSuccess:NO withARN:@"" deviceToken:@""];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"userInfo: %@",userInfo);
}


@end
