//
//  Settings.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 08/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit
import os.log

// Data model
enum TextStyle: Int, Codable {
    case plain, bold, italic, boldItalic
}

// Perspective BleedStyle is considered "normal" -- it's simplest for most use cases.
enum BleedStyle: Int, Codable {
    case still, perspective
}

// Helper structs to handle coding of non-standard types

// UIColor
private struct CodableColor: Codable {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0

    init(uiColor: UIColor) {
        uiColor.getRed(&self.red, green: &self.green, blue: &self.blue, alpha: &self.alpha)
    }

    func toUIColor() -> UIColor {
        return UIColor(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
    }
}

// UIFont
private struct CodableFont: Codable {
    let name: String
    let size: CGFloat

    init(uiFont: UIFont) {
        self.name = uiFont.fontName
        self.size = uiFont.pointSize
    }

    func toUIFont() -> UIFont? {

        // The System Font internal name seems to have changed in iOS 13.
        // It used to be .SFUI-Regular; now it is .AppleSystemUIFont
        // Treat any font that begins with a '.' as the system font

        if self.name.hasPrefix(".") {
            return UIFont.systemFont(ofSize: self.size)
        } else {
            return UIFont(name: self.name, size: self.size)
        }
    }
}

// UIEdgeInsets
private struct CodableEdgeInsets: Codable {
    let top, left, bottom, right: CGFloat

    init(uiEdgeInsets: UIEdgeInsets) {
        self.top = uiEdgeInsets.top
        self.left = uiEdgeInsets.left
        self.bottom = uiEdgeInsets.bottom
        self.right = uiEdgeInsets.right
    }

    func toUIEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: self.right)
    }
}

public struct Settings: Codable {

    // Default values
    static let defaults = Settings()

    // Change history:
    // v1: Initial release
    // v2: Add showLockScreenUI
    // v3: Add showWidgetPreview
    static let currentVersion: Int = 3

    var version: Int

    // Name of the image file in the KnownDirectory.images folder
    var imageName: String?
    var imageBackgroundColor: UIColor
    var imageBleedStyle: BleedStyle

    var scrollScale: CGFloat
    var scrollOffset: CGPoint

    // The text of the message
    public var message: String

    // The stored font is always the plain style
    // Selected style variations are computed from that
    var textFont: UIFont
    var textStyle: TextStyle
    var textAlignment: NSTextAlignment
    var textColor: UIColor

    var boxColor: UIColor
    var boxBorderWidth: CGFloat
    var boxCornerRadius: CGFloat
    var boxInsets: UIEdgeInsets

    // Vertical centre of the box as an offset from the centre of the container
    // (i.e. screen rect.) 0 is at the centre.
    var boxYCentreOffset: CGFloat

    // Show the simulation of the lock screen UI
    var showLockScreenUI: Bool

    // Show lock screen widget preview
    var showWidgetPreview: Bool

    // Currently everything
    private enum CodingKeys: String, CodingKey {
        case version
        case imageName
        case imageBackgroundColor
        case imageBleedStyle
        case scrollScale
        case scrollOffset
        case message
        case textFont
        case textStyle
        case textAlignment
        case textColor
        case boxColor
        case boxBorderWidth
        case boxCornerRadius
        case boxInsets
        case boxYCentreOffset
        case showLockScreenUI
        case showWidgetPreview
    }

