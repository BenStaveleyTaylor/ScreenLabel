//
//  PrivacyUtilities.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 09/04/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import Foundation
import UIKit
import os.log
import Photos

// Stateless 'class' so using an enum to prevent instantiation

enum PrivacyUtilities {

    /// Ensure we have access to the photos library. If necessary the user will be prompted
    /// to grant it. If access cannot be established, an error message is given.
    ///
    /// - Parameters:
    ///   - presentingVC: ViewController to host any error message
    ///   - completion: `true` if access is granted.

    static func requestPhotosAccess(fromViewController presentingVC: UIViewController, completion: @escaping (_ success: Bool) -> Void) {

        if #available(iOS 14.0, *) {
            // We require add (write) permission to the Photos library
            // We don't need read permission any more because we use PHPickerViewController for reading
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in

                DispatchQueue.main.async {

                    if status == .authorized {
                        // All is well; proceed
                        completion(true)
                    } else {
                        completion(false)

                        AlertUtilities.showMessage(title: Resources.sharedInstance.localizedString("FailedAlertTitle"),
                                                   body: Resources.sharedInstance.localizedString("PhotosAddAccessDenied"),
                                                   button1Text: Resources.sharedInstance.localizedString("OpenSettings"),
                                                   button2Text: Resources.sharedInstance.localizedString("OK"),
                                                   fromViewController: presentingVC) { choice in

                                                    if choice == 1 {
                                                        // Open Settings
                                                        SystemSettingsUtilities.openSettings()
                                                    }
                        }
                    }
                }
            }
        }
        else {
            requestPhotosAccessPreIos14(fromViewController: presentingVC, completion: completion)
        }
    }

    @available(iOS, obsoleted: 14, message: "Use PHPhotoPicker")
    private static func requestPhotosAccessPreIos14(fromViewController presentingVC: UIViewController, completion: @escaping (_ success: Bool) -> Void) {

        // Check we have access to the Photos data
        PHPhotoLibrary.requestAuthorization { status in

            DispatchQueue.main.async {

                if status == .authorized {
                    // All is well; proceed
                    completion(true)
                } else {
                    completion(false)

                    AlertUtilities.showMessage(title: Resources.sharedInstance.localizedString("FailedAlertTitle"),
                                               body: Resources.sharedInstance.localizedString("PhotosReadWriteAccessDenied"),
                                               button1Text: Resources.sharedInstance.localizedString("OpenSettings"),
                                               button2Text: Resources.sharedInstance.localizedString("OK"),
                                               fromViewController: presentingVC) { choice in

                                                if choice == 1 {
                                                    // Open Settings
                                                    SystemSettingsUtilities.openSettings()
                                                }
                    }
                }
            }
        }
    }
}
