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

    /// Wrapper/Replacement for NSLocalizedString that reads a named string table
    /// in the framework bundle
    public static func localizedString(_ key: String, tableName: String? = nil) -> String {

        guard let bundle = Resources.frameworkBundle else {
            return "???"
        }

        let result = NSLocalizedString(key, tableName: tableName, bundle: bundle, comment: "")
        return result
    }

    /// Read an image from this bundle
    public static func image(named name: String,
                             in bundle: Bundle? = Resources.frameworkBundle,
                             compatibleWith traitCollection: UITraitCollection? = nil) -> UIImage? {

        return UIImage(named: name, in: bundle, compatibleWith: traitCollection)
    }

    /// Read a color from this bundle
    public static func color(named name: String,
                             in bundle: Bundle? = Resources.frameworkBundle,
                             compatibleWith traitCollection: UITraitCollection? = nil) -> UIColor? {

        return UIColor(named: name, in: bundle, compatibleWith: traitCollection)
    }

}
