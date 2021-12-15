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

        // WTF? iOS 15 defaults nav bars and toolbars to transparent? No thanks.
        if #available(iOS 15, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            navBarAppearance.backgroundColor = UIColor.systemGray6
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance

            let toolbarAppearance = UIToolbarAppearance()
            toolbarAppearance.configureWithOpaqueBackground()
            toolbarAppearance.backgroundColor = UIColor.systemGray6
            UIToolbar.appearance().standardAppearance = toolbarAppearance
            UIToolbar.appearance().scrollEdgeAppearance = toolbarAppearance
        }

        // Set the page control colors to use
        let pageControlAppearance = UIPageControl.appearance()

        pageControlAppearance.pageIndicatorTintColor = UIColor(named: "OtherPageBulletColor")
        pageControlAppearance.currentPageIndicatorTintColor = UIColor(named: "CurrentPageBulletColor")
    }
}
