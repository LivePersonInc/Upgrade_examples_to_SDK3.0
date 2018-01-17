# Upgrating LPMessagingSDK to 3.0
Examples for upgrading SDK versions 2.3 / 2.7 and 2.8 to 3.0

* [Upgrating LPMessagingSDK 2.3](#markdown-header-Updating-from-2.3-to-3.0)
* [Upgrating LPMessagingSDK 2.7](#markdown-header-Updating-from-2.7-to-3.0)
* [Upgrating LPMessagingSDK 2.8](#markdown-header-Updating-from-2.8-to-3.0)

## Updating from 2.3 to 3.0

#### Step 1: Update Podfile

  * Update LPMessagingSDK Pod
  
  	```ruby
  		target '<YourApplicatioName>' do
     	    # Update change LPMessagingSDK Pod from:
  	   	    pod 'LPMessagingSDK','~> 2.3.0'
   	  	    # To:
   	  	    pod 'LPMessagingSDK','~> 3.0.0'
   	  	end
  	```

#### Step 2: Update Pod

* Update Podfile
    
    ```sh
        $ pod update
    ```
	
#### Step 3: Clean Xcode Project

* Clean `cmd + shift + k` & Build `cmd + b` the App.


#### Step 4: Replace Deprecated Methods

* **showConversation** method needs to be replace:
	
	Previous implementation:
	
	~~~ swift
		LPMessagingSDK.instance.showConversation(self.conversationQuery!, 
                                                authenticationCode: nil, 
                                                containerViewController: nil)
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
  	
* **reconnect** method needs to be replace:

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
    	
* **logout** method needs to be replace:

	Previous implementation:

	~~~ swift
		LPMessagingSDK.instance.logout()
	~~~

	New implementation:
	
	~~~ swift
		LPMessagingSDK.instance.logout(completion: {
    		// Log - Success
    		print("User:: logged out")
    	}) { (error) in
    		// Log - Error
    		print("User:: \(error.localizedDescription)")
		}
	~~~

##### New Configurations
* Structure Content:
        
    ~~~ swift
        // Enable Structure Content
        config.enableStrucutredContent = true
        // Set Structure Content Border Color
        config.structuredContentBubbleBorderColor = UIColor.black
    	// Set Structure Content Bubble Border Width in Pixels
        config.structuredContentBubbleBorderWidth = 1.5
    ~~~
		

#### Step 4 (Optional): Custom ViewController

When implementing a Custom ViewController there are a few things to consider:

 * Remove Conversation from View if viewWillDisappear()
    
    ``` swift
    /// Event - View will disappear
    override func viewWillDisappear(_ animated: Bool) {
        // Super Init
        super.viewWillDisappear(animated)
        // INFO: When using Custom View Controller Mode, Conversation must be remove when leaving the App, if the Conversation View is the current screen
        // Check if ConversationQuery has been set
        if self.conversationQuery != nil {
            // Remove Conversation
            LPMessagingSDK.instance.removeConversation(self.conversationQuery!)
        }
    }
    ```
    
    > Note: if implementing custom Back Button on the Navigation Bar, this needs to be consider too.
    
    
    
## Updating from 2.7 to 3.0



#### Step 1: Update Podfile

  * Update LPMessagingSDK Pod
  
  	```ruby
  		target '<YourApplicatioName>' do
     	    # Update change LPMessagingSDK Pod from:
  	   	    pod 'LPMessagingSDK','~> 2.7.0'
   	  	    # To:
   	  	    pod 'LPMessagingSDK','~> 3.0.0'
   	  	end
  	```

#### Step 2: Update Pod

* Update Podfile
    
    ```sh
        $ pod update
    ```
	
#### Step 3: Clean Xcode Project

* Clean `cmd + shift + k` & Build `cmd + b` the App.


#### Step 4: Replace Deprecated Methods

* **logout** method needs to be replace:

	Previous implementation:

	~~~ swift
		LPMessagingSDK.instance.logout()
	~~~

	New implementation:
	
	~~~ swift
		LPMessagingSDK.instance.logout(completion: {
    		// Log - Success
    		print("User:: logged out")
    	}) { (error) in
    		// Log - Error
    		print("User:: \(error.localizedDescription)")
		}
	~~~

#### Step 4 (Optional): Custom ViewController

When implementing a Custom ViewController there are a few things to consider:

 * Remove Conversation from View if viewWillDisappear()
    
    ``` swift
    /// Event - View will disappear
    override func viewWillDisappear(_ animated: Bool) {
        // Super Init
        super.viewWillDisappear(animated)
        // INFO: When using Custom View Controller Mode, Conversation must be remove when leaving the App, if the Conversation View is the current screen
        // Check if ConversationQuery has been set
        if self.conversationQuery != nil {
            // Remove Conversation
            LPMessagingSDK.instance.removeConversation(self.conversationQuery!)
        }
    }
    ```
    
    > Note: if implementing custom Back Button on the Navigation Bar, this needs to be consider too.



## Updating from 2.8 to 3.0



#### Step 1: Update Podfile

  * Update LPMessagingSDK Pod
  
  	```ruby
  		target '<YourApplicatioName>' do
     	    # Update change LPMessagingSDK Pod from:
  	   	    pod 'LPMessagingSDK','~> 2.8.0'
   	  	    # To:
   	  	    pod 'LPMessagingSDK','~> 3.0.0'
   	  	end
  	```

#### Step 2: Update Pod

* Update Podfile
    
    ```sh
        $ pod update
    ```
	
#### Step 3: Clean Xcode Project

* Clean `cmd + shift + k` & Build `cmd + b` the App.

