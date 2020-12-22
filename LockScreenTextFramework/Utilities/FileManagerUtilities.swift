//
//  FileManagerUtilities.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 08/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import Foundation
import os.log

enum KnownDirectory: String {
    case debug = "Debug"
    case images = "Images"
}

enum FileManagerUtilities {

    // Get the URL of one of our fixed directories
    static func urlForKnownDirectory(_ directory: KnownDirectory, alwaysCreate: Bool = true) -> URL {

        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url = URL(fileURLWithPath: documents).appendingPathComponent(directory.rawValue, isDirectory: true)

        if alwaysCreate {
            let exists: Bool = (try? url.checkResourceIsReachable()) ?? false

            if !exists {
                let fileManager = FileManager.default
                do {
                    try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    os_log("Error creating directory %@ (%@)", directory.rawValue, "\(error)")
                }
            }
        }

        return url
    }
}
