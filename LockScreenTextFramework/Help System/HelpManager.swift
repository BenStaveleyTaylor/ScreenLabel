//
//  HelpManager.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 30/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

// We will show a number of help screens followed by an About box
@objc
class HelpManager: NSObject {

    // Strings are in the "Help.strings" file
    public static let helpStringsTable = "Help"

    private var pages: [UIViewController] = []
    private var currentPageIndex: Int = 0

    // An index (e.g. "1") is added on to the base names
    private let helpTitleBase = "HelpTitle"
    private let helpImagesFolder = "HelpImages"
    private let helpImageBase = "HelpImage"
    private let helpTextBase = "HelpText"

    func preparePages() {

        // 3 pages of help info
        for index in 1...3 {

            let suffix = String(index)
            let titleKey = self.helpTitleBase + suffix
            let imageKey = self.helpImageBase + suffix + ".jpg"
            let textKey = self.helpTextBase + suffix

            let title = Resources.localizedString(titleKey, tableName: HelpManager.helpStringsTable)
            let image = Resources.image(named: helpImagesFolder + "/" + imageKey)
            let text = Resources.localizedString(textKey, tableName: HelpManager.helpStringsTable)

            let vc = HelpPageController.create(title: title, image: image, text: text)
            self.pages.append(vc)
        }
    }

    // Intended for adding an About page at the end of the help sequence
    func appendPage(_ page: UIViewController) {
        self.pages.append(page)
    }

    // Get the help entry point
    public var entryPage: UIViewController {

        assert(!self.pages.isEmpty, "Help system has not been initialised")

        return self.pages[0]
    }
    
    func indexForViewController(_ viewController: UIViewController) -> Int? {
        let index = self.pages.firstIndex(of: viewController)
        return index
    }

}

extension HelpManager: UIPageViewControllerDataSource {
    
    public var pageViewDataSource: UIPageViewControllerDataSource {
        return self
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var result: UIViewController?
        
        if let index = self.indexForViewController(viewController), index > 0 {
            result = self.pages[index-1]
        }
        
        return result
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var result: UIViewController?
        
        if let index = self.indexForViewController(viewController), index < (self.pages.count-1) {
            result = self.pages[index+1]
        }
        
        return result
    }
    
    // A page indicator will be visible if both methods are implemented, transition style
    // is 'UIPageViewControllerTransitionStyleScroll', and navigation orientation is
    // 'UIPageViewControllerNavigationOrientationHorizontal'.
    // Both methods are called in response to a 'setViewControllers:...' call, but the
    // presentation index is updated automatically in the case of gesture-driven navigation.
    
    // The number of items reflected in the page indicator.
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    // The selected item reflected in the page indicator.
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentPageIndex
    }
    
}
