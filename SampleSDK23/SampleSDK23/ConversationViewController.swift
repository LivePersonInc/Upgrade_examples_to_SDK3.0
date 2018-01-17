//
//  ConversationViewController.swift
//  SampleSDK23
//
//  Created by David Villacis on 12/21/17.
//  Copyright © 2017 David Villacis. All rights reserved.
//

import UIKit
// Required LP Imports
import LPMessagingSDK
import LPAMS
import LPInfra

class ConversationViewController: UIViewController {
  
  // MARK: - App LifeCycle
  
  /// App LifeCycle - View did Load
  override func viewDidLoad() {
    // Super Init
    super.viewDidLoad()
    // Will make ConversationController layout properly with NavigationBar
    self.edgesForExtendedLayout = []
    // Init LivePerson Singleton
    LivePersonSDK.shared.initSDK()
    // Init SDK Logger
    LivePersonSDK.shared.initLogger()
    // Set Delegate
    LivePersonSDK.shared.delegate = self
    // Customize ConversationView
    LivePersonSDK.shared.customizeMessagingScreen()
    // Show Conversation View
    LivePersonSDK.shared.showConversation(withView: self)
  }
  
  /// App LifeCycle - Receive Memory Warning
  override func didReceiveMemoryWarning() {
    // Super Init
    super.didReceiveMemoryWarning()
  }
  
  /// Event - View will Disappear
  override func viewWillDisappear(_ animated: Bool) {
    // Super Init
    super.viewWillDisappear(animated)
    // INFO: When using Custom View Controller Mode, Conversation must be remove when leaving the App, if the Conversation View is the current screen
    // INFO: To avoid dimissing the View if CSAT/SecureForms/PhotoSharing View is presented, will only dismiss the Conversation if Moving From ParentView,
    if self.isMovingFromParentViewController {
      // Remove Conversation
      _ = LivePersonSDK.shared.removeConversation()
    }
  }
  
  /// Will respond to Back Button Pressed
  ///
  /// - Parameter sender: UIBarButtonItem - Back Button
  @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
    // INFO: When using a Custom View Controller, first we remove Conversation, then you need to popToRootViewController
    // Check if ConversationView was Removed
    if LivePersonSDK.shared.removeConversation() {
      // Pop to RootViewController if ConversationView was removed
      self.navigationController?.popToRootViewController(animated: true)
    }
  }
  
  /// Will respond to Menu Button Pressed
  ///
  /// - Parameter sender: UIBarButtonItem - Menu Button
  @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
    // Create Alert Controller for Menu
    let menu = UIAlertController(title: "Menu", message: "Choose an Option", preferredStyle: .actionSheet)
    // Create Resolve Action
    let resolve = UIAlertAction(title: "End conversation", style: .destructive) { (alert : UIAlertAction) in
      // Resolve Conversation
      LivePersonSDK.shared.resolveConversation()
    }
    // Resolve Conversation only if there is an Active one
    resolve.isEnabled = LivePersonSDK.shared.isConversationActive
    // Set Title Depending on Current Conversation State
    let isUrgentTitle = LivePersonSDK.shared.isUrgent() ? "Dissmiss Urgent" : "Mark as Urgent"
    // Create Mark/Dismiss Urgent Action
    let urgent = UIAlertAction(title: isUrgentTitle, style: .default) { (alert : UIAlertAction) in
      // Toggle Urgent State
      LivePersonSDK.shared.toggleUrgentState()
    }
    // Create Cancel - Will Dismiss AlertSheet
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    // Add Action - Resolve
    menu.addAction(resolve)
    // Add Action - Urgent
    menu.addAction(urgent)
    // Add Action - Cancel
    menu.addAction(cancel)
    // Show Menu
    self.present(menu, animated: true, completion: nil)
  }
  
}
extension ConversationViewController : LPMessagingSDKdelegate {
  
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
    // Check if Agent information is avaiable
    if agent != nil {
      // Set Agent Name on ConversationViewController Navigation Title
      self.navigationItem.title = agent!.firstName
    }
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
    // Remove Agent Name from ConversationViewController Navigation Title
    self.navigationItem.title = "LivePerson"
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
  // INFO : LPMessagingSDK Version 2.7 introduced new CSAT callback
  // func LPMessagingSDKConversationCSATDidLoad(_ conversationID: String?) {
  // }
  
  /**
   This delegate method is optional.
   It is called when the Conversation CSAT skipped by the consumers
   */
  // INFO : LPMessagingSDK Version 2.7 introduced new CSAT callback
  // func LPMessagingSDKConversationCSATSkipped(_ conversationID: String?) {
  // }
  
  /**
   This delegate method is optional.
   It is called when the user is opening photo sharing gallery/camera and the persmissions denied
   */
  // INFO : LPMessagingSDK Version 2.7 introduced new Photo sharing permissions callback
  // func LPMessagingSDKUserDeniedPermission(_ permissionType: LPPermissionTypes) {
  // }
}
