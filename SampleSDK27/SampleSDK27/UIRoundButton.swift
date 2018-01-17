//
//  UIRectButton.swift
//  SampleSDK27
//
//  Created by David Villacis on 12/6/17.
//  Copyright © 2017 David Villacis. All rights reserved.
//

import UIKit
import ObjectiveC

// This will make the Storyboard Re-render the Element
@IBDesignable class UIRectButton : UIButton {
  
  /// Set CornerRadius
  @IBInspectable var cornerRadius : CGFloat = 2.0 {
    didSet{
      self.layer.cornerRadius = cornerRadius
    }
  }
  
  /// Init Layout Subviews
  override func layoutSubviews() {
    // Init Super Class
    super.layoutSubviews()
    // Set Corner Radius
    self.layer.cornerRadius = self.cornerRadius
    // Mask Layer
    self.layer.masksToBounds = (self.cornerRadius / 2.0) > 0
  }
}
