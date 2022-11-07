//
//  FeatureFlags.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 06/11/2022.
//  Copyright © 2022 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

struct FeatureFlags {

    // Widget is iOS 16+ feature
    static var widgetEnabled: Bool {
        get {
            if #available(iOS 16, *) {
                return true
            } else {
                return false
            }
        }
    }
}


