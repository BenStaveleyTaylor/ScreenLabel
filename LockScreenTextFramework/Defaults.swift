//
//  Defaults.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 31/10/2022.
//  Copyright © 2022 Ben Staveley-Taylor. All rights reserved.
//

import Foundation
import os.log

public enum Defaults {

    static let oldLocation = UserDefaults.standard
    static let newLocation = UserDefaults(suiteName: "group.staveleytaylor.ben.LockScreenText")

    public static let location = newLocation ?? oldLocation

    public static func updateStorageLocation() {

        guard let newLocation = newLocation else {
            os_log("Failed to get shared storage")
            return
        }

        // Do we have a version in the suite defaults? If yes, migration already done
        if Settings.readFromUserDefaults(newLocation) != nil {
            return
        }

        // Do we have a version in the old location? If so, move it
        if let oldSettings = Settings.readFromUserDefaults(oldLocation) {
            // May be from an old version of the product
            let updatedSettings = oldSettings.updatedToCurrentVersion()
            try? updatedSettings.writeToUserDefaults(newLocation)
            return
        }
    }
}
