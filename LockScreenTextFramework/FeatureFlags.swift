//
//  FeatureFlags.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 06/11/2022.
//  Copyright © 2022 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

enum FeatureFlags {

    // Widget is iOS 16+ feature
    static var widgetAvailable: Bool {
        if #available(iOS 16, *) {
            // Only on iPhone, not iPad
            let device = UIDevice.current
            return device.userInterfaceIdiom == .phone
        } else {
            return false
        }
    }
}
