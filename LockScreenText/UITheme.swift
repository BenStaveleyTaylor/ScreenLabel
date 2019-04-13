//
//  UITheme.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 01/01/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import UIKit
import LockScreenTextFramework

enum UITheme {

    static func setAppearanceDefaults() {

        // Set the page control colors to use
        let pageControlAppearance = UIPageControl.appearance()

        pageControlAppearance.pageIndicatorTintColor = UIColor(named: "OtherPageBulletColor")
        pageControlAppearance.currentPageIndicatorTintColor = UIColor(named: "CurrentPageBulletColor")

        // Dialogs are dark green bar with white text
        let dialogNavBarAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [DialogNavigationController.self])
        dialogNavBarAppearance.barTintColor = UIColor(named: "AppThemeDarkColor")
        dialogNavBarAppearance.tintColor = .white

        let whiteTextAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        dialogNavBarAppearance.titleTextAttributes = whiteTextAttribute
    }

}
