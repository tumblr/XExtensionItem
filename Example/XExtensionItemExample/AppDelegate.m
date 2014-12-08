//
//  AppDelegate.m
//  XExtensionItemExample
//
//  Created by Bryan Irace on 12/8/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:
                                      [[ViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
