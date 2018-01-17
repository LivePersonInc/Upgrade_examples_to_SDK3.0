//
//  ViewController.swift
//  SampleSDK28
//
//  Created by David Villacis on 1/9/18.
//  Copyright © 2018 David Villacis. All rights reserved.
//

import UIKit
// Required LP Imports
import LPMessagingSDK
import LPAMS
import LPInfra

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var chatButton: UIButton!
  // Window Mode Flag
  private let isWindowMode : Bool = false
  // App is been open because of Push Notification
  public var comesFromPush : Bool = false
  
  // MARK: - App LifeCycle
  
  /// App LifeCycle - View did Load
  override func viewDidLoad() {
    // Super Init
    super.viewDidLoad()
    // Reset Button Corners
    self.chatButton.layer.cornerRadius = 7.0
    // Clip Bounds
    self.chatButton.clipsToBounds = true
    // Check if Segue Comes from Push
    if self.comesFromPush {
      // Show Messaging Screen
      self.showMessaging()
    }
  }
  
  /// App LifeCycle - Receive Memory Warning
  override func didReceiveMemoryWarning() {
    // Super Init
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - IBActions
  
  /// Will respond to Chat Button Pressed
  ///
  /// - Parameter sender: Chat Button
  @IBAction func chatButtonPressed(_ sender: UIButton) {
    // Show Messaging Screen
    self.showMessaging()
  }
  
  /// Will show Messaging Screen
  public func showMessaging(){
    // Check if Window Mode
    if self.isWindowMode {
      // Init LivePerson Singleton
      LivePersonSDK.shared.initSDK()
      // Init SDK Logger
      LivePersonSDK.shared.initLogger()
      // Set Delegate
      LivePersonSDK.shared.delegate = self
      // Customize ConversationView
      LivePersonSDK.shared.customizeMessagingScreen()
      // Presend Messaging Window
      LivePersonSDK.shared.showConversation()
    } else {
      // Reference ConversationViewController
      let conversationViewController = storyboard?.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
      //  Show ConversationViewController
      self.navigationController?.pushViewController(conversationViewController!, animated: true)
    }
  }
}
extension ViewController : LPMessagingSDKdelegate {
  
  // INFO: When using Window Mode the Class calling the SDK to Present the MessagingScreen needs to Implement the SDK Delegates
  // In the case of using a Custom ViewController, that controller is the one Delegating the SDK
  
  //MARK:- Required - LPMessagingSDKDelegate
  
  /**
   This delegate method is required.
   It is called when authentication process fails
   */
  func LPMessagingSDKAuthenticationFailed(_ error: NSError) {
    NSLog("Error: \(error)");
  }
  
  /**
   This delegate method is required.
   It is called when the SDK version you're using is obselete and needs an update.
   */
  func LPMessagingSDKObseleteVersion(_ error: NSError) {
    NSLog("Error: \(error)");
  }
  
  /**
   This delegate method is required.
   It is called when the token which used for authentication is expired
   */
  func LPMessagingSDKTokenExpired(_ brandID: String) {
    
  }
  
  /**
   This delegate method is required.
   It lets you know if there is an error with the sdk and what this error is
   */
  func LPMessagingSDKError(_ error: NSError) {
    
  }
  
  //MARK:- Optionals - LPMessagingSDKDelegate
  
  /**
   This delegate method is optional.
   It is called each time the SDK receives info about the agent on the other side.
   
   Example:
   You can use this data to show the agent details on your navigation bar (in view controller mode)
   */
  func LPMessagingSDKAgentDetails(_ agent: LPUser?) {
  }
  
  /**
   This delegate method is optional.
   It is called each time the SDK menu is opened/closed.
   */
  func LPMessagingSDKActionsMenuToggled(_ toggled: Bool) {
    
  }
  
  /**
   This delegate method is optional.
   It is called each time the agent typing state changes.
   */
  func LPMessagingSDKAgentIsTypingStateChanged(_ isTyping: Bool) {
    
  }
  
  /**
   This delegate method is optional.
   It is called after the customer satisfaction page is submitted with a score.
   */
  func LPMessagingSDKCSATScoreSubmissionDidFinish(_ accountID: String, rating: Int) {
    
  }
  
  /**
   This delegate method is optional.
   If you set a custom button, this method will be called when the custom button is clicked.
   */
  func LPMessagingSDKCustomButtonTapped() {
    
  }
  
  /**
   This delegate method is optional.
   It is called whenever an event log is received.
   */
  func LPMessagingSDKDidReceiveEventLog(_ eventLog: String) {
    // Log - Event
    print("EventLog:: \(eventLog)")
  }
  
  /**
   This delegate method is optional.
   It is called when the SDK has connections issues.
   */
  func LPMessagingSDKHasConnectionError(_ error: String?) {
    
  }
  
  /**
   This delegate method is optional.
   It is called when the conversation view controller removed from its container view controller or window.
   */
  func LPMessagingSDKConversationViewControllerDidDismiss() {
    // Pop to Parent Controller
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  /**
   This delegate method is optional.
   It is called when a new conversation has started, from the agent or from the consumer side.
   */
  func LPMessagingSDKConversationStarted(_ conversationID: String?) {
    // Log - Event
    print("conversationID:: \(conversationID!)")
  }
  
  /**
   This delegate method is optional.
   It is called when a conversation has ended, from the agent or from the consumer side.
   */
  func LPMessagingSDKConversationEnded(_ conversationID: String?) {
  }
  
  /**
   This delegate method is optional.
   It is called when the customer satisfaction survey is dismissed after the user has submitted the survey/
   */
  func LPMessagingSDKConversationCSATDismissedOnSubmittion(_ conversationID: String?) {
    
  }
  
  /**
   This delegate method is optional.
   It is called each time connection state changed for a brand with a flag whenever connection is ready.
   Ready means that all conversations and messages were synced with the server.
   */
  func LPMessagingSDKConnectionStateChanged(_ isReady: Bool, brandID: String) {
    
  }
  
  /**
   This delegate method is optional.
   It is called when the user tapped on the agent’s avatar in the conversation and also in the navigation bar within window mode.
   */
  func LPMessagingSDKAgentAvatarTapped(_ agent: LPUser?) {
    
  }
  
  /**
   This delegate method is optional.
   It is called when the Conversation CSAT did load
   */
  func LPMessagingSDKConversationCSATDidLoad(_ conversationID: String?) {
    
  }
  
  /**
   This delegate method is optional.
   It is called when the Conversation CSAT skipped by the consumers
   */
  func LPMessagingSDKConversationCSATSkipped(_ conversationID: String?) {
    
  }
  
  /**
   This delegate method is optional.
   It is called when the user is opening photo sharing gallery/camera and the persmissions denied
   */
  func LPMessagingSDKUserDeniedPermission(_ permissionType: LPPermissionTypes) {
    
  }
}

