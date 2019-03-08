//
//  ResourcesTests.swift
//  LockScreenTextFrameworkTests
//
//  Created by Ben Staveley-Taylor on 31/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import XCTest
@testable import LockScreenTextFramework

class ResourcesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReadStringInDefaultTable() {

        let value = Resources.sharedInstance.localizedString("SystemFontDisplayName")
        XCTAssertEqual(value, "System Font")
    }

    func testReadStringInNamedTable() {

        let value = Resources.sharedInstance.localizedString("HelpTitle1", tableName: "Help")
        XCTAssertEqual(value, "Label your phone with Screen Label")

    }

}
