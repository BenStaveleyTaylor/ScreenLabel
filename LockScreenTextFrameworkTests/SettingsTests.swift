//
//  SettingsTests.swift
//  LockScreenTextTests
//
//  Created by Ben Staveley-Taylor on 08/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import XCTest
@testable import LockScreenTextFramework

class SettingsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEncoding() {

        guard let testFont = UIFont(name: "Helvetica", size: 10) else {
            XCTFail("Failed to create test font")
            return
        }

        // Create a settings object
        let settings = Settings(version: 2,
                                imageName: "Total Perspective Vortex",
                                imageBackgroundColor: UIColor.red,
                                imageBleedStyle: BleedStyle.perspective,
                                scrollScale: 2.0,
                                scrollOffset: CGPoint(x: 123, y: 456),
                                message: "Expect the unexpected",
                                textFont: testFont,
                                textStyle: .boldItalic,
                                textAlignment: .right,
                                textColor: UIColor.green,
                                boxColor: UIColor.blue,
                                boxBorderWidth: 0.5,
                                boxCornerRadius: 10,
                                boxInsets: UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
                                boxYCentreOffset: 0.75,
                                showLockScreenUI: true)

        // Encode it
        let encoder = PropertyListEncoder()
        let data = try? encoder.encode(settings)
        XCTAssertNotNil(data)

        // Decode it again
        let decoder = PropertyListDecoder()
        let checkSettings = try? decoder.decode(Settings.self, from: data!)
        XCTAssertNotNil(checkSettings)

