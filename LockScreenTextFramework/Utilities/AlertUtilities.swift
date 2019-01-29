//
//  AlertUtilities.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 08/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

enum AlertUtilities {

    ///  Simple OK alert
    static func showMessage(title: String?, body: String?, fromViewController presentingVC: UIViewController? = nil) {

        let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)

        let okAction = UIAlertAction(title: Resources.localizedString("OK"),
                                     style: .default,
                                     handler: nil)
        alertController.addAction(okAction)

        // Use root VC if none specified
        let presentingVC = presentingVC ?? UIApplication.shared.windows.first?.rootViewController
        presentingVC?.present(alertController, animated: true, completion: nil)
    }

    /// Message alert with two buttons
    /// Completion function returns "1" or "2" for which button was used to dismiss the dialoh
    static func showMessage(title: String?,
                            body: String?,
                            button1Text: String,
                            button2Text: String,
                            fromViewController presentingVC: UIViewController? = nil,
                            completion: @escaping (Int) -> Void) {
        
        let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)

        let action1 = UIAlertAction(title: button1Text,
                                    style: .default) { _ in
                                        completion(1)
        }

        let action2 = UIAlertAction(title: button2Text,
                                    style: .default) { _ in
                                        completion(2)
        }

        alertController.addAction(action1)
        alertController.addAction(action2)

        // Use root VC if none specified
        let presentingVC = presentingVC ?? UIApplication.shared.windows.first?.rootViewController
        presentingVC?.present(alertController, animated: true, completion: nil)
    }

}
