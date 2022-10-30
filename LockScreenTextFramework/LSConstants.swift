//
//  LSConstants.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 05/11/2022.
//  Copyright © 2022 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

public enum LSConstants {

    public static let defaultAnimationDuration: TimeInterval = 0.3

    public static let navigationScheme = "lockscreentext"

    public static let editSettingsNavKey = "editsettings"
    public static let editSettingsNavUrl = URL(string: "\(navigationScheme)://\(editSettingsNavKey)")
}
