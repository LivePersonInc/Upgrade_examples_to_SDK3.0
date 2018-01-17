//
//  ViewController.swift
//  SampleSDK27
//
//  Created by David Villacis on 12/6/17.
//  Copyright © 2017 David Villacis. All rights reserved.
//

import UIKit
// Required LP Imports
import LPMessagingSDK
import LPAMS
import LPInfra

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  // Reference to ConversationViewController
  var conversationViewController : ConversationViewController?
  // Check if is Window Mode
  public var IS_WINDOW_MODE : Bool = false
  // Check if Screen is been open by a Push
  public var COMES_FROM_PUSH : Bool = false
  
  // MARK: - Application LifeCycle
  
  /// Event - View did Load
  override func viewDidLoad() {
    // Super Init
    super.viewDidLoad()
    // TODO: if WINDOW_MODE is ON, show Messaging Window if App was opened from PUSH, this is handle different if CustomViewController
    // Check if View Comes from Push
    if COMES_FROM_PUSH {
      // Show Messaging View
      self.handleMessaging()
    }
  }
  
  /// Event - Receive Memory Warning
  override func didReceiveMemoryWarning() {
    // Super Init
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - LPMessaging Methods
  
  /// Will respond to User Tapping Chat Button
  ///
  /// - Parameter sender: UIButton
  @IBAction func startMessaging(_ sender: Any) {
    // Show Messaging View
    self.handleMessaging()
  }
  
  /// Will handle Messaging SDK Init & Presentation
  private func handleMessaging () {
    // Check if Messaging is in Window Mode
    if IS_WINDOW_MODE {
      // Init LivePerson Singleton
      LivePersonSDK.shared.initSDK()
      // Set Delegate
      LivePersonSDK.shared.delegate = self
      // Customize ConversationView
      LivePersonSDK.shared.customizeMessagingScreen()
      // Show Conversation View
      LivePersonSDK.shared.showConversation()
    } else {
      // TODO: if using a custom ViewController - SDK Initialization should be done on that ViewController, LPMessagingSDKdelegate should be implemented there too.
      // Get ConversationViewController reference
      self.conversationViewController = storyboard?.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
      // Push Coversation ViewController
      self.navigationController?.pushViewController(conversationViewController!, animated:true)
    }
  }
  
  /// Will respond to User Tapping Logout Button
  ///
  /// - Parameter sender: UIButton
  @IBAction func logoutButtonTapped(_ sender: Any) {
    // Logout User from Chat
    LivePersonSDK.shared.logout()
  }
}
// TODO: if Custom View Controller is used, erase this Delegate as this one will only be use if Window Mode is use, and implement LPMessagingSDKDelegate on CustomViewController
extension ViewController : LPMessagingSDKdelegate {
  
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
    // Go Back to MainViewController
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

