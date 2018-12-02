//
//  QuantizedSliderTests.swift
//  LockScreenTextFrameworkTests
//
//  Created by Ben Staveley-Taylor on 02/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import XCTest
@testable import LockScreenTextFramework

class QuantizedSliderTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValueToStep() {

        let testSlider = FibonacciSlider(frame: CGRect.zero)
        // So testSlider's value range is from 0 to 9

        testSlider.value = 0
        XCTAssertEqual(testSlider.stepValue, 1)

        testSlider.value = 9
        XCTAssertEqual(testSlider.stepValue, 89)

        testSlider.value = 5
        XCTAssertEqual(testSlider.stepValue, 13)

        // Test fractional value rounding

        testSlider.value = 7.4
        XCTAssertEqual(testSlider.stepValue, 34)

        testSlider.value = 7.6
        XCTAssertEqual(testSlider.stepValue, 55)
    }

    func testStepToValue() {

        let testSlider = FibonacciSlider(frame: CGRect.zero)
        // So testSlider's value range is from 0 to 9

        testSlider.stepValue = 1
        XCTAssertEqual(testSlider.value, 0)

        testSlider.stepValue = 89
        XCTAssertEqual(testSlider.value, 9)

        testSlider.stepValue = 13
        XCTAssertEqual(testSlider.value, 5)

        // Test out of range doesn't crash

        testSlider.stepValue = 0
        XCTAssertEqual(testSlider.value, 0)

        testSlider.stepValue = 50
        XCTAssertEqual(testSlider.value, 8) // == value for next biggest, 55

        testSlider.stepValue = 1234
        XCTAssertEqual(testSlider.value, 9)
    }

}

// Helper class

class FibonacciSlider: QuantizedSlider {

    override var steps: [Int] {

        // First 10 Fibonacci numbers
        return [1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
    }
}
