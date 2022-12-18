//
//  LockScreenElements.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 29/11/2022.
//  Copyright © 2022 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

// Layout geometry of the lock screen page elements
protocol LockScreenElementsProtocol {

    var timeBaseline: CGFloat { get }
    var dateBaseline: CGFloat { get }
    var footerBaseline: CGFloat { get }

    var hasFooterText: Bool { get }
    var hasFooterIcons: Bool { get }

    var timeFontSize: CGFloat { get }
    var timeFont: UIFont { get }

    func timeText(at date: Date, locale: Locale?) -> String

    var dateFontSize: CGFloat { get }
    var dateFont: UIFont { get }

    func dateText(at date: Date, locale: Locale?) -> String

    var footerFontSize: CGFloat { get }
    var footerFont: UIFont { get }
    var footerText: String { get }
    var footerImageWidth: CGFloat { get }
    var footerCentreYToBottomEdge: CGFloat { get }
    var footerImageEdgeToCentreXInset: CGFloat { get }

    // iOS 16+ only; phone only
    var hasWidget: Bool { get }
    var widgetRect: CGRect { get }
}

enum LockScreenElements {

    // Factory method to pick the right geometry for the iOS version
    static func create() -> LockScreenElementsProtocol {
        if #available(iOS 16, *) {
            return LockScreenElementsIos16()
        } else {
            return LockScreenElementsPreIos16()
        }
    }
}

// Default arguments syntactic sugar
extension LockScreenElementsProtocol {
    func timeText(at date: Date = Date(), locale: Locale? = nil) -> String {
        return timeText(at: date, locale: locale)
    }

    func dateText(at date: Date = Date(), locale: Locale? = nil) -> String {
        return dateText(at: date, locale: locale)
    }
}
