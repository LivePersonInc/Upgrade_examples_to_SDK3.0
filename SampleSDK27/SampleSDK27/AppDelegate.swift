//
//  AppDelegate.swift
//  SampleSDK27
//
//  Created by David Villacis on 12/6/17.
//  Copyright © 2017 David Villacis. All rights reserved.
//

import UIKit
// Required LivePerson Import
import LPMessagingSDK
// Required Notification Import
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,LPMessagingSDKNotificationDelegate {
  
  // MARK: - Properties
  
  // Window Reference
  var window: UIWindow?
  // Check if is Window Mode
  public let IS_WINDOW_MODE : Bool = false
  
  // MARK: - App LifeCycle
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Check if iOS 10.0+
    if #available(iOS 10.0, *) {
      // Register for Push Remote Notifications
      UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound], completionHandler: { (granted, error) in
        // Check if Granted Permissions
        if granted {
          // Dispatch Async Queue
          DispatchQueue.main.async {
            // Register for Push
            application.registerForRemoteNotifications()
          }
        }
      })
    } else {
      // Register for Push Notification - Deprecated on iOS 10.0
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
  
  /// Will override supported Interfaces depending on the Device
  ///
  /// - Parameters:
  ///   - application: Application Instance
  ///   - window: Window Reference
  /// - Returns: Supported Interfaces
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    // Supported Orientations
    var orientations : UIInterfaceOrientationMask
    // Check Type of Device
    if UIView.Device.IS_IPAD {
      // Override Orientation for iPad
      orientations = [.landscape]
    } else {
      // Override Orientation for iPhone
      orientations = [.portrait, .portraitUpsideDown]
    }
    // Return Supported Orientations
    return orientations
  }
  
  // MARK: - Notification Delegate
  
  /// App Did Register for Push Notifications
  ///
  /// - Parameters:
  ///   - application: Application Instance
  ///   - deviceToken: Device Token for Push Notifications
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Get Token & Parse it
    let token = deviceToken.map{ String( format : "%02.2hhx",$0)}.joined()
    // Print Token
    print("Token:: \(token)")
    // Register Token on LPMesssaging Instance
    LPMessagingSDK.instance.registerPushNotifications(token: deviceToken, notificationDelegate: self)
  }
  
  
  /// App did Receive Remote Notification
  ///
  /// - Parameters:
  ///   - application: Application Instance
  ///   - userInfo: Notification Information
  ///   - completionHandler: Completition Handler
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // Handle Push Notification
    LPMessagingSDK.instance.handlePush(userInfo)
  }
  
  // MARK: - LPMessagingSDKNotificationDelegate Delegate
  
  /// Will handle custom behavior if received LP Push Notification
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  func LPMessagingSDKNotification(didReceivePushNotification notification: LPNotification) {
    // Will only Push to Messaging Screen if App is on the Background or Inactive
    if UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive {
      // Reset Badge
      UIApplication.shared.applicationIconBadgeNumber = 0
      // Show ConversationViewController
      self.showMessaging()
    }
  }

  /// This method will hide/show the In-App Push Notification
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  /// - Returns: true for showing Push Notifications/ false for hidding In-App Push Notification
  func LPMessagingSDKNotification(shouldShowPushNotification notification: LPNotification) -> Bool {
    // Return false if you don't want to show Push Notification
    return false
  }
  
  
  /// Override SDK - In-App Push Notification
  /// Behavior for tapping In-App Notification should be handle, when using a custom view no behavior is added, LPMessagingSDKNotification(notificationTapped) can't be use
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  /// - Returns: Custom View
  func LPMessagingSDKNotification(customLocalPushNotificationView notification: LPNotification) -> UIView {
    // Get View
    let toast = Toast().getView(message: notification.text)
    // Add Touch capabilities to Toast Notification
    self.enableTouch(view: toast)
    // Return new View
    return toast
  }
  
  /// This method is override when using a Custom View for the Toast Notification (LPMessagingSDKNotification(customLocalPushNotificationView)
  /// Add Custom Behavior to LPMessaging Toast View being Tap
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  func LPMessagingSDKNotification(notificationTapped notification: LPNotification) {
    // Show ConversationViewController
    self.showMessaging()
   }
  
  /// Will enable Gesture Recognizer on UIView
  /// Creates interaction with Toast Notification
  ///
  /// - Parameter view: View
  private func enableTouch(view : UIView) {
    // Create Gesture Recognizer
    let gesture = UITapGestureRecognizer()
    // Add Number of Taps Need to trigger Action
    gesture.numberOfTapsRequired = 2
    // Add Action to Gesture
    gesture.addTarget(self, action: #selector(toastTapped(_:)))
    // Add Gesture to UIView
    view.addGestureRecognizer(gesture)
  }
  
  /// Will repond to User Tapping on Toast Notification
  /// Removes Toast Notification from the Screen and Shows ConversationViewController
  ///
  /// - Parameter gesture: gesture
  @objc func toastTapped(_ gesture : UITapGestureRecognizer){
    // Get Toast View
    if let toast = self.window?.viewWithTag(66666) {
      // Remove toast when tapped
      toast.removeFromSuperview()
    }
    // Show ConversationViewController
    self.showMessaging()
  }
  
  /// Will show Messaging View Controller
  private func showMessaging(){
    // Storyboard Reference
    var storyboard : UIStoryboard?
    // Check if Device is iPad needs to use Presentation Popover Controller
    if UIView.Device.IS_IPAD {
      // Get Storyboard
      storyboard = UIStoryboard(name: "iPad", bundle: nil)
    } else {
      // Get Storyboard
      storyboard = UIStoryboard(name: "Main", bundle: nil)
    }
    // Check if Window Mode is ON
    if IS_WINDOW_MODE {
      // Get Main View Controller
      let mainViewController = storyboard!.instantiateViewController(withIdentifier:"MainViewController") as? ViewController
      // Change Push Flag
      mainViewController?.COMES_FROM_PUSH = true
      // Change Window Mode Flag
      mainViewController?.IS_WINDOW_MODE = IS_WINDOW_MODE
      // Get Navigation Controller
      let navigationController = self.window?.rootViewController as! UINavigationController
      // Push MessagingView to Navigation Controller
      navigationController.show(mainViewController!, sender: nil)
    } else {
      // Get Main View Controller
      let conversationViewController = storyboard!.instantiateViewController(withIdentifier:"ConversationViewController") as? ConversationViewController
      // Get Navigation Controller
      let navigationController = self.window?.rootViewController as! UINavigationController
      // Push MessagingView to Navigation Controller
      navigationController.pushViewController(conversationViewController!, animated: true)
    }
  }
}