    // Set up defaults
    init() {

        // Use a smaller text size on phone
        let defaultTextFont: UIFont

#if TARGET_IS_EXTENSION
        // Can't use DeviceUtilities. Don't realy care about font size anyway.
        defaultTextFont = .preferredFont(forTextStyle: .footnote)   // 13pt
#else
        if DeviceUtilities.isCompactDevice {
            defaultTextFont = .preferredFont(forTextStyle: .footnote)   // 13pt
        } else {
            defaultTextFont = .preferredFont(forTextStyle: .body)       // 17pt
        }
#endif

        self.init(version: Settings.currentVersion,
                  imageName: nil,           // Nil imageName means it's a plain colour lock screen (background colour only)
                  imageBackgroundColor: UIColor(white: 1.0, alpha: 0),
                  imageBleedStyle: .perspective,
                  scrollScale: 1.0,
                  scrollOffset: .zero,
                  message: "",
                  textFont: defaultTextFont,
                  textStyle: .plain,
                  textAlignment: .center,
                  textColor: .white,
                  boxColor: UIColor(white: 0, alpha: 0.5),
                  boxBorderWidth: 0,
                  boxCornerRadius: 6,
                  boxInsets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12),
                  boxYCentreOffset: 0,
                  showLockScreenUI: true,
                  showWidgetPreview: true)
    }

    // All-properties initialiser
    init(version: Int,
         imageName: String?,
         imageBackgroundColor: UIColor,
         imageBleedStyle: BleedStyle,
         scrollScale: CGFloat,
         scrollOffset: CGPoint,
         message: String,
         textFont: UIFont,
         textStyle: TextStyle,
         textAlignment: NSTextAlignment,
         textColor: UIColor,
         boxColor: UIColor,
         boxBorderWidth: CGFloat,
         boxCornerRadius: CGFloat,
         boxInsets: UIEdgeInsets,
         boxYCentreOffset: CGFloat,
         showLockScreenUI: Bool,
         showWidgetPreview: Bool) {

        self.version =                  version
        self.imageName =                imageName
        self.imageBackgroundColor =     imageBackgroundColor
        self.imageBleedStyle =          imageBleedStyle
        self.scrollScale =              scrollScale
        self.scrollOffset =             scrollOffset
        self.message =                  message
        self.textFont =                 textFont
        self.textStyle =                textStyle
        self.textAlignment =            textAlignment
        self.textColor =                textColor
        self.boxColor =                 boxColor
        self.boxBorderWidth =           boxBorderWidth
        self.boxCornerRadius =          boxCornerRadius
        self.boxInsets =                boxInsets
        self.boxYCentreOffset =         boxYCentreOffset
        self.showLockScreenUI =         showLockScreenUI
        self.showWidgetPreview =        showWidgetPreview
    }

    // We have to implement encode and decode because we have some non-codable properties

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let version =               try? container.decode(Int.self, forKey: .version)
        let imageName =             try? container.decode(String.self, forKey: .imageName)
        let imageBackgroundColor =  try? container.decode(CodableColor.self, forKey: .imageBackgroundColor).toUIColor()
        let imageBleedStyle =       try? container.decode(BleedStyle.self, forKey: .imageBleedStyle)

        let scrollScale =           try? container.decode(CGFloat.self, forKey: .scrollScale)
        let scrollOffset =          try? container.decode(CGPoint.self, forKey: .scrollOffset)

        let message =               try? container.decode(String.self, forKey: .message)

        let codableTextFont =       try? container.decode(CodableFont.self, forKey: .textFont)
        let textFont =              codableTextFont?.toUIFont()
        let textStyle =             try? container.decode(TextStyle.self, forKey: .textStyle)

        var textAlignment: NSTextAlignment?
        if let rawTextAlignment =   try? container.decode(Int.self, forKey: .textAlignment) {
            textAlignment = NSTextAlignment(rawValue: rawTextAlignment)
        }

        let textColor =             try? container.decode(CodableColor.self, forKey: .textColor).toUIColor()
        let boxColor =              try? container.decode(CodableColor.self, forKey: .boxColor).toUIColor()
        let boxBorderWidth =        try? container.decode(CGFloat.self, forKey: .boxBorderWidth)
        let boxCornerRadius =       try? container.decode(CGFloat.self, forKey: .boxCornerRadius)
        let boxInsets =             try? container.decode(CodableEdgeInsets.self, forKey: .boxInsets).toUIEdgeInsets()
        let boxYCentreOffset =      try? container.decode(CGFloat.self, forKey: .boxYCentreOffset)

        // Introduced in v2.0:
        let showLockScreenUI =      try? container.decode(Bool.self, forKey: .showLockScreenUI)

        // Introduced in v3.0:
        let showWidgetPreview =     try? container.decode(Bool.self, forKey: .showWidgetPreview)


        // If any individual setting was missing, use the default value
        self.init(version: version                              ?? Settings.defaults.version,
                  imageName: imageName,                         // nil is ok
                  imageBackgroundColor: imageBackgroundColor    ?? Settings.defaults.imageBackgroundColor,
                  imageBleedStyle: imageBleedStyle              ?? Settings.defaults.imageBleedStyle,
                  scrollScale: scrollScale                      ?? Settings.defaults.scrollScale,
                  scrollOffset: scrollOffset                    ?? Settings.defaults.scrollOffset,
                  message: message                              ?? Settings.defaults.message,
                  textFont: textFont                            ?? Settings.defaults.textFont,
                  textStyle: textStyle                          ?? Settings.defaults.textStyle,
                  textAlignment: textAlignment                  ?? Settings.defaults.textAlignment,
                  textColor: textColor                          ?? Settings.defaults.textColor,
                  boxColor: boxColor                            ?? Settings.defaults.boxColor,
                  boxBorderWidth: boxBorderWidth                ?? Settings.defaults.boxBorderWidth,
                  boxCornerRadius: boxCornerRadius              ?? Settings.defaults.boxCornerRadius,
                  boxInsets: boxInsets                          ?? Settings.defaults.boxInsets,
                  boxYCentreOffset: boxYCentreOffset            ?? Settings.defaults.boxYCentreOffset,
                  showLockScreenUI: showLockScreenUI            ?? Settings.defaults.showLockScreenUI,
                  showWidgetPreview: showWidgetPreview          ?? Settings.defaults.showWidgetPreview)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.version, forKey: .version)
        try container.encode(self.imageName, forKey: .imageName)
        try container.encode(CodableColor(uiColor: self.imageBackgroundColor), forKey: .imageBackgroundColor)
        try container.encode(self.imageBleedStyle, forKey: .imageBleedStyle)
        try container.encode(self.scrollScale, forKey: .scrollScale)
        try container.encode(self.scrollOffset, forKey: .scrollOffset)
        try container.encode(self.message, forKey: .message)
        try container.encode(CodableFont(uiFont: self.textFont), forKey: .textFont)
        try container.encode(self.textStyle, forKey: .textStyle)
        try container.encode(self.textAlignment.rawValue, forKey: .textAlignment)
        try container.encode(CodableColor(uiColor: self.textColor), forKey: .textColor)
        try container.encode(CodableColor(uiColor: self.boxColor), forKey: .boxColor)
        try container.encode(self.boxBorderWidth, forKey: .boxBorderWidth)
        try container.encode(self.boxCornerRadius, forKey: .boxCornerRadius)
        try container.encode(CodableEdgeInsets(uiEdgeInsets: self.boxInsets), forKey: .boxInsets)
        try container.encode(self.boxYCentreOffset, forKey: .boxYCentreOffset)
        try container.encode(self.showLockScreenUI, forKey: .showLockScreenUI)
        try container.encode(self.showWidgetPreview, forKey: .showWidgetPreview)
    }

