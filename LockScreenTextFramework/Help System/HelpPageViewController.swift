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

        self.view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
        self.title = Resources.localizedString("HelpNavTitle", tableName: HelpManager.helpStringsTable)

        self.dataSource = self.helpManager.pageViewDataSource
        self.setViewControllers([self.helpManager.entryPage], direction: .forward, animated: false, completion: nil)
    }

    // Expected to be called when the segue is being prepared
    public func preparePages() {
        self.helpManager.preparePages()
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