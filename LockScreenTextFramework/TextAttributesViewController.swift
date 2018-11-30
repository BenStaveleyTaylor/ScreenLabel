//
//  TextAttributesViewController.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 13/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit
import os.log

class TextAttributesViewController: UIViewController {

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var clearTextButton: UIButton!

    @IBOutlet private weak var textSizeSlider: UISlider!
    @IBOutlet private weak var textSizeLabel: UILabel!
    @IBOutlet private weak var textSizeValueLabel: UILabel!

    @IBOutlet private weak var textFontLabel: UILabel!
    @IBOutlet private weak var textFontName: UILabel!

    @IBOutlet private weak var textColourLabel: UILabel!
    @IBOutlet private weak var textColourSwatchView: TranslucentColorSwatchView!
    
    @IBOutlet private weak var boxColourLabel: UILabel!
    @IBOutlet private weak var boxColourSwatchView: TranslucentColorSwatchView!

    @IBOutlet private weak var factorySettingsButton: UIButton!
    
    // The source of the segue must push this in
    // Fatal error if nil
    private var settingsCoordinator: SettingsCoordinatorProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the text point size slider range
        self.textSizeSlider.minimumValue = 0
        self.textSizeSlider.maximumValue = Float(PointSizeSlider.numPointSizeSteps-1)

        self.boxColourSwatchView.layer.borderWidth = 1
        self.boxColourSwatchView.layer.borderColor = UIColor.gray.cgColor

        self.textColourSwatchView.layer.borderWidth = 1
        self.textColourSwatchView.layer.borderColor = UIColor.gray.cgColor

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
        case "pickFontSegue":
            self.prepareForPickFontSegue(segue, sender: sender)

        default:
            os_log("Unexpected segue: %@", segue.identifier ?? "<nil>")
        }
    }

    private func prepareForPickFontSegue(_ segue: UIStoryboardSegue, sender: Any?) {

        assert(segue.identifier == "pickFontSegue")

        guard let pickerVC = segue.destination as? FontPickerViewController else {
            assertionFailure("destination of pickFontSegue was not a FontPickerViewController")
            return
        }

        // Push the current font in so it can be shown ticked
        pickerVC.delegate = self
        pickerVC.selectedFontInternalName = TextAttributesHelper.fontInternalNameFrom(displayName: self.textFontName.text!)
    }

    private func loadSettings() {

        assert(self.settingsCoordinator != nil, "No settings to edit")

        self.textLabel.text = Resources.localizedString("MessageLabel")
        self.textView.text = self.settingsCoordinator.message

        self.textSizeLabel.text = Resources.localizedString("TextSizeLabel")
        self.textSizeValueLabel.text = TextAttributesHelper.displayTextForPointSize(self.settingsCoordinator.textFont.pointSize)
        self.textSizeSlider.value = Float(PointSizeSlider.sizeToSliderIndex(self.settingsCoordinator.textFont.pointSize))

        self.textFontLabel.text = Resources.localizedString("TextFontLabel")

        let internalFontName =  self.settingsCoordinator.textFont.fontName
        self.textFontName.text = TextAttributesHelper.fontDisplayNameFrom(internalName: internalFontName)

        self.textColourLabel.text = Resources.localizedString("TextColourLabel")
        self.textColourSwatchView.swatchColor = self.settingsCoordinator.textColour

        self.boxColourLabel.text = Resources.localizedString("BoxColourLabel")
        self.boxColourSwatchView.swatchColor = self.settingsCoordinator.boxColour

        self.factorySettingsButton.setTitle(Resources.localizedString("FactorySettings"), for: .normal)
    }

    private func saveSettings() {

        // Only issue a single update at endBatchChanges()
        self.settingsCoordinator.startBatchChanges()

        self.settingsCoordinator.message = self.textView.text

        let index = Int(self.textSizeSlider.value)
        let size = PointSizeSlider.sliderIndexToSize(index)

        if let newFontName = self.textFontName.text,
            let newFont = UIFont(name: newFontName, size: size) {
            
            self.settingsCoordinator.textFont = newFont
        }

        self.settingsCoordinator.endBatchChanges()
    }
}

extension TextAttributesViewController: FontPickerViewControllerDelegate {

    // The selected font has changed
    func didChangeSelectedFont(internalName: String) {

        self.textFontName.text = TextAttributesHelper.fontDisplayNameFrom(internalName: internalName)
        self.navigationController?.popViewController(animated: true)
    }
}
