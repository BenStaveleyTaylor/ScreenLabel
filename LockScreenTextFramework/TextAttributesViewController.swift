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

    @IBOutlet private weak var textSizeSlider: UISlider!
    @IBOutlet private weak var textSizeLabel: UILabel!
    @IBOutlet private weak var textSizeValueLabel: UILabel!

    @IBOutlet private weak var factorySettingsButton: UIButton!
    
    // The source of the segue must push this in
    // Fatal error if nil
    private var settingsCoordinator: SettingsCoordinatorProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the text point size slider range
        self.textSizeSlider.minimumValue = 0
        self.textSizeSlider.maximumValue = Float(PointSizeSlider.numPointSizeSteps-1)
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

    @IBAction private func onTextSizeValueChanged(_ sender: Any) {

        let index = Int(self.textSizeSlider.value)
        let size = PointSizeSlider.sliderIndexToSize(index)
        self.textSizeValueLabel.text = TextAttributesHelper.displayTextForPointSize(size)
    }

    @IBAction private func onFactorySettingsTapped(_ sender: Any) {

        self.settingsCoordinator.reset()
        self.loadSettings()
    }
    
    public func prepare(settingsCoordinator: SettingsCoordinatorProtocol) {
        self.settingsCoordinator = settingsCoordinator
    }

    private func loadSettings() {

        assert(self.settingsCoordinator != nil, "No settings to edit")

        self.textLabel.text = Resources.localizedString("MessageLabel")
        self.textView.text = self.settingsCoordinator.message

        self.textSizeLabel.text = Resources.localizedString("TextSizeLabel")
        self.textSizeValueLabel.text = TextAttributesHelper.displayTextForPointSize(self.settingsCoordinator.textFont.pointSize)
        self.textSizeSlider.value = Float(PointSizeSlider.sizeToSliderIndex(self.settingsCoordinator.textFont.pointSize))

        self.factorySettingsButton.setTitle(Resources.localizedString("FactorySettings"), for: .normal)
    }

    private func saveSettings() {

        // Only issue a single update at endBatchChanges()
        self.settingsCoordinator.startBatchChanges()

        self.settingsCoordinator.message = self.textView.text
        let oldFont = self.settingsCoordinator.textFont
        let index = Int(self.textSizeSlider.value)
        let size = PointSizeSlider.sliderIndexToSize(index)
        self.settingsCoordinator.textFont = oldFont.withSize(CGFloat(size))

        self.settingsCoordinator.endBatchChanges()

    }
}
