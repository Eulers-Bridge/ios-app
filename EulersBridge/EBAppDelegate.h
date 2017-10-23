//
//  EBAppDelegate.h
//  EulersBridge
//
//  Created by Alan Gao on 22/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetupPushNotificationDelegate <NSObject>
- (void)setupPushNoficationFinishedWithSuccess:(BOOL)success withARN:(NSString *)arn deviceToken:(NSString *)deviceToken;
@end

@interface EBAppDelegate : UIResponder <UIApplicationDelegate>

@property (assign, nonatomic) id<SetupPushNotificationDelegate> pushDelegate;
@property (strong, nonatomic) UIWindow *window;
@property CGSize screenSize;

- (void)instantiateTabBarController;
- (void)setupPushNotificationWithDelegate:(id<SetupPushNotificationDelegate>)delegate;

@end
