//
//  UIFont+Extensions.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 08/03/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

// Reference: https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/Extensions/UIKit/UIFontExtensions.swift
public extension UIFont {

    /// Font as bold font
    public var bold: UIFont {
        guard let modifiedDescriptor = self.fontDescriptor.withSymbolicTraits(.traitBold) else {
            return self
        }
        return UIFont(descriptor: modifiedDescriptor, size: 0)
    }

    /// Font as italic font
    public var italic: UIFont {
        guard let modifiedDescriptor = self.fontDescriptor.withSymbolicTraits(.traitItalic) else {
            return self
        }
        return UIFont(descriptor: modifiedDescriptor, size: 0)
    }

    /// Font as boldItalic font
    public var boldItalic: UIFont {
        guard let modifiedDescriptor = self.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) else {
            return self
        }
        return UIFont(descriptor: modifiedDescriptor, size: 0)
    }
}
