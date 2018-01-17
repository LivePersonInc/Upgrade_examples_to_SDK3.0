//
//  ConversationViewController.swift
//  SampleSDK27
//
//  Created by David Villacis on 12/7/17.
//  Copyright © 2017 David Villacis. All rights reserved.
//

import UIKit
// Required LP Imports
import LPMessagingSDK
import LPAMS
import LPInfra

class ConversationViewController: UIViewController {
  
  /// Event - View did Load
  override func viewDidLoad() {
    // Super Init
    super.viewDidLoad()
    // Will make ConversationController layout properly with NavigationBar
    self.edgesForExtendedLayout = []
    // TODO: SDK Init for View Controller Mode
    // Init LivePerson Singleton
    LivePersonSDK.shared.initSDK()
    // Set Delegate
    LivePersonSDK.shared.delegate = self
    // Customize ConversationView
    LivePersonSDK.shared.customizeMessagingScreen()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Show ConversationView
    LivePersonSDK.shared.showConversation(withView: self)
  }
  
  /// Event - Receive Memory Warning
  override func didReceiveMemoryWarning() {
    // Super Init
    super.didReceiveMemoryWarning()
  }
  
  /// Event - View will Disappear
  override func viewWillDisappear(_ animated: Bool) {
    // TODO: When using a Custom View Controller, Conversation must be remove, when leaving the App, but the Conversation View is the current screen
    // Remove Conversation
    _ = LivePersonSDK.shared.removeConversation()
  }
  
  /// Will respond to Back Button Pressed
  ///
  /// - Parameter sender: UIBarButtonItem - Back Button
  @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
    // TODO: When using a Custom View Controller, first we remove Conversation, then you need to popToRootViewController
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
    // TODO: Build Menu Options
    // Create Alert Controller for Menu
    let menu = UIAlertController(title: "Menu", message: "Choose an Option", preferredStyle: .actionSheet)
    // Create Resolve Action
    let resolve = UIAlertAction(title: "End conversation", style: .destructive) { (alert : UIAlertAction) in
      // Resolve Conversation
      LivePersonSDK.shared.resolveConversation()
    }
    // Toggle Resolve State
    resolve.isEnabled = LivePersonSDK.shared.isConversationActive
    // Set Title Depending on Current Conversation State
    let isUrgentTitle = LivePersonSDK.shared.isUrgent() ? "Dissmiss Urgent" : "Mark as Urgent"
    // Create Mark/Dismiss Urgent Action
    let urgent = UIAlertAction(title: isUrgentTitle, style: .default) { (alert : UIAlertAction) in
      // Toggle Urgent State
      LivePersonSDK.shared.toggleUrgentState()
    }
    // Toggle Resolve State
    urgent.isEnabled = LivePersonSDK.shared.isConversationActive
    // Create Cancel - Will Dismiss AlertSheet
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    // Add Action - Resolve
    menu.addAction(resolve)
    // Add Action - Urgent
    menu.addAction(urgent)
    // Add Action - Cancel
    menu.addAction(cancel)
    // Check if Device is iPad needs to use Presentation Popover Controller
    if UIView.Device.IS_IPAD {
      // Set Popover Presentation Controller as Menu Button Item
      if let popoverController = menu.popoverPresentationController {
        // Set Controller as Menu Button
        popoverController.barButtonItem = sender
      }
    }
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