        // Verify it is the same as the original
        XCTAssertEqual(settings.version, checkSettings!.version)
        XCTAssertEqual(settings.imageName, checkSettings!.imageName)
        XCTAssertEqual(settings.imageBackgroundColor, checkSettings!.imageBackgroundColor)
        XCTAssertEqual(settings.imageBleedStyle, checkSettings!.imageBleedStyle)
        XCTAssertEqual(settings.scrollScale, checkSettings!.scrollScale)
        XCTAssertEqual(settings.scrollOffset, checkSettings!.scrollOffset)
        XCTAssertEqual(settings.message, checkSettings!.message)
        XCTAssertEqual(settings.textFont, checkSettings!.textFont)
        XCTAssertEqual(settings.textFont, checkSettings!.textFont)
        XCTAssertEqual(settings.textStyle, checkSettings!.textStyle)
        XCTAssertEqual(settings.textColor, checkSettings!.textColor)
        XCTAssertEqual(settings.boxColor, checkSettings!.boxColor)
        XCTAssertEqual(settings.boxBorderWidth, checkSettings!.boxBorderWidth)
        XCTAssertEqual(settings.boxCornerRadius, checkSettings!.boxCornerRadius)
        XCTAssertEqual(settings.boxInsets, checkSettings!.boxInsets)
        XCTAssertEqual(settings.boxYCentreOffset, checkSettings!.boxYCentreOffset)
        XCTAssertEqual(settings.showLockScreenUI, checkSettings!.showLockScreenUI)
    }

    func testMigrateV1toV2() {

        guard let testFont = UIFont(name: "Helvetica", size: 10) else {
            XCTFail("Failed to create test font")
            return
        }

        let settingsV1 = Settings(version: 1,
                                imageName: "Total Perspective Vortex",
                                imageBackgroundColor: .red,
                                imageBleedStyle: .still,
                                scrollScale: 2.0,
                                scrollOffset: CGPoint(x: 123, y: 456),
                                message: "Expect the unexpected",
                                textFont: testFont,
                                textStyle: .boldItalic,
                                textAlignment: .right,
                                textColor: .green,
                                boxColor: .blue,
                                boxBorderWidth: 0.5,
                                boxCornerRadius: 10,
                                boxInsets: UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
                                boxYCentreOffset: 0.75,
                                showLockScreenUI: true)

        let settingsV2 = settingsV1.updatedToCurrentVersion()

        // Verify intentional changes
        XCTAssertEqual(settingsV2.version, 2)
        XCTAssertEqual(settingsV2.imageBleedStyle, .perspective)

        // Verify everything else is unchanges changes
        XCTAssertEqual(settingsV2.imageName, settingsV1.imageName)
        XCTAssertEqual(settingsV2.imageBackgroundColor, settingsV1.imageBackgroundColor)
        XCTAssertEqual(settingsV2.scrollScale, settingsV1.scrollScale)
        XCTAssertEqual(settingsV2.scrollOffset, settingsV1.scrollOffset)
        XCTAssertEqual(settingsV2.message, settingsV1.message)
        XCTAssertEqual(settingsV2.textFont, settingsV1.textFont)
        XCTAssertEqual(settingsV2.textFont, settingsV1.textFont)
        XCTAssertEqual(settingsV2.textStyle, settingsV1.textStyle)
        XCTAssertEqual(settingsV2.textColor, settingsV1.textColor)
        XCTAssertEqual(settingsV2.boxColor, settingsV1.boxColor)
        XCTAssertEqual(settingsV2.boxBorderWidth, settingsV1.boxBorderWidth)
        XCTAssertEqual(settingsV2.boxCornerRadius, settingsV1.boxCornerRadius)
        XCTAssertEqual(settingsV2.boxInsets, settingsV1.boxInsets)
        XCTAssertEqual(settingsV2.boxYCentreOffset, settingsV1.boxYCentreOffset)
        XCTAssertEqual(settingsV2.showLockScreenUI, settingsV1.showLockScreenUI)
   }

    func testMigrateV2toV2IsNoOp() {

        guard let testFont = UIFont(name: "Helvetica", size: 10) else {
            XCTFail("Failed to create test font")
            return
        }

        let settingsV1 = Settings(version: 2,
                                  imageName: "Total Perspective Vortex",
                                  imageBackgroundColor: .red,
                                  imageBleedStyle: .still,
                                  scrollScale: 2.0,
                                  scrollOffset: CGPoint(x: 123, y: 456),
                                  message: "Expect the unexpected",
                                  textFont: testFont,
                                  textStyle: .boldItalic,
                                  textAlignment: .right,
                                  textColor: .green,
                                  boxColor: .blue,
                                  boxBorderWidth: 0.5,
                                  boxCornerRadius: 10,
                                  boxInsets: UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
                                  boxYCentreOffset: 0.75,
                                  showLockScreenUI: true)

        let settingsV2 = settingsV1.updatedToCurrentVersion()

        // Verify migratable fields are unchanged
        XCTAssertEqual(settingsV2.version, settingsV1.version)
        XCTAssertEqual(settingsV2.imageBleedStyle, settingsV1.imageBleedStyle)

        // Verify everything else is unchanges changes
        XCTAssertEqual(settingsV2.imageName, settingsV1.imageName)
        XCTAssertEqual(settingsV2.imageBackgroundColor, settingsV1.imageBackgroundColor)
        XCTAssertEqual(settingsV2.scrollScale, settingsV1.scrollScale)
        XCTAssertEqual(settingsV2.scrollOffset, settingsV1.scrollOffset)
        XCTAssertEqual(settingsV2.message, settingsV1.message)
        XCTAssertEqual(settingsV2.textFont, settingsV1.textFont)
        XCTAssertEqual(settingsV2.textFont, settingsV1.textFont)
        XCTAssertEqual(settingsV2.textStyle, settingsV1.textStyle)
        XCTAssertEqual(settingsV2.textColor, settingsV1.textColor)
        XCTAssertEqual(settingsV2.boxColor, settingsV1.boxColor)
        XCTAssertEqual(settingsV2.boxBorderWidth, settingsV1.boxBorderWidth)
        XCTAssertEqual(settingsV2.boxCornerRadius, settingsV1.boxCornerRadius)
        XCTAssertEqual(settingsV2.boxInsets, settingsV1.boxInsets)
        XCTAssertEqual(settingsV2.boxYCentreOffset, settingsV1.boxYCentreOffset)
        XCTAssertEqual(settingsV2.showLockScreenUI, settingsV1.showLockScreenUI)
    }
}