public func writeToUserDefaults(_ defaults: UserDefaults) throws {
        os_log("Writing settings")
        defaults.set(try PropertyListEncoder().encode(self), forKey: "AppSettings")
    }

    public static func readFromUserDefaults(_ defaults: UserDefaults) -> Settings? {

        if let data = defaults.value(forKey: "AppSettings") as? Data {
            let settings: Settings? = try? PropertyListDecoder().decode(Settings.self, from: data)
            return settings
        }

        return nil
    }
}

// Version migration
extension Settings {

    // Version history:
    // 1: - Initial release
    // 2: - Added showLockScreenUI
    // 3: - Added showWidgetPreview
    //    - Renamed Perspective Mode as Automatic Margins and turn it on for all users when upgrading.

    func updatedToCurrentVersion() -> Settings {

        guard self.version < Settings.currentVersion else {
            // Nothing to do
            return self
        }

        var updatedSettings = self

        if updatedSettings.version == 1 {
            // Ignore saved value for bleedStyle and turn it to auto/perspective when upgrading
            updatedSettings.imageBleedStyle = .perspective
        }

        if updatedSettings.version == 2 {
            // showLockScreenUI is ignored and is always on now.
            updatedSettings.showLockScreenUI = true
        }

        updatedSettings.version = Settings.currentVersion

        return updatedSettings
    }
}
