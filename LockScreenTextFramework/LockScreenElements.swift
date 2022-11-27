//
//  LockScreenElements.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 27/04/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

// The layout numbers are calculated by screen size not device name
// because I'm not 100% confident of the UIDevice name reliability
// on simulators, and also I want to handle unknown new devices in a
// reasonable way.

public struct LockScreenElements {

    public var timeBaseline: CGFloat = 0
    public var dateBaseline: CGFloat = 0
    public var footerBaseline: CGFloat = 0

    public var hasFooterText: Bool
    public var hasFooterIcons: Bool

    internal let screenWidthPoints: CGFloat
    internal let screenHeightPoints: CGFloat
    internal let isPad: Bool
    internal let hasPhysicalHomeButton: Bool

    internal var isPortrait: Bool {
        return self.screenHeightPoints > self.screenWidthPoints
    }
    internal var isLandscape: Bool {
        return !self.isPortrait
    }

    // Initialise for a particular device size (in points, not native pixels)
    init(screenWidthPoints: CGFloat, screenHeightPoints: CGFloat, isPad: Bool, hasPhysicalHomeButton: Bool) {
        self.screenWidthPoints = screenWidthPoints
        self.screenHeightPoints = screenHeightPoints
        self.isPad = isPad
        self.hasPhysicalHomeButton = hasPhysicalHomeButton

        // Calculate derived values
        self.hasFooterText = hasPhysicalHomeButton
        self.hasFooterIcons = !hasPhysicalHomeButton && !isPad

        self.setTopRelativeBaselines()
        self.setBottomRelativeBaselines()
    }

    // Initialise for the current device
    init() {
        let screen = UIScreen.main
        let device = UIDevice.current

        // If there's no safe area footer, it must be a physical Home button
        let safeAreaBottomHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
        let hasPhysicalHomeButton = (safeAreaBottomHeight == 0)

        self.init(screenWidthPoints: screen.bounds.width,
                  screenHeightPoints: screen.bounds.height,
                  isPad: device.userInterfaceIdiom == .pad,
                  hasPhysicalHomeButton: hasPhysicalHomeButton)
    }

    public var timeFontSize: CGFloat {

        let size: CGFloat

        // The device WIDTH seems to be the best discriminator

        if isPad {
            switch self.screenPortraitWidth {
            case 0...834:
                // iPad classic, 10.5", 11"
                size = 103

            default:
                // iPad 12.9" or unknown future model
                size = 112
            }
        } else {
            // iPhone sizes
            switch self.screenPortraitWidth {
            case 0...320:
                // iPhone SE original
                size = 70

            case 321...375:
                // iPhone 6/7/8; X/XS; SE 3rd Gen
                size = 82

            case 376...393:
                // iPhone 12/13/14; Phone 14 Pro
                size = 96

            default:
                // iPhone 11; XS Max; 8 Plus; 14 Plus/Pro Max
                // or unknown future model
                size = 102
            }
        }

        return size
    }

    public var timeFont: UIFont {
        return UIFont.systemFont(ofSize: self.timeFontSize, weight: .semibold)
    }

    // HH:MM of real current time
    public func timeText(at date: Date = Date(), locale: Locale? = nil) -> String {

        let locale = locale ?? Locale.current

        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.setLocalizedDateFormatFromTemplate("Jmm")
        return formatter.string(from: date)
    }

    public var dateFontSize: CGFloat {

        let size: CGFloat

        if isPad {
            // Same for all models
            size = 22
        } else {
            // iPhone sizes
            switch self.screenPortraitWidth {
            case 0...320:
                // iPhone SE
                size = 21

            default:
                // iPhone 6/7/8; X/XS; 6/7/8 Plus; XS-Max; XR
                // or unknown future model
                size = 22
            }
        }

        return size
    }

    public var dateFont: UIFont {
        return UIFont.systemFont(ofSize: self.dateFontSize, weight: .medium)
    }

    public func dateText(at date: Date = Date(), locale: Locale? = nil) -> String {

        let locale = locale ?? Locale.current

        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.setLocalizedDateFormatFromTemplate("EEEEMMMMd")
        return formatter.string(from: date)
    }

    public var footerFontSize: CGFloat {
        // Same for all models
        return 17
    }

    public var footerFont: UIFont {
        return UIFont.systemFont(ofSize: self.footerFontSize, weight: .semibold)
    }

    // "Press home to open" text on some models. Check .hasFooterText before use.
    public var footerText: String {
       return Resources.sharedInstance.localizedString("PressHomeToOpen")
    }

    public var footerImageWidth: CGFloat {
        // The XR actually uses a 56pt icon but life's too short.
        // The XR has the exact same screen size as the XS-Max so it breaks my
        // size-only-based decision making. Just go with the general case.
        return 50
    }

    public var footerCentreYToBottomEdge: CGFloat {

        let offset: CGFloat

        switch self.screenPortraitHeight {
        case 0...812:
            // iPhone X, XS
            offset = 75

        default:
            // iPhone XS-Max, XR; iPads
            // or unknown future model
            offset = 83
        }

        return offset
    }

    public var footerImageEdgeToCentreXInset: CGFloat {

        let offset: CGFloat

        switch self.screenPortraitHeight {
        case 0...812:
            // iPhone X, XS
            offset = 71

        default:
            // iPhone XS-Max, XR; iPads
            // or unknown future model
            offset = 79
        }

        return offset
    }

    // MARK: Private

    // Avoid portrait/landscape issues -- get the dimension for Portrait mode
    private var screenPortraitHeight: CGFloat {
        return max(self.screenWidthPoints, self.screenHeightPoints)
    }

    private var screenPortraitWidth: CGFloat {
        return min(self.screenWidthPoints, self.screenHeightPoints)
    }

    // V-position of the text baselines from the top of the screen
    private mutating func setTopRelativeBaselines() {

        let timePos: CGFloat
        let datePos: CGFloat

        // The device HEIGHT seems to be the best discriminator

        if isPad {
            switch self.screenPortraitHeight {
            case 0...1194:
                // iPad 11"
                timePos = 210
                datePos = 170

            default:
                // iPad 12.9" or unknown future model
                timePos = 234
                datePos = 129
            }
        } else {
            // iPhone sizes
            switch self.screenPortraitHeight {
            case 0...568:
                // iPhone SE (original; doesn't support iOS 16, so theoretical)
                timePos = 135
                datePos = 60

            case 569...667:
                // iPhone SE (new)
                timePos = 154
                datePos = 71

            case 668...844:
                // iPhone 14
                timePos = 201
                datePos = 108

            case 845...852:
                // iPhone 14 Pro
                timePos = 215
                datePos = 117

            default:
                // iPhone 14 Plus, Pro Max
                // or unknown future model
                timePos = 221
                datePos = 122
            }
        }

        self.timeBaseline = timePos
        self.dateBaseline = datePos
    }

    // V-position of the text baselines from the bottom of the screen
    private mutating func setBottomRelativeBaselines() {

        let footerPos: CGFloat

        // iPads in portrait use 46; all other cases are 36
        if self.isPad && self.isPortrait {
            footerPos = 46
        } else {
            footerPos = 36
        }

        self.footerBaseline = footerPos
    }
}
