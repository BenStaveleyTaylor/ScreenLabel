//
//  TextAttributesHelper.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 24/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

enum TextAttributesHelper {

    static var systemFontInternalName = UIFont.systemFont(ofSize: 12).fontName
    static var systemFontDisplayName = Resources.localizedString("SystemFontDisplayName")

    // Return a formatted string to display for a font's size
    // e.g. 12 returns "12 pt"
    static func displayTextForPointSize(_ size: CGFloat) -> String {

        let value: Int = Int(round(size))

        let format = Resources.localizedString("TextSizeValue")
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
}
