//
//  SettingsTests.swift
//  LockScreenTextTests
//
//  Created by Ben Staveley-Taylor on 08/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import XCTest
@testable import LockScreenText

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
                                imageBackground: UIColor.red,
                                message: "Expect the unexpected",
                                textFont: testFont,
                                textAlignment: .right,
                                textColour: UIColor.green,
                                boxColour: UIColor.blue,
                                boxBorderThickness: 0.5,
                                boxCornerRadius: 10,
                                boxHorizontalPadding: 15,
                                boxVerticalPadding: 20,
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
        XCTAssertEqual(settings.imageBackground, checkSettings!.imageBackground)
        XCTAssertEqual(settings.message, checkSettings!.message)
        XCTAssertEqual(settings.textFont, checkSettings!.textFont)
        XCTAssertEqual(settings.textAlignment, checkSettings!.textAlignment)
        XCTAssertEqual(settings.textColour, checkSettings!.textColour)
        XCTAssertEqual(settings.boxColour, checkSettings!.boxColour)
        XCTAssertEqual(settings.boxBorderThickness, checkSettings!.boxBorderThickness)
        XCTAssertEqual(settings.boxCornerRadius, checkSettings!.boxCornerRadius)
        XCTAssertEqual(settings.boxHorizontalPadding, checkSettings!.boxHorizontalPadding)
        XCTAssertEqual(settings.boxVerticalPadding, checkSettings!.boxVerticalPadding)
        XCTAssertEqual(settings.boxYCentre, checkSettings!.boxYCentre)
    }
}
