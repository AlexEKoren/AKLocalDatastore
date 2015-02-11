//
//  AppDelegate.m
//  AKLocalDatastore
//
//  Created by Alex Koren on 2/11/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "AppDelegate.h"
#import "AKTableViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"YOUR APPLICATION ID" clientKey:@"YOUR CLIENT KEY"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    AKTableViewController *viewController = [[AKTableViewController alloc]init];
    viewController.view.frame = self.window.frame;
    self.window.rootViewController = viewController;
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
    
    //Check to see if the user has downloaded the data from parse
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasDownloadedRemoteData = [defaults boolForKey:@"hasDownloadedRemoteData"];
    
    //if they haven't go retrieve it and pin them to the local datastore
    if (!hasDownloadedRemoteData) {
        PFQuery *remoteQuery = [PFQuery queryWithClassName:@"YOUR CLASS NAME"];
        [remoteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [PFObject pinAllInBackground:objects block:^(BOOL succeeded, NSError *error) {
                [defaults setBool:NO forKey:@"hasDownloadedRemoteData"];
                [defaults synchronize];
                
                [viewController reloadData];
            }];
        }];
    } else {
        //if they have, just tell the view controller to reload
        [viewController reloadData];
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
