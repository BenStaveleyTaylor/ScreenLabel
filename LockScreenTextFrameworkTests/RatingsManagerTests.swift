//
//  RatingsManagerTests.swift
//  LockScreenTextFrameworkTests
//
//  Created by Ben Staveley-Taylor on 09/03/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import XCTest
@testable import LockScreenTextFramework

class RatingsManagerTests: XCTestCase {

    override func setUp() {
        // Delete all defaults
        self.resetDefaults()
    }

    override func tearDown() {
        // Delete all defaults
        self.resetDefaults()
    }

    func testInit() {

        let ratingsManager = RatingsManager()

        XCTAssertEqual(ratingsManager.getSavesSinceLastPrompt(), 0)

        let lastPromptDate = ratingsManager.getLastPromptDate()
        XCTAssertNotNil(lastPromptDate)

        // Initial date should be now  -- let's say to within 0.1 sec
        let now = Date()
        let delta = now.timeIntervalSince(lastPromptDate!)
        XCTAssertGreaterThanOrEqual(delta, 0)
        XCTAssertLessThan(delta, 0.1)
   }

    func testSaveCounter() {

        let ratingsManager = RatingsManager()

        ratingsManager.didSaveSettings()
        XCTAssertEqual(ratingsManager.getSavesSinceLastPrompt(), 1)

        ratingsManager.didSaveSettings()
        XCTAssertEqual(ratingsManager.getSavesSinceLastPrompt(), 2)
    }

    func testSaveThreshold() {

        // Expect a prompt after 3 saves
        let ratingsManager = RatingsManager(numSavesThreshold: 3,
                                            elapsedTimeMinThreshold: 0)

        ratingsManager.didSaveSettings()
        ratingsManager.didSaveSettings()
        XCTAssertEqual(ratingsManager.getSavesSinceLastPrompt(), 2)

        ratingsManager.didSaveSettings()
        // Count should have been reset
        XCTAssertEqual(ratingsManager.getSavesSinceLastPrompt(), 0)
    }

    func testElapsedTimeMinThreshold() {

        // No prompt until minimum time has elapsed
        let ratingsManager = RatingsManager(numSavesThreshold: 3,
                                            elapsedTimeMinThreshold: 2)

        ratingsManager.didSaveSettings()
        ratingsManager.didSaveSettings()
        ratingsManager.didSaveSettings()

        // Even though 3 saved should trigger a prompt, nothing yet
        XCTAssertEqual(ratingsManager.getSavesSinceLastPrompt(), 3)

        // Wait 3 seconds
        Thread.sleep(forTimeInterval: 2)

        // Next save should prompt and reset counters
        ratingsManager.didSaveSettings()
        XCTAssertEqual(ratingsManager.getSavesSinceLastPrompt(), 0)

        let now = Date()
        let lastPromptDate = ratingsManager.getLastPromptDate()

        // These should be "the same" -- let's say to within 0.1 sec
        let delta = now.timeIntervalSince(lastPromptDate!)
        XCTAssertGreaterThanOrEqual(delta, 0)
        XCTAssertLessThan(delta, 0.1)
    }

    func testElapsedTimeMaxThreshold() {

        // Expect a prompt if saving more than 1 second after the last save
        let ratingsManager = RatingsManager(elapsedTimeMaxThreshold: 1)

        ratingsManager.didSaveSettings()
        ratingsManager.didSaveSettings()
        XCTAssertEqual(ratingsManager.getSavesSinceLastPrompt(), 2)

        // Wait 2 seconds
        Thread.sleep(forTimeInterval: 2)

        // Next save should prompt and reset counters
        ratingsManager.didSaveSettings()
        XCTAssertEqual(ratingsManager.getSavesSinceLastPrompt(), 0)

        let now = Date()
        let lastPromptDate = ratingsManager.getLastPromptDate()

        // These should be "the same" -- let's say to within 0.1 sec
        let delta = now.timeIntervalSince(lastPromptDate!)
        XCTAssertGreaterThanOrEqual(delta, 0)
        XCTAssertLessThan(delta, 0.1)
    }

    private func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
