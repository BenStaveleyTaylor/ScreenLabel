//
//  Settings.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 08/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

// TODO: Add Still/Perspective
// Change to UIEdgeInsets for padding

// Data model

enum BleedStyle: Int, Codable {
    case still, perspective
}

struct Settings: Codable {

    // Default values
    static let defaults = Settings()

    // Might be useful when upgrading in future
    static let currentVersion: Int = 1

    // Immutable
    let version: Int

    // Name of the image file in the KnownDirectory.images folder
    var imageName: String?
    var imageBackgroundColour: UIColor
    var imageBleedStyle: BleedStyle

    // The text of the message
    var message: String

    var textFont: UIFont
    var textAlignment: NSTextAlignment
    var textColour: UIColor

    var boxColour: UIColor
    var boxBorderWidth: CGFloat
    var boxCornerRadius: CGFloat
    var boxInsets: UIEdgeInsets

    // Vertical centre of the box as a fracion of the image height
    // 0.0 means at the very top; 1.0 at the very bottom
    var boxYCentre: CGFloat

    // Currently everything
    private enum CodingKeys: String, CodingKey {
        case version
        case imageName
        case imageBackgroundColour
        case imageBleedStyle
        case message
        case textFont
        case textAlignment
        case textColour
        case boxColour
        case boxBorderWidth
        case boxCornerRadius
        case boxInsets
        case boxYCentre
    }

    // Set up defaults
    init() {
        self.init(version: Settings.currentVersion,
                  imageName: nil,           // Nil imageName means it's a plain colour lock screen (background colour only)
                  imageBackgroundColour: UIColor.white,
                  imageBleedStyle: .still,
                  message: NSLocalizedString("MessagePromptText", comment: ""),
                  textFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                  textAlignment: .center,
                  textColour: UIColor.white,
                  boxColour: UIColor(white: 0, alpha: 0.5),
                  boxBorderWidth: 0,
                  boxCornerRadius: 6,
                  boxInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                  boxYCentre: 0.5)          // Default is half way up
    }

    // All-properties initialiser
    init(version: Int,
         imageName: String?,
         imageBackgroundColour: UIColor,
         imageBleedStyle: BleedStyle,
         message: String,
         textFont: UIFont,
         textAlignment: NSTextAlignment,
         textColour: UIColor,
         boxColour: UIColor,
         boxBorderWidth: CGFloat,
         boxCornerRadius: CGFloat,
         boxInsets: UIEdgeInsets,
         boxYCentre: CGFloat) {

        self.version =              version
        self.imageName =            imageName
        self.imageBackgroundColour =      imageBackgroundColour
        self.imageBleedStyle =      imageBleedStyle
        self.message =              message
        self.textFont =             textFont
        self.textAlignment =        textAlignment
        self.textColour =           textColour
        self.boxColour =            boxColour
        self.boxBorderWidth =   boxBorderWidth
        self.boxCornerRadius =      boxCornerRadius
        self.boxInsets =            boxInsets
        self.boxYCentre =           boxYCentre
    }

    // We have to implement encode and decode because we have some non-codable properties

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let version =               try? container.decode(Int.self, forKey: .version)
        let imageName =             try? container.decode(String.self, forKey: .imageName)
        let imageBackgroundColour =       try? container.decode(CodableColor.self, forKey: .imageBackgroundColour).toUIColor()
        let imageBleedStyle =       try? container.decode(BleedStyle.self, forKey: .imageBleedStyle)
        let message =               try? container.decode(String.self, forKey: .message)

        let codableTextFont =       try? container.decode(CodableFont.self, forKey: .textFont)
        let textFont =              codableTextFont?.toUIFont()

        var textAlignment: NSTextAlignment?
        if let rawTextAlignment =   try? container.decode(Int.self, forKey: .textAlignment) {
            textAlignment = NSTextAlignment(rawValue: rawTextAlignment)
        }

        let textColour =            try? container.decode(CodableColor.self, forKey: .textColour).toUIColor()
        let boxColour =             try? container.decode(CodableColor.self, forKey: .boxColour).toUIColor()
        let boxBorderWidth =    try? container.decode(CGFloat.self, forKey: .boxBorderWidth)
        let boxCornerRadius =       try? container.decode(CGFloat.self, forKey: .boxCornerRadius)
        let boxInsets =             try? container.decode(CodableEdgeInsets.self, forKey: .boxInsets).toUIEdgeInsets()
        let boxYCentre =            try? container.decode(CGFloat.self, forKey: .boxYCentre)

        // If any individual setting was missing, use the default value
        self.init(version: version                          ?? Settings.defaults.version,
                  imageName: imageName,                     // nil is ok
                  imageBackgroundColour: imageBackgroundColour          ?? Settings.defaults.imageBackgroundColour,
                  imageBleedStyle: imageBleedStyle          ?? Settings.defaults.imageBleedStyle,
                  message: message                          ?? Settings.defaults.message,
                  textFont: textFont                        ?? Settings.defaults.textFont,
                  textAlignment: textAlignment              ?? Settings.defaults.textAlignment,
                  textColour: textColour                    ?? Settings.defaults.textColour,
                  boxColour: boxColour                      ?? Settings.defaults.boxColour,
                  boxBorderWidth: boxBorderWidth    ?? Settings.defaults.boxBorderWidth,
                  boxCornerRadius: boxCornerRadius          ?? Settings.defaults.boxCornerRadius,
                  boxInsets: boxInsets                      ?? Settings.defaults.boxInsets,
                  boxYCentre: boxYCentre                    ?? Settings.defaults.boxYCentre)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.version, forKey: .version)
        try container.encode(self.imageName, forKey: .imageName)
        try container.encode(CodableColor(uiColor: self.imageBackgroundColour), forKey: .imageBackgroundColour)
        try container.encode(self.imageBleedStyle, forKey: .imageBleedStyle)
        try container.encode(self.message, forKey: .message)
        try container.encode(CodableFont(uiFont: self.textFont), forKey: .textFont)
        try container.encode(self.textAlignment.rawValue, forKey: .textAlignment)
        try container.encode(CodableColor(uiColor: self.textColour), forKey: .textColour)
        try container.encode(CodableColor(uiColor: self.boxColour), forKey: .boxColour)
        try container.encode(self.boxBorderWidth, forKey: .boxBorderWidth)
        try container.encode(self.boxCornerRadius, forKey: .boxCornerRadius)
        try container.encode(CodableEdgeInsets(uiEdgeInsets: self.boxInsets), forKey: .boxInsets)
        try container.encode(self.boxYCentre, forKey: .boxYCentre)
    }

    func writeToUserDefaults() throws {
        UserDefaults.standard.set(try PropertyListEncoder().encode(self), forKey: "AppSettings")
    }

    static func readFromUserDefaults() -> Settings? {

        if let data = UserDefaults.standard.value(forKey: "AppSettings") as? Data {
            let settings: Settings? = try? PropertyListDecoder().decode(Settings.self, from: data)
            return settings
        }

        return nil
    }
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
        return UIFont(name: self.name, size: self.size)
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
