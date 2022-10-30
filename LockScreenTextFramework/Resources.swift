//
//  Resources.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 11/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import Foundation
import UIKit

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
    public func localizedString(_ key: String, suffix: String? = nil, tableName: String? = nil) -> String {
        
        let bundle = BundleLocator.thisBundle()
        
        var template: String?
        
        if let suffix = suffix {
            template = NSLocalizedString("\(key)\(suffix)",
                                         tableName: tableName,
                                         bundle: bundle,
                                         value: Resources.notFound,
                                         comment: "")
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
            return "???"
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
                      suffix: String? = nil,
                      in bundle: Bundle = BundleLocator.thisBundle(),
                      compatibleWith traitCollection: UITraitCollection? = nil) -> UIImage? {
        
        if let suffix = suffix {
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
