//
//  AppDelegate.swift
//  SeniorProject
//
//  Created by Michael Kytka on 1/25/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard : UIStoryboard?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        PFOrder.registerSubclass()
        PFOrderedItems.registerSubclass()
        PFDriverAvailability.registerSubclass()
        PFUnavailableRestaurant.registerSubclass()
        PFFood.registerSubclass()
        PFDestination.registerSubclass()
        
        Parse.setApplicationId("j28gc7OUqKZFc47nvyoRDPnZnaCRqh3mV8RiULMK", clientKey: "Il9Xid8E9BI7G6pkwUUQLKSO0kL9FKtwNtlSL1O3")
        // Override point for customization after application launch.
        self.storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle());
        if let currentUser = PFUser.currentUser() {
            let deleted = currentUser.valueForKey("deleted") as! Bool
            if currentUser.objectId != nil && !deleted {
                self.window?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController");
            } else {
                self.window?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LogInViewController");
            }
        } else {
            self.window?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LogInViewController");
        }
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
            let oldPushHandlerOnly = !self.respondsToSelector(#selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        clearBadges()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //Push notifications
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    
    
    func clearBadges() {
        let installation = PFInstallation.currentInstallation()
        installation.badge = 0
        installation.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            }
            else {
                print("Failed to clear badges")
                PFUser.logOut()
            }
        }
    }


}

