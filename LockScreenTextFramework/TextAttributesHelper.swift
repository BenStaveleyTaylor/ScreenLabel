//
//  TextAttributesHelper.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 24/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

enum TextAttributesHelper {

    // Return a formatted string to display for a font's size
    // e.g. 12 returns "12 pt"
    static func displayTextForPointSize(_ size: CGFloat) -> String {

        let value: Int = Int(round(size))

        let format = Resources.localizedString("TextSizeValue")
        let text = String(format: format, NSNumber(value: value))

        return text
    }
}
