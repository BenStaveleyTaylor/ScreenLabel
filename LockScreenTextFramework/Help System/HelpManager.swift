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
    private var initialPageIndex: Int = 0

    // An index (e.g. "1") is added on to the base names
    private let helpTitleBase = "HelpTitle"
    private let helpImageBase = "HelpImage"
    private let helpTextBase = "HelpText"

    func preparePages(startingAt: Int) {

        // Loop until we run out of page titles
        var index: Int = 1
        repeat {

            let seq = String(index)
            let titleKey = self.helpTitleBase + seq
            let imageKey = self.helpImageBase + seq
            let textKey = self.helpTextBase + seq

            // The UI is different in iOS 14, 13 and 12. Use variant resources.
            let suffix: String?
            if #available(iOS 14, *) {
                // "Latest" has no suffix
                suffix = nil
            }
            else if #available(iOS 13, *) {
                suffix = "-iOS13"
            } else {
                // iOS 12 or earlier
                suffix = "-iOS12"
            }

            let title = Resources.sharedInstance.localizedString(titleKey, suffix: suffix, tableName: HelpManager.helpStringsTable)
            if title == Resources.notFound {
                break
            }

            // Images are named .xcassets
            let image = Resources.sharedInstance.image(named: imageKey, suffix: suffix)

            let text = Resources.sharedInstance.localizedString(textKey, suffix: suffix, tableName: HelpManager.helpStringsTable)

            let vc = HelpPageController.create(title: title, image: image, text: text)
            self.pages.append(vc)

            index += 1
        } while true

        self.initialPageIndex = startingAt
    }

    // Intended for adding an About page at the end of the help sequence
    func appendPage(_ page: UIViewController) {
        self.pages.append(page)
    }

    // Get the help entry point
    public var entryPage: UIViewController {

        assert(!self.pages.isEmpty, "Help system has not been initialised")

        return self.pages[self.initialPageIndex]
    }

    func indexFor(viewController: UIViewController) -> Int? {
        let index = self.pages.firstIndex(of: viewController)
        return index
    }

    // The text to be displayed as the title of a help page
    func titleFor(viewController: UIViewController) -> String {
        let template = Resources.sharedInstance.localizedString("HelpNavTitleTemplate", tableName: HelpManager.helpStringsTable)

        // Insert current and total page numbers
        let currentPageIndex = self.indexFor(viewController: viewController) ?? NSNotFound
        // 0-based to human readable number conversion
        let result = String(format: template,
                            NSNumber(value: currentPageIndex+1),
                            NSNumber(value: self.pages.count))

        return result
    }

}

extension HelpManager: UIPageViewControllerDataSource {

    public var pageViewDataSource: UIPageViewControllerDataSource {
        return self
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        var result: UIViewController?

        if let index = self.indexFor(viewController: viewController), index > 0 {
            result = self.pages[index-1]
        }

        return result
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        var result: UIViewController?

        if let index = self.indexFor(viewController: viewController), index < (self.pages.count-1) {
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

        var result: Int = NSNotFound

        if let page = pageViewController.viewControllers?.first,
            let index = self.indexFor(viewController: page) {
            result = index
        }

        return result
    }
}
