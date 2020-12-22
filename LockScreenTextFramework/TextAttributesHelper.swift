//
//  TextAttributesHelper.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 24/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import Foundation
import os.log

enum TextAttributesHelper {

    static var systemFontInternalName = UIFont.systemFont(ofSize: 12).familyName
    static var systemFontDisplayName = Resources.sharedInstance.localizedString("SystemFontDisplayName")

    // Return a formatted string to display for a font's size
    // e.g. 12 returns "12 pt"
    static func displayTextForPointSize(_ size: CGFloat) -> String {

        let value = Int(round(size))

        let format = Resources.sharedInstance.localizedString("TextSizeValue")
        let text = String(format: format, NSNumber(value: value))

        return text
    }

    static func fontDisplayNameFrom(internalName: String) -> String {

        // Return "System Font" instead of ".SFUIFont"
        if internalName == systemFontInternalName {
            return systemFontDisplayName
        }

        return internalName
    }

    static func fontInternalNameFrom(displayName: String) -> String {

        // Return ".SFUIFont" instead of "System Font"
        if displayName == systemFontDisplayName {
            return systemFontInternalName
        }

        return displayName
    }

    // Return the font, or system font if an error occurs
    static func fontFrom(displayName: String?, size: CGFloat) -> UIFont {

        if let displayName = displayName {
            let internalName = self.fontInternalNameFrom(displayName: displayName)
            if let result = UIFont(name: internalName, size: size) {
                return result
            }
        }

        // We shouldn't really need to do this fallback
        os_log("Failed to generate font of name %@", (displayName ?? "<nil>"))

        return UIFont.systemFont(ofSize: size)
    }

    static func styleSegmentIndexFrom(textStyle: TextStyle) -> Int {

        switch textStyle {
        case .plain:
            return 0

        case .bold:
            return 1

        case .italic:
            return 2

        case .boldItalic:
            return 3
        }

    }

    static func textStyleFrom(styleSegmentIndex: Int) -> TextStyle {

        switch styleSegmentIndex {
        case 1:
            return .bold

        case 2:
            return .italic

        case 3:
            return .boldItalic

        default:
            return .plain
        }

    }
}

extension TextStyle {

    func applyToFont(_ baseFont: UIFont) -> UIFont {

        // Derive the right style
        switch self {
        case .bold:
            return baseFont.bold

        case .italic:
            return baseFont.italic

        case.boldItalic:
            return baseFont.boldItalic

        default:
            return baseFont
        }
    }
}
