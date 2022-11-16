//
//  RatingsManager.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 09/03/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import Foundation
import StoreKit

/// Utilities to perform App Store ratings requests
///
/// We will prompt the user to give an app store rating after
/// they successfully save a settings change, given a suitable interval
struct RatingsManager {

    // The prompt will be after every 10 saves, or every three months,
    // whichever is the shorter. Never sooner than 1 day after installation
    // Apple will limit the app to 3 prompts a year.
    // Once prompted, the interval to the next prompt is increased by
    // promptBackoffFactor.
    // So a prompt after 1 day, then 7 days, then 49 days (at most).
    var numSavesThreshold: Int
    var elapsedTimeMinThreshold: TimeInterval
    var elapsedTimeMaxThreshold: TimeInterval
    let promptBackoffFactor: Double = 7

    // Three months is roughly 91 days.
    static let oneDay: TimeInterval = 60*60*24
    static let threeMonths: TimeInterval = oneDay*91

    init(numSavesThreshold: Int = 10,
         initialElapsedTimeMinThreshold: TimeInterval = oneDay,
         elapsedTimeMaxThreshold: TimeInterval = threeMonths) {

        self.numSavesThreshold = numSavesThreshold
        self.elapsedTimeMinThreshold = RatingsManager.getMinPromptInterval()
        self.elapsedTimeMaxThreshold = elapsedTimeMaxThreshold

        // If we have a saved min threshold, use it, else set an initial value
        if self.elapsedTimeMinThreshold == 0 {
            self.elapsedTimeMinThreshold = initialElapsedTimeMinThreshold
            RatingsManager.setMinPromptInterval(initialElapsedTimeMinThreshold)
        }

        // If no prompt tracking data has been created yet, do so.
        // This ensures the app install date is treated as the initial "last prompt date".
        if RatingsManager.getLastPromptDate() == nil {
            RatingsManager.setLastPromptDate(Date())
        }
    }

    /// Settings were saved again
    mutating func didSaveSettings() {

        var needPrompt = false
        let updatedNumSaves = RatingsManager.getSavesSinceLastPrompt()+1

        var timeSinceLastPrompt: TimeInterval = 0
        if let lastPromptDate = RatingsManager.getLastPromptDate() {
            let now = Date()
            timeSinceLastPrompt = now.timeIntervalSince(lastPromptDate)
        }

        if updatedNumSaves >= numSavesThreshold {
            // Never prompt before a minimum time has elapsed.
            needPrompt = (timeSinceLastPrompt > elapsedTimeMinThreshold)
        } else {
            // Has enough time elapsed anyway?
            needPrompt = (timeSinceLastPrompt > elapsedTimeMaxThreshold)
        }

        if needPrompt {
            self.promptUser()
            // Number of saves will be reset
        } else {
            // Record the extra save for next time
            RatingsManager.setSavesSinceLastPrompt(updatedNumSaves)
        }
    }

    mutating func promptUser() {

        // Apple recommend a 2 second pause so the UI settles before prompting
        let settleTime: TimeInterval = 2
        DispatchQueue.main.asyncAfter(deadline: .now() + settleTime) {
            SKStoreReviewController.requestReview()
        }

        // Reset the clock on the prompt requesting
        RatingsManager.setSavesSinceLastPrompt(0)
        RatingsManager.setLastPromptDate(Date())

        // Never more than the max interval
        let nextMinThreshold = min(
            self.elapsedTimeMinThreshold * self.promptBackoffFactor,
            self.elapsedTimeMaxThreshold
        )

        self.elapsedTimeMinThreshold = nextMinThreshold
        RatingsManager.setMinPromptInterval(nextMinThreshold)
    }

    // UserDefaults data accessors

    private static let savesSinceLastPromptKey = "SavesSinceLastPrompt"
    private static let lastPromptDateKey = "LastPromptDate"
    private static let minPromptInterval = "MinPromptInterval"

    static func getSavesSinceLastPrompt() -> Int {
        return UserDefaults.standard.integer(forKey: savesSinceLastPromptKey)
    }

    static func setSavesSinceLastPrompt(_ newValue: Int) {
        UserDefaults.standard.set(newValue, forKey: savesSinceLastPromptKey)
    }

    static func getLastPromptDate() -> Date? {
        return UserDefaults.standard.object(forKey: lastPromptDateKey) as? Date
    }

    static func setLastPromptDate(_ newValue: Date) {
        UserDefaults.standard.set(newValue, forKey: lastPromptDateKey)
    }

    static func getMinPromptInterval() -> TimeInterval {
        return UserDefaults.standard.double(forKey: minPromptInterval)
    }

    static func setMinPromptInterval(_ newValue: TimeInterval) {
        UserDefaults.standard.set(newValue, forKey: minPromptInterval)
    }
}
