//
//  DialogNavigationController.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 13/04/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

// Named subclass just to allow it to be customised by UIAppearance
// specifically, without affecting other UINavigationControllers.
public class DialogNavigationController: UINavigationController {

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let whiteTextAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]

        // Set green dialog title bars.
        // Can't do this via UIAppearance any more as of iOS 15

        if #available(iOS 15, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.titleTextAttributes = whiteTextAttribute
            navBarAppearance.backgroundColor = UIColor(named: "AppThemeDarkColor")
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        
        navigationBar.barTintColor = UIColor(named: "AppThemeDarkColor")
        navigationBar.titleTextAttributes = whiteTextAttribute
        navigationBar.tintColor = .white
    }
}
