//
//  AppDelegate.swift
//  SampleSDK23
//
//  Created by David Villacis on 12/21/17.
//  Copyright © 2017 David Villacis. All rights reserved.
//

import UIKit
// Required Import to access LPMesssagingSDKDelegate
import LPMessagingSDK
// Required Import to access Notification
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LPMessagingSDKNotificationDelegate {

  // Window Reference
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Check if iOS 10.0+
    if #available(iOS 10.0, *){
      // Request Authorization for Push Notifications
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
        // Check if Granted Permissions
        if granted {
          // Dispatch Main Queue - in iOS 10.0+ Notifications should be register in Main Queue
          DispatchQueue.main.async {
            // Register for Push
            application.registerForRemoteNotifications()
          }
        } else {
          //
          print("User Authorization Denied")
        }
      })
    } else {
      // Register for Push Notification - UIUserNotificationSettings - Deprecated on iOS 10.0
      application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil))
      // Register for Notifications
      application.registerForRemoteNotifications()
    }
    // Override point for customization after application launch.
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Get Token & Parse it
    let token = deviceToken.map{ String( format : "%02.2hhx",$0)}.joined()
    // Print Token
    print("Token:: \(token)")
    // Register Token on LPMesssagingSDK Instance
    LPMessagingSDK.instance.registerPushNotifications(token: deviceToken, notificationDelegate: self)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // Handle Push LP Notification
    LPMessagingSDK.instance.handlePush(userInfo)
  }
  
  // MARK: - LPMessagingSDKNotificationDelegate Delegate
  
  /// Will handle custom behavior if LP Push Notification was touch
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  func LPMessagingSDKNotification(didReceivePushNotification notification: LPNotification) {
    // TODO : Add custom behavior for User Tapping Push Notification
  }
  
  /// This method will hide/show the In-App Push Notification
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  /// - Returns: true for showing Push Notifications/ false for hidding In-App Push Notification
  func LPMessagingSDKNotification(shouldShowPushNotification notification: LPNotification) -> Bool {
    // Return false if you don't want to show In-App Push Notification
    return true
  }
  
  /// Override SDK - In-App Push Notification
  /// Behavior for tapping In-App Notification should be handle, when using a custom view no behavior is added, LPMessagingSDKNotification(notificationTapped) can't be use
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  /// - Returns: Custom View
  // TODO : Implement this method to Override Native In-App Notification
  // func LPMessagingSDKNotification(customLocalPushNotificationView notification: LPNotification) -> UIView {
    // Return Custom Toast View
    // return UIView()
  // }
  
  /// This method is override when using a Custom View for the Toast Notification (LPMessagingSDKNotification(customLocalPushNotificationView)
  /// Add Custom Behavior to LPMessaging Toast View being Tap
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  func LPMessagingSDKNotification(notificationTapped notification: LPNotification) {
    // TODO : Add custom behavior for User Tapping In-App Notification (Toast)
  }
}

