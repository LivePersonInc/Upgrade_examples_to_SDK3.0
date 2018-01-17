## Upgrating LPMessagingSDK to 3.0
Examples for upgrading SDK versions 2.3 / 2.7 and 2.8 to 3.0


* [Upgrating LPMessagingSDK 2.3](#Updating-from-2.3-to-3.0)
* [Upgrating LPMessagingSDK 2.7](#Updating-from-2.7-to-3.0)
* [Upgrating LPMessagingSDK 2.8](#Updating-from-2.8-to-3.0)

### Updating from 2.3 to 3.0


#### Step 1: Update Podfile


  Update LPMessagingSDK Pod
  
  	``` ruby
    
  		target ‘<YourApplicatioName>’ do
     	#Update change LPMessagingSDK Pod from:
  	   	pod 'LPMessagingSDK','~> 2.3.0'
   	  	#To:
   	  	pod 'LPMessagingSDK','~> 3.0.0'
        
  	```


#### Step 2: Update Pod
	
	
	~~~ sh
		$ pod install
	~~~
	
	
#### Step 3: Clean Xcode Project


	Clean`cmd + shift + k` & Build`cmd + b` the App.



#### Step 4: Replace Deprecated Methods

* showConversation method needs to be replace:
	
	Previous implementation:
	
	~~~ swift
		LPMessagingSDK.instance.showConversation(self.conversationQuery!, authenticationCode: nil, containerViewController: nil)
	~~~
	
	New implementation for WindowMode:
	
	~~~ swift
		// Create ConversationViewParams
		let conversationViewParams = LPConversationViewParams(conversationQuery: self.conversationQuery!, containerViewController: nil, isViewOnly: false)
		// Create AuthenticationParams
		let authenticationParams = LPAuthenticationParams()
		// Show Conversation
		LPMessagingSDK.instance.showConversation(conversationViewParams, authenticationParams: authenticationParams)
	~~~
	
	New implementation for custom ViewController:
	
	~~~ swift
		// Create ConversationViewParams
		let conversationViewParams = LPConversationViewParams(conversationQuery: self.conversationQuery!, containerViewController: viewController, isViewOnly: false)
		// Create AuthenticationParams
		let authenticationParams = LPAuthenticationParams()
		// Show Conversation
		LPMessagingSDK.instance.showConversation(conversationViewParams, authenticationParams: authenticationParams)
	~~~
  	
* reconnect method needs to be replace:

	Previous implementation:

		~~~ swift
			LPMessagingSDK.instance.reconnect(conversationQuery!, authenticationCode: "")
		~~~

	New implementation:
	
		~~~ swift
			// Create Authentication Params
			let authParams = LPAuthenticationParams()
			// Show Conversation
			LPMessagingSDK.instance.reconnect(self.conversationQuery!, authenticationParams: authParams
		~~~  	
    	
* logout method needs to be replace:

	Previous implementation:

		~~~ swift
			LPMessagingSDK.instance.logout()
		~~~

	New implementation:
	
		~~~ swift
			LPMessagingSDK.instance.logout(completion: {
    			// Log - Success
    			print("User::logged out")
    		}) { (error) in
    			// Log - Error
    			print("User:: \(error.localizedDescription)")
    		}
		~~~

##### New Configurations

	* Structure Content
		
			~~~ swift
				// Enable Structure Content
	    		config.enableStrucutredContent = true
		    	// Set Structure Content Border Color
	   	 		config.structuredContentBubbleBorderColor = UIColor.black
		    	// Set Structure Content Bubble Border Width in Pixels
	   	 		config.structuredContentBubbleBorderWidth = 1.5
			~~~
		
### Updating from 2.7 to 3.0

### Updating from 2.8 to 3.0`
