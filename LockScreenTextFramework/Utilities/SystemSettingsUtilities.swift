//
//  SystemSettingsUtilities.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 27/01/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

enum SystemSettingsUtilities {

    static func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL, completionHandler: nil)
        }
    }
}
