//
//  HelpNavigationController.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 07/03/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

class HelpNavigationController: DialogNavigationController {

    // Provide a bigger help viewing area than the standard form (h:620  x w:540)
    public override var preferredContentSize: CGSize {
        get {
            var result = super.preferredContentSize

            // iPad-only:
            if DeviceUtilities.isRegularDevice {

                let windowSize = DeviceUtilities.appScreenSize
                if result.height == 0 {
                    result.height = windowSize.height * 0.8
                }
                if result.width == 0 {
                    // Max out at 540 or else the help images get too large
                    result.width = min(540, windowSize.width * 0.8)
                }
            }

            return result
        }
        set {
            super.preferredContentSize = newValue
        }
    }

}
