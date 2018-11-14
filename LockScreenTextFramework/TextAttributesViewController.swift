//
//  TextAttributesViewController.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 13/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

class TextAttributesViewController: UIViewController {

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var clearTextButton: UIButton!

    // The source of the segue must push this in
    private var settingsCoordinator: SettingsCoordinatorProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadSettings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.saveSettings()
    }

    @IBAction private func onClearText(_ sender: Any) {
        self.textView.text = ""
    }

    public func prepare(settingsCoordinator: SettingsCoordinatorProtocol) {
        self.settingsCoordinator = settingsCoordinator
   }

    private func loadSettings() {

        assert(self.settingsCoordinator != nil, "No settings to edit")

        self.textLabel.text = Resources.localizedString("MessageLabel")
        self.textView.text = self.settingsCoordinator?.message
    }

    private func saveSettings() {

        // Only issue a single update at endBatchChanges()
        self.settingsCoordinator?.startBatchChanges()

        self.settingsCoordinator?.message = self.textView.text

        self.settingsCoordinator?.endBatchChanges()

    }
}
