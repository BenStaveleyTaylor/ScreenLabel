//
//  UIAlertController+Promise.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 12/01/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import UIKit
import PromiseKit

extension UIAlertController {

    /// Create a Promise to ask a question.
    /// 
    /// The result Promise is a Guarantee since it can't fail. Cancelling is not an error.
    ///
    /// Example of use:
    /// ```
    /// let question = UIAlertController.askAgreeOrCancel(from: self,
    ///                                                   question: "Are you sure you want to erase your phone?",
    ///                                                   agreeButtonText: "Erase",
    ///                                                   agreeIsDestructive: true,
    ///                                                   cancelButtonText: "Cancel")
    /// question.done { agreed in
    ///     if agreed {
    ///         phone.erase()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - owningVC: view controller to own the alert
    ///   - question: text to ask the user
    ///   - agreeButtonText: text of the 'agree' button
    ///   - agreeIsDestructive: whether agreeing is destructive. The button will be red if so.
    ///   - cancelButtonText: text of the cancel button
    /// - Returns: Promise to evaluate. It will resolve to true if the user
    ///   selected the agree button, false if cancelled.

    public class func askForAgreement(from owningVC: UIViewController,
                                      question: String,
                                      agreeButtonText: String,
                                      agreeIsDestructive: Bool,
                                      cancelButtonText: String) -> Guarantee<Bool> {

        return Guarantee { seal in

            let alert = UIAlertController(title: nil, message: question, preferredStyle: .alert)
            let agreeStyle: UIAlertAction.Style = agreeIsDestructive ? .destructive : .default
            let agreeAction = UIAlertAction(title: agreeButtonText, style: agreeStyle) { _ in seal(true) }
            let cancelAction = UIAlertAction(title: cancelButtonText, style: .cancel) { _ in seal(false) }
            alert.addAction(agreeAction)
            alert.addAction(cancelAction)

            owningVC.present(alert, animated: true)
        }
    }
}
