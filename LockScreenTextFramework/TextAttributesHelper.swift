//
//  TextAttributesHelper.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 24/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

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
