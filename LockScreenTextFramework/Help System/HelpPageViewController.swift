//
//  HelpPageViewController.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 31/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

public class HelpPageViewController: UIPageViewController {

    private lazy var helpManager = HelpManager()

    public override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
            self.view.backgroundColor = UIColor.white
        }

        // Do any additional setup after loading the view.
        self.dataSource = self.helpManager.pageViewDataSource
        self.delegate = self
        let initialVC = self.helpManager.entryPage
        self.setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)

        self.title = self.helpManager.titleFor(viewController: initialVC)
    }

    // Expected to be called when the segue is being prepared
    public func preparePages(startingAt: Int = 0) {
        self.helpManager.preparePages(startingAt: startingAt)
    }

    // Expected to be called when the segue is being prepared
    // Intended for adding an About page at the end of the help sequence
    public func appendPage(_ page: UIViewController) {
        self.helpManager.appendPage(page)
    }

    // Handler for the Done button
    @IBAction private func onDoneTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension HelpPageViewController: UIPageViewControllerDelegate {

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {

        // Update the nave bar title to show the new page number
        if let newCurrentVC = self.viewControllers?.first {
            self.title = self.helpManager.titleFor(viewController: newCurrentVC)
        }
    }
}
