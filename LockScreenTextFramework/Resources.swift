//
//  Resources.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 11/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

enum Resources {

    static let bundleIdentifier = "com.staveleytaylor.ben.LockScreenTextFramework"

    static var frameworkBundle: Bundle? {
        let bundle = Bundle(identifier: Resources.bundleIdentifier)
        assert(bundle != nil, "Bundle '\(Resources.bundleIdentifier)' not found")
        return bundle
    }

    /// Wrapper/Replacement for NSLocalizedString that uses the framework bundle
    public static func localizedString(_ key: String) -> String {

        guard let bundle = Resources.frameworkBundle else {
            return "???"
        }

        let result = NSLocalizedString(key, bundle: bundle, comment: "")
        return result
    }
}
