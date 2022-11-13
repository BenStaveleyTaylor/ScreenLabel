//
//  Resources.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 11/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import Foundation
import UIKit

public struct Resources {
    
    // Singleton
    public static let sharedInstance = Resources()
    
static let notFound = "???"
    
    public let appName: String
    public var deviceName: String {
        return UIDevice.current.localizedModel
    }
    
    /// Wrapper/Replacement for NSLocalizedString that reads a named string table
    /// in the framework bundle
    /// If searchForOSVariants == true, we step back through all iOS versions (back to 12)
    public func localizedString(_ key: String, searchForOSVariants: Bool = false, tableName: String? = nil) -> String {
        
        let bundle = BundleLocator.thisBundle()
        
        var template: String?

        // The UI is different in iOS 16, 15, 14, 13 and 12....
        // Find the most recent version number that matches
        let searchSuffixes = searchForOSVariants ? osSuffixSearchOrder() : []

        for suffix in searchSuffixes {
            template = NSLocalizedString("\(key)\(suffix)",
                                         tableName: tableName,
                                         bundle: bundle,
                                         value: Resources.notFound,
                                         comment: "")

            if template != nil && template != Resources.notFound {
                // Take the first match we find. Assumes searchSuffixes is sorted newest-to-oldest.
                break
            }
        }

        if template == nil || template == Resources.notFound {
            // Fall through to generic version
            template = NSLocalizedString(key,
                                         tableName: tableName,
                                         bundle: bundle,
                                         value: Resources.notFound,
                                         comment: "")
        }
        
        guard let result = template else {
            return Resources.notFound
        }
        
        return self.performStandardSubstitutions(on: result)
    }
    
    /// Read an image from this bundle
    /// - Parameter name: Name of image asset
    /// - Parameter suffix: optional suffix to use, e.g. "-iOS12". This is not the extension but a way
    /// to provide alternatives of the image with different suffixes
    /// - Parameter bundle: bundle to search
    /// - Parameter traitCollection: traits to match
    public func image(named name: String,
                      searchForOSVariants: Bool = false,
                      in bundle: Bundle = BundleLocator.thisBundle(),
                      compatibleWith traitCollection: UITraitCollection? = nil) -> UIImage? {

        // The UI is different in iOS 16, 15, 14, 13 and 12....
        // Find the most recent version number that matches
        let searchSuffixes = searchForOSVariants ? osSuffixSearchOrder() : []

        for suffix in searchSuffixes {
            // Try using it
            if let image = UIImage(named: "\(name)\(suffix)", in: bundle, compatibleWith: traitCollection) {
                return image
            }
        }

        // Fall through to generic version
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
        appName = NSLocalizedString("AppName", bundle: BundleLocator.thisBundle(), comment: "")
    }

    // Build an array of iOS version resource suffixes in order of preference
    private func osSuffixSearchOrder() -> [String] {

        let searchSuffixes: [String]

        if #available(iOS 16, *) {
            // Latest iOS has no suffix (it always uses the default)
            searchSuffixes = []
        } else if #available(iOS 15, *) {
            searchSuffixes = ["-iOS15", "-iOS14", "-iOS13", "-iOS12"]
        } else if #available(iOS 14, *) {
            searchSuffixes = ["-iOS14", "-iOS13", "-iOS12"]
        } else if #available(iOS 13, *) {
            searchSuffixes = ["-iOS13", "-iOS12"]
        } else {
            // iOS 12 or earlier
            searchSuffixes = ["-iOS12"]
        }

        return searchSuffixes
    }
    
    // Used to locate the bundle that contains this file
    // Can't use Bundle(for:) with structs
    public class BundleLocator {
        public static func thisBundle() -> Bundle {
            return Bundle(for: self)
        }
        private init() {}
    }
}
