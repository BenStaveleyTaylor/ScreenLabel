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
                                message: "Expect the unexpected",
                                textFont: testFont,
                                textAlignment: .right,
                                textColor: UIColor.green,
                                boxColor: UIColor.blue,
                                boxBorderWidth: 0.5,
                                boxCornerRadius: 10,
                                boxInsets: UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
                                boxYCentre: 0.75)

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
        XCTAssertEqual(settings.message, checkSettings!.message)
        XCTAssertEqual(settings.textFont, checkSettings!.textFont)
        XCTAssertEqual(settings.textAlignment, checkSettings!.textAlignment)
        XCTAssertEqual(settings.textColor, checkSettings!.textColor)
        XCTAssertEqual(settings.boxColor, checkSettings!.boxColor)
        XCTAssertEqual(settings.boxBorderWidth, checkSettings!.boxBorderWidth)
        XCTAssertEqual(settings.boxCornerRadius, checkSettings!.boxCornerRadius)
        XCTAssertEqual(settings.boxInsets, checkSettings!.boxInsets)
        XCTAssertEqual(settings.boxYCentre, checkSettings!.boxYCentre)
    }
}
