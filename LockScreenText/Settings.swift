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

struct Settings: Codable {

    // Might be useful when upgrading in future
    static let currentVersion: Int = 1

    // Immutable
    let version: Int

    // Name of the image file in the KnownDirectory.images folder
    var imageName: String?
    var imageBackground: UIColor

    // The text of the message
    var message: String

    var textFont: UIFont
    var textAlignment: NSTextAlignment
    var textColour: UIColor

    var boxColour: UIColor
    var boxBorderThickness: CGFloat
    var boxCornerRadius: CGFloat

    // Left/Right insets
    var boxHorizontalPadding: CGFloat
    // Top/Bottom insets
    var boxVerticalPadding: CGFloat

    // Vertical centre of the box as a fracion of the image height
    // 0.0 means at the very top; 1.0 at the very bottom
    var boxYCentre: CGFloat

    // Currently everything
    private enum CodingKeys: String, CodingKey {
        case version
        case imageName
        case imageBackground
        case message
        case textFont
        case textAlignment
        case textColour
        case boxColour
        case boxBorderThickness
        case boxCornerRadius
        case boxHorizontalPadding
        case boxVerticalPadding
        case boxYCentre
    }

    // Set up defaults
    init() {
        self.init(version: Settings.currentVersion,
                  imageName: nil,           // Nil imageName means it's a plain colour lock screen (background colour only)
                  imageBackground: UIColor.white,
                  message: NSLocalizedString("MessagePromptText", comment: ""),
                  textFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                  textAlignment: .center,
                  textColour: UIColor.white,
                  boxColour: UIColor(white: 0, alpha: 0.5),
                  boxBorderThickness: 0,
                  boxCornerRadius: 6,
                  boxHorizontalPadding: 20,
                  boxVerticalPadding: 20,
                  boxYCentre: 0.5)          // Default is half way up
    }

    // All-properties initialiser
    init(version: Int,
         imageName: String?,
         imageBackground: UIColor,
         message: String,
         textFont: UIFont,
         textAlignment: NSTextAlignment,
         textColour: UIColor,
         boxColour: UIColor,
         boxBorderThickness: CGFloat,
         boxCornerRadius: CGFloat,
         boxHorizontalPadding: CGFloat,
         boxVerticalPadding: CGFloat,
         boxYCentre: CGFloat) {

        self.version =              version
        self.imageName =            imageName
        self.imageBackground =      imageBackground
        self.message =              message
        self.textFont =             textFont
        self.textAlignment =        textAlignment
        self.textColour =           textColour
        self.boxColour =            boxColour
        self.boxBorderThickness =   boxBorderThickness
        self.boxCornerRadius =      boxCornerRadius
        self.boxHorizontalPadding = boxHorizontalPadding
        self.boxVerticalPadding =   boxVerticalPadding
        self.boxYCentre =           boxYCentre
    }

    // We have to implement encode and decode because we have some non-codable properties

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let version =               try container.decode(Int.self, forKey: .version)
        let imageName =             try container.decode(String.self, forKey: .imageName)
        let imageBackground =       try container.decode(CodableColor.self, forKey: .imageBackground).toUIColor()
        let message =               try container.decode(String.self, forKey: .message)
        let textFont =              try container.decode(CodableFont.self, forKey: .textFont).toUIFont()
        let textAlignment =         try NSTextAlignment(rawValue: container.decode(Int.self, forKey: .textAlignment))
        let textColour =            try container.decode(CodableColor.self, forKey: .textColour).toUIColor()
        let boxColour =             try container.decode(CodableColor.self, forKey: .boxColour).toUIColor()
        let boxBorderThickness =    try container.decode(CGFloat.self, forKey: .boxBorderThickness)
        let boxCornerRadius =       try container.decode(CGFloat.self, forKey: .boxCornerRadius)
        let boxHorizontalPadding =  try container.decode(CGFloat.self, forKey: .boxHorizontalPadding)
        let boxVerticalPadding =    try container.decode(CGFloat.self, forKey: .boxVerticalPadding)
        let boxYCentre =            try container.decode(CGFloat.self, forKey: .boxYCentre)

        self.init(version: version,
                  imageName: imageName,
                  imageBackground: imageBackground,
                  message: message,
                  textFont: textFont ?? UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                  textAlignment: textAlignment ?? .center,
                  textColour: textColour,
                  boxColour: boxColour,
                  boxBorderThickness: boxBorderThickness,
                  boxCornerRadius: boxCornerRadius,
                  boxHorizontalPadding: boxHorizontalPadding,
                  boxVerticalPadding: boxVerticalPadding,
                  boxYCentre: boxYCentre)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.version, forKey: .version)
        try container.encode(self.imageName, forKey: .imageName)
        try container.encode(CodableColor(uiColor: self.imageBackground), forKey: .imageBackground)
        try container.encode(self.message, forKey: .message)
        try container.encode(CodableFont(uiFont: self.textFont), forKey: .textFont)
        try container.encode(self.textAlignment.rawValue, forKey: .textAlignment)
        try container.encode(CodableColor(uiColor: self.textColour), forKey: .textColour)
        try container.encode(CodableColor(uiColor: self.boxColour), forKey: .boxColour)
        try container.encode(self.boxBorderThickness, forKey: .boxBorderThickness)
        try container.encode(self.boxCornerRadius, forKey: .boxCornerRadius)
        try container.encode(self.boxHorizontalPadding, forKey: .boxHorizontalPadding)
        try container.encode(self.boxVerticalPadding, forKey: .boxVerticalPadding)
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
