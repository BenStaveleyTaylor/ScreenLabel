//
//  AlertUtilities.swift
//  Lock Message
//
//  Created by Ben Staveley-Taylor on 08/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

enum AlertUtilities {

    static func showMessage(title: String?, body: String?, fromViewController vc: UIViewController? = nil) {

        let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)

        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .default,
                                     handler: nil)
        alertController.addAction(okAction)

        // Use root VC if none specified
        let presentingVC = vc ?? UIApplication.shared.windows.first?.rootViewController
        presentingVC?.present(alertController, animated: true, completion: nil)
    }

}
