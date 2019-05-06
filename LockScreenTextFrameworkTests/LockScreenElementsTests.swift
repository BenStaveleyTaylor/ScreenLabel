//
//  LockScreenElementsTests.swift
//  LockScreenTextFrameworkTests
//
//  Created by Ben Staveley-Taylor on 05/05/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import Foundation
import XCTest
@testable import LockScreenTextFramework

class LockScreenElementsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGeometryPhoneSE() {

        let sut = LockScreenElements(screenWidthPoints: 320,
                                     screenHeightPoints: 568,
                                     isPad: false,
                                     hasPhysicalHomeButton: true)

        XCTAssertEqual(sut.timeBaseline, 140)
        XCTAssertEqual(sut.dateBaseline, 176)
        XCTAssertEqual(sut.footerBaseline, 36)

        XCTAssertFalse(sut.hasFooterIcons)
        XCTAssertTrue(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 320)
        XCTAssertEqual(sut.screenHeightPoints, 568)
        XCTAssertFalse(sut.isPad)
        XCTAssertTrue(sut.hasPhysicalHomeButton)

        XCTAssertTrue(sut.isPortrait)
        XCTAssertFalse(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 70)
        XCTAssertEqual(sut.dateFontSize, 21)
        XCTAssertEqual(sut.footerFontSize, 17)
    }

    func testGeometryPhone8() {

        let sut = LockScreenElements(screenWidthPoints: 375,
                                     screenHeightPoints: 667,
                                     isPad: false,
                                     hasPhysicalHomeButton: true)

        XCTAssertEqual(sut.timeBaseline, 140)
        XCTAssertEqual(sut.dateBaseline, 176)
        XCTAssertEqual(sut.footerBaseline, 36)

        XCTAssertFalse(sut.hasFooterIcons)
        XCTAssertTrue(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 375)
        XCTAssertEqual(sut.screenHeightPoints, 667)
        XCTAssertFalse(sut.isPad)
        XCTAssertTrue(sut.hasPhysicalHomeButton)

        XCTAssertTrue(sut.isPortrait)
        XCTAssertFalse(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 76)
        XCTAssertEqual(sut.dateFontSize, 22)
        XCTAssertEqual(sut.footerFontSize, 17)
    }

    func testGeometryPhone8Plus() {

        let sut = LockScreenElements(screenWidthPoints: 414,
                                     screenHeightPoints: 736,
                                     isPad: false,
                                     hasPhysicalHomeButton: true)

        XCTAssertEqual(sut.timeBaseline, 154)
        XCTAssertEqual(sut.dateBaseline, 190)
        XCTAssertEqual(sut.footerBaseline, 36)

        XCTAssertFalse(sut.hasFooterIcons)
        XCTAssertTrue(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 414)
        XCTAssertEqual(sut.screenHeightPoints, 736)
        XCTAssertFalse(sut.isPad)
        XCTAssertTrue(sut.hasPhysicalHomeButton)

        XCTAssertTrue(sut.isPortrait)
        XCTAssertFalse(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 90)
        XCTAssertEqual(sut.dateFontSize, 22)
        XCTAssertEqual(sut.footerFontSize, 17)
    }

    func testGeometryPhoneX_XS() {

        let sut = LockScreenElements(screenWidthPoints: 375,
                                     screenHeightPoints: 812,
                                     isPad: false,
                                     hasPhysicalHomeButton: false)

        XCTAssertEqual(sut.timeBaseline, 176)
        XCTAssertEqual(sut.dateBaseline, 212)

        XCTAssertTrue(sut.hasFooterIcons)
        XCTAssertFalse(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 375)
        XCTAssertEqual(sut.screenHeightPoints, 812)
        XCTAssertFalse(sut.isPad)
        XCTAssertFalse(sut.hasPhysicalHomeButton)

        XCTAssertTrue(sut.isPortrait)
        XCTAssertFalse(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 76)
        XCTAssertEqual(sut.dateFontSize, 22)

        XCTAssertEqual(sut.footerImageWidth, 50)
        XCTAssertEqual(sut.footerCentreYToBottomEdge, 75)
        XCTAssertEqual(sut.footerImageEdgeToCentreXInset, 71)
    }

    // The XS-Max and XR have the same screen size
    func testGeometryPhoneXSMax_XR() {

        let sut = LockScreenElements(screenWidthPoints: 414,
                                     screenHeightPoints: 896,
                                     isPad: false,
                                     hasPhysicalHomeButton: false)

        XCTAssertEqual(sut.timeBaseline, 182)
        XCTAssertEqual(sut.dateBaseline, 218)

        XCTAssertTrue(sut.hasFooterIcons)
        XCTAssertFalse(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 414)
        XCTAssertEqual(sut.screenHeightPoints, 896)
        XCTAssertFalse(sut.isPad)
        XCTAssertFalse(sut.hasPhysicalHomeButton)

        XCTAssertTrue(sut.isPortrait)
        XCTAssertFalse(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 90)
        XCTAssertEqual(sut.dateFontSize, 22)

        XCTAssertEqual(sut.footerImageWidth, 50)
        XCTAssertEqual(sut.footerCentreYToBottomEdge, 83)
        XCTAssertEqual(sut.footerImageEdgeToCentreXInset, 79)
    }

    func testGeometryPadClassic_Portrait() {

        // Original iPads; iPad Air, iPad mini...

        let sut = LockScreenElements(screenWidthPoints: 768,
                                     screenHeightPoints: 1024,
                                     isPad: true,
                                     hasPhysicalHomeButton: true)

        XCTAssertEqual(sut.timeBaseline, 166)
        XCTAssertEqual(sut.dateBaseline, 206)
        XCTAssertEqual(sut.footerBaseline, 46)

        XCTAssertFalse(sut.hasFooterIcons)
        XCTAssertTrue(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 768)
        XCTAssertEqual(sut.screenHeightPoints, 1024)
        XCTAssertTrue(sut.isPad)
        XCTAssertTrue(sut.hasPhysicalHomeButton)

        XCTAssertTrue(sut.isPortrait)
        XCTAssertFalse(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 106)
        XCTAssertEqual(sut.dateFontSize, 22)
        XCTAssertEqual(sut.footerFontSize, 17)
    }

    func testGeometryPadClassic_Landscape() {

        // Original iPads; iPad Air, iPad mini...

        let sut = LockScreenElements(screenWidthPoints: 1024,
                                     screenHeightPoints: 768,
                                     isPad: true,
                                     hasPhysicalHomeButton: true)

        XCTAssertEqual(sut.timeBaseline, 166)
        XCTAssertEqual(sut.dateBaseline, 206)
        XCTAssertEqual(sut.footerBaseline, 36)

        XCTAssertFalse(sut.hasFooterIcons)
        XCTAssertTrue(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 1024)
        XCTAssertEqual(sut.screenHeightPoints, 768)
        XCTAssertTrue(sut.isPad)
        XCTAssertTrue(sut.hasPhysicalHomeButton)

        XCTAssertFalse(sut.isPortrait)
        XCTAssertTrue(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 106)
        XCTAssertEqual(sut.dateFontSize, 22)
        XCTAssertEqual(sut.footerFontSize, 17)
    }

    func testGeometryPad10p5_Portrait() {

        let sut = LockScreenElements(screenWidthPoints: 834,
                                     screenHeightPoints: 1112,
                                     isPad: true,
                                     hasPhysicalHomeButton: true)

        XCTAssertEqual(sut.timeBaseline, 166)
        XCTAssertEqual(sut.dateBaseline, 206)
        XCTAssertEqual(sut.footerBaseline, 46)

        XCTAssertFalse(sut.hasFooterIcons)
        XCTAssertTrue(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 834)
        XCTAssertEqual(sut.screenHeightPoints, 1112)
        XCTAssertTrue(sut.isPad)
        XCTAssertTrue(sut.hasPhysicalHomeButton)

        XCTAssertTrue(sut.isPortrait)
        XCTAssertFalse(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 106)
        XCTAssertEqual(sut.dateFontSize, 22)
        XCTAssertEqual(sut.footerFontSize, 17)
    }

    func testGeometryPad10p5_Landscape() {

        let sut = LockScreenElements(screenWidthPoints: 1112,
                                     screenHeightPoints: 834,
                                     isPad: true,
                                     hasPhysicalHomeButton: true)

        XCTAssertEqual(sut.timeBaseline, 166)
        XCTAssertEqual(sut.dateBaseline, 206)
        XCTAssertEqual(sut.footerBaseline, 36)

        XCTAssertFalse(sut.hasFooterIcons)
        XCTAssertTrue(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 1112)
        XCTAssertEqual(sut.screenHeightPoints, 834)
        XCTAssertTrue(sut.isPad)
        XCTAssertTrue(sut.hasPhysicalHomeButton)

        XCTAssertFalse(sut.isPortrait)
        XCTAssertTrue(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 106)
        XCTAssertEqual(sut.dateFontSize, 22)
        XCTAssertEqual(sut.footerFontSize, 17)
    }

    func testGeometryPad11_Portrait() {

        let sut = LockScreenElements(screenWidthPoints: 834,
                                     screenHeightPoints: 1194,
                                     isPad: true,
                                     hasPhysicalHomeButton: false)

        XCTAssertEqual(sut.timeBaseline, 170)
        XCTAssertEqual(sut.dateBaseline, 210)
        XCTAssertEqual(sut.footerBaseline, 46)

        XCTAssertFalse(sut.hasFooterIcons)
        XCTAssertFalse(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 834)
        XCTAssertEqual(sut.screenHeightPoints, 1194)
        XCTAssertTrue(sut.isPad)
        XCTAssertFalse(sut.hasPhysicalHomeButton)

        XCTAssertTrue(sut.isPortrait)
        XCTAssertFalse(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 106)
        XCTAssertEqual(sut.dateFontSize, 22)

        XCTAssertEqual(sut.footerImageWidth, 50)
        XCTAssertEqual(sut.footerCentreYToBottomEdge, 83)
        XCTAssertEqual(sut.footerImageEdgeToCentreXInset, 79)
    }

    func testGeometryPad11_Landscape() {

        let sut = LockScreenElements(screenWidthPoints: 1194,
                                     screenHeightPoints: 834,
                                     isPad: true,
                                     hasPhysicalHomeButton: false)

        XCTAssertEqual(sut.timeBaseline, 170)
        XCTAssertEqual(sut.dateBaseline, 210)
        XCTAssertEqual(sut.footerBaseline, 36)

        XCTAssertFalse(sut.hasFooterIcons)
        XCTAssertFalse(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 1194)
        XCTAssertEqual(sut.screenHeightPoints, 834)
        XCTAssertTrue(sut.isPad)
        XCTAssertFalse(sut.hasPhysicalHomeButton)

        XCTAssertFalse(sut.isPortrait)
        XCTAssertTrue(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 106)
        XCTAssertEqual(sut.dateFontSize, 22)

        XCTAssertEqual(sut.footerImageWidth, 50)
        XCTAssertEqual(sut.footerCentreYToBottomEdge, 83)
        XCTAssertEqual(sut.footerImageEdgeToCentreXInset, 79)
    }

    func testGeometryPad12p9_Portrait() {

        let sut = LockScreenElements(screenWidthPoints: 1024,
                                     screenHeightPoints: 1366,
                                     isPad: true,
                                     hasPhysicalHomeButton: false)

        XCTAssertEqual(sut.timeBaseline, 196)
        XCTAssertEqual(sut.dateBaseline, 242)
        XCTAssertEqual(sut.footerBaseline, 46)

        XCTAssertFalse(sut.hasFooterIcons)
        XCTAssertFalse(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 1024)
        XCTAssertEqual(sut.screenHeightPoints, 1366)
        XCTAssertTrue(sut.isPad)
        XCTAssertFalse(sut.hasPhysicalHomeButton)

        XCTAssertTrue(sut.isPortrait)
        XCTAssertFalse(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 116)
        XCTAssertEqual(sut.dateFontSize, 22)

        XCTAssertEqual(sut.footerImageWidth, 50)
        XCTAssertEqual(sut.footerCentreYToBottomEdge, 83)
        XCTAssertEqual(sut.footerImageEdgeToCentreXInset, 79)
    }

    func testGeometryPad12p9_Landscape() {

        let sut = LockScreenElements(screenWidthPoints: 1366,
                                     screenHeightPoints: 1024,
                                     isPad: true,
                                     hasPhysicalHomeButton: false)

        XCTAssertEqual(sut.timeBaseline, 196)
        XCTAssertEqual(sut.dateBaseline, 242)
        XCTAssertEqual(sut.footerBaseline, 36)

        XCTAssertFalse(sut.hasFooterIcons)
        XCTAssertFalse(sut.hasFooterText)

        XCTAssertEqual(sut.screenWidthPoints, 1366)
        XCTAssertEqual(sut.screenHeightPoints, 1024)
        XCTAssertTrue(sut.isPad)
        XCTAssertFalse(sut.hasPhysicalHomeButton)

        XCTAssertFalse(sut.isPortrait)
        XCTAssertTrue(sut.isLandscape)

        XCTAssertEqual(sut.timeFontSize, 116)
        XCTAssertEqual(sut.dateFontSize, 22)

        XCTAssertEqual(sut.footerImageWidth, 50)
        XCTAssertEqual(sut.footerCentreYToBottomEdge, 83)
        XCTAssertEqual(sut.footerImageEdgeToCentreXInset, 79)
    }

   func testDateTextGB() {

        let sut = LockScreenElements()

        // 17th May. Midday to be safe.
        let dateComponents = DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: 2019, month: 5, day: 17, hour: 12)
        let date = Calendar.current.date(from: dateComponents)
        let dateText = sut.dateText(at: date!, locale: Locale(identifier: "en_GB"))

        XCTAssertEqual(dateText, "Friday 17 May")
    }

    func testDateTextUS() {

        let sut = LockScreenElements()

        // 17th May. Midday to be safe.
        let dateComponents = DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: 2019, month: 5, day: 17, hour: 12)
        let date = Calendar.current.date(from: dateComponents)
        let dateText = sut.dateText(at: date!, locale: Locale(identifier: "en_US"))

        XCTAssertEqual(dateText, "Friday, May 17")
    }

    func testTimeTextGB() {

        let sut = LockScreenElements()

        // 12.34. In December to avoid summertime issues.
        let dateComponents = DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: 2019, month: 12, hour: 13, minute: 34)
        let date = Calendar.current.date(from: dateComponents)
        let dateText = sut.timeText(at: date!, locale: Locale(identifier: "en_GB"))

        XCTAssertEqual(dateText, "13:34")
    }

    func testTimeTextUS() {

        let sut = LockScreenElements()

        // 12.34. In Decmber to avoid summertime issues.
        let dateComponents = DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: 2019, month: 12, hour: 13, minute: 34)
        let date = Calendar.current.date(from: dateComponents)
        let dateText = sut.timeText(at: date!, locale: Locale(identifier: "en_US"))

        XCTAssertEqual(dateText, "1:34")
    }
}
