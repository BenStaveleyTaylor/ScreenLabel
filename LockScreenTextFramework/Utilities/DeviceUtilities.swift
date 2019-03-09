//
//  DeviceUtilities.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 07/03/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import Foundation
import UIKit

enum DeviceUtilities {

    // Regardless of the size of the current view, is the device compact, i.e. iPhone-alike?
    static var isCompactDevice: Bool {
        // Screen width of < 400px is deemed compact
        let size = self.appScreenSize
        return size.width < 400 || size.height < 400
    }

    // Regardless of the size of the current view, is the device regular, i.e. iPad-alike?
    static var isRegularDevice: Bool {
        return !self.isCompactDevice
    }

    // Get the total size available to us
    static var appScreenSize: CGSize {

        if let window = UIApplication.shared.windows.first,
            let rootVC = window.rootViewController {

            return rootVC.view.bounds.size
        }

        return .zero
    }
}
