//
//  Resources.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 11/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

struct Resources {

    // Singleton
    static let sharedInstance = Resources()

    static let notFound = "???"

    public let appName: String
    public var deviceName: String {
        return UIDevice.current.localizedModel
    }

    /// Wrapper/Replacement for NSLocalizedString that reads a named string table
    /// in the framework bundle
    public func localizedString(_ key: String, tableName: String? = nil) -> String {

        let bundle = BundleLocator.thisBundle()

        let result = NSLocalizedString(key,
                                       tableName: tableName,
                                       bundle: bundle,
                                       value: Resources.notFound,
                                       comment: "")

        return self.performStandardSubstitutions(on: result)
    }

    /// Read an image from this bundle
    public func image(named name: String,
                      in bundle: Bundle = BundleLocator.thisBundle(),
                      compatibleWith traitCollection: UITraitCollection? = nil) -> UIImage? {

        return UIImage(named: name, in: bundle, compatibleWith: traitCollection)
    }

    /// Read a color from this bundle
    public func color(named name: String,
                      in bundle: Bundle = BundleLocator.thisBundle(),
                      compatibleWith traitCollection: UITraitCollection? = nil) -> UIColor? {

        return UIColor(named: name, in: bundle, compatibleWith: traitCollection)
    }

    // Replace @AppName@ with the application name
    // Replace @DeviceName@ with the device name
    public func performStandardSubstitutions(on string: String) -> String {

        var result = string

        result = result.replacingOccurrences(of: "@AppName@", with: self.appName)
        result = result.replacingOccurrences(of: "@DeviceName@", with: self.deviceName)

        return result
    }

    private init() {
        // Get the name of the host app
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String

        self.appName = appName ?? Resources.notFound
    }

    // Used to locate the bundle that contains this file
    // Can't use Bundle(for:) with structs
    private class BundleLocator {
        static func thisBundle() -> Bundle {
            return Bundle(for: self)
        }
        private init() {}
    }
}
