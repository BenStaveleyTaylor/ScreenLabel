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
/// they successfully save an image.
struct RatingsManager {

    // The prompt will be after every 5 saves,
    // or every three months, whichever is the shorter.
    // Never sooner than 1 day after installation
    var numSavesThreshold: Int
    var elapsedTimeMinThreshold: TimeInterval
    var elapsedTimeMaxThreshold: TimeInterval

    // Three months is roughly 90 days.
    static let oneDay: TimeInterval = 60*60*24
    static let threeMonths: TimeInterval = oneDay*90

    init(numSavesThreshold: Int = 5,
         elapsedTimeMinThreshold: TimeInterval = oneDay,
         elapsedTimeMaxThreshold: TimeInterval = threeMonths) {

        self.numSavesThreshold = numSavesThreshold
        self.elapsedTimeMinThreshold = elapsedTimeMinThreshold
        self.elapsedTimeMaxThreshold = elapsedTimeMaxThreshold

        // If no prompt tracking data has been created yet, do so.
        // This ensures the app install date is treated as the initial "last prompt date".
        if self.getLastPromptDate() == nil {
            self.setLastPromptDate(Date())
        }
    }

    /// One more image was saved
    func didSaveImage() {

        var needPrompt = false
        let updatedNumSaves = self.getSavesSinceLastPrompt()+1

        var timeSinceLastPrompt: TimeInterval = 0
        if let lastPromptDate = self.getLastPromptDate() {
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
            self.setSavesSinceLastPrompt(updatedNumSaves)
        }
    }

    func promptUser() {
        SKStoreReviewController.requestReview()

        // Reset the clock on the prompt requesting
        self.setSavesSinceLastPrompt(0)
        self.setLastPromptDate(Date())
    }

    // UserDefaults data accessors

    private let savesSinceLastPromptKey = "SavesSinceLastPrompt"
    private let lastPromptDateKey = "LastPromptDate"

    func getSavesSinceLastPrompt() -> Int {
        return UserDefaults.standard.integer(forKey: savesSinceLastPromptKey)
    }

    func setSavesSinceLastPrompt(_ newValue: Int) {
        UserDefaults.standard.set(newValue, forKey: savesSinceLastPromptKey)
    }

    func getLastPromptDate() -> Date? {
        return UserDefaults.standard.object(forKey: lastPromptDateKey) as? Date
    }

    func setLastPromptDate(_ newValue: Date) {
        UserDefaults.standard.set(newValue, forKey: lastPromptDateKey)
    }
}
