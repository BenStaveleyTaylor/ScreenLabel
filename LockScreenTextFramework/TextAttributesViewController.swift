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
    @IBOutlet private weak var messageTextView: UITextView!
    @IBOutlet private weak var clearTextButton: UIButton!
    @IBOutlet private weak var messagePlaceholder: UILabel!

    @IBOutlet private weak var textSizeSlider: PointSizeSlider!
    @IBOutlet private weak var textSizeLabel: UILabel!
    @IBOutlet private weak var textSizeValueLabel: UILabel!

    @IBOutlet private weak var textFontLabel: UILabel!
    @IBOutlet private weak var textFontName: UILabel!

    @IBOutlet private weak var textStyleLabel: UILabel!
    @IBOutlet private weak var textStyleSegmentControl: UISegmentedControl!

    @IBOutlet private weak var textColorLabel: UILabel!
    @IBOutlet private weak var textColorSwatchView: TranslucentColorSwatchView!
    
    @IBOutlet private weak var boxColorLabel: UILabel!
    @IBOutlet private weak var boxColorSwatchView: TranslucentColorSwatchView!

    @IBOutlet weak var bleedStyleLabel: UILabel!
    @IBOutlet weak var bleedStyleSwitch: UISwitch!
    @IBOutlet weak var bleedStyleHelpLabel: UILabel!

    @IBOutlet private weak var factorySettingsButton: UIButton!
    
    @IBOutlet private var textColorTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet private var boxColorTapGestureRecognizer: UITapGestureRecognizer!

    // The source of the segue must push this in
    // Fatal error if nil
    private var settingsCoordinator: SettingsCoordinatorProtocol!

    private var colorSwatchBeingEdited: TranslucentColorSwatchView?

    private var isEditingMessage: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.boxColorSwatchView.setBorder()
        self.textColorSwatchView.setBorder()

        self.messagePlaceholder.text = Resources.localizedString("MessagePlaceholderText")

        self.loadSettings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.saveSettings()
    }

    @IBAction private func onClearText(_ sender: Any) {
        self.messageTextView.text = ""
        self.updatePlaceholderTextVisibility()
    }

    @IBAction private func onTextSizeValueChanged(_ sender: Any) {

        let size = self.textSizeSlider.stepValue
        self.textSizeValueLabel.text = TextAttributesHelper.displayTextForPointSize(CGFloat(size))
    }

    @IBAction private func onTextStyleChanged(_ sender: UISegmentedControl) {
    }

    @IBAction func onBleedStyleChanged(_ sender: UISwitch) {
        // nop
    }

    @IBAction private func onFactorySettingsTapped(_ sender: Any) {

        self.settingsCoordinator.reset()
        self.loadSettings()
    }

    @IBAction private func onColorSwatchTapped(_ sender: UITapGestureRecognizer) {

        // Same action sent for both Text and Box color changes
        if sender == self.textColorTapGestureRecognizer {
            self.colorSwatchBeingEdited = self.textColorSwatchView
        }
        else if sender == self.boxColorTapGestureRecognizer {
            self.colorSwatchBeingEdited = self.boxColorSwatchView
        }

        guard let anchorView = self.colorSwatchBeingEdited else {
            os_log("Unknown color swatch tap sender: %@", sender)
            return
        }

        let colorPickerVC = ColorPickerViewController(startingColor: anchorView.swatchColor ?? UIColor.white,
                                                      delegate: self)

        // Present as a popover on iPad, or push on iPhone

        if self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact {

            // iPhone-style, including iPads in narrow split-screen view.
            self.navigationController?.pushViewController(colorPickerVC, animated: true)
        } else {

            // iPad-style
            colorPickerVC.modalPresentationStyle = .popover
            self.present(colorPickerVC, animated: true, completion: nil)

            let popController = colorPickerVC.popoverPresentationController
            popController?.backgroundColor = colorPickerVC.view.backgroundColor
            popController?.permittedArrowDirections = .any
            popController?.sourceView = anchorView
            popController?.sourceRect = anchorView.bounds
            popController?.delegate = self
        }
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
        let fontName = self.textFontName.text ?? ""
        pickerVC.selectedFontInternalName = TextAttributesHelper.fontInternalNameFrom(displayName: fontName)
    }

    private func loadSettings() {

        assert(self.settingsCoordinator != nil, "No settings to edit")

        self.textLabel.text = Resources.localizedString("MessageLabel")
        self.messageTextView.text = self.settingsCoordinator.message

        self.textSizeLabel.text = Resources.localizedString("TextSizeLabel")
        self.textSizeValueLabel.text = TextAttributesHelper.displayTextForPointSize(self.settingsCoordinator.textFont.pointSize)
        self.textSizeSlider.stepValue = lround(self.settingsCoordinator.textFont.pointSize.native)

        self.textFontLabel.text = Resources.localizedString("TextFontLabel")

        let internalFontName =  self.settingsCoordinator.textFont.familyName
        self.textFontName.text = TextAttributesHelper.fontDisplayNameFrom(internalName: internalFontName)

        self.textStyleLabel.text = Resources.localizedString("TextStyleLabel")

        self.textColorLabel.text = Resources.localizedString("TextColorLabel")
        self.textColorSwatchView.swatchColor = self.settingsCoordinator.textColor

        self.boxColorLabel.text = Resources.localizedString("BoxColorLabel")
        self.boxColorSwatchView.swatchColor = self.settingsCoordinator.boxColor

        self.bleedStyleLabel.text = Resources.localizedString("BleedStyleLabel")
        self.bleedStyleHelpLabel.text = Resources.localizedString("BleedStyleHelpText")
        self.bleedStyleSwitch.isOn = (self.settingsCoordinator.imageBleedStyle == .perspective)

        self.factorySettingsButton.setTitle(Resources.localizedString("FactorySettings"), for: .normal)

        self.updatePlaceholderTextVisibility()
    }

    private func saveSettings() {

        // Only issue a single update at endBatchChanges()
        self.settingsCoordinator.startBatchChanges()

        self.settingsCoordinator.message = self.messageTextView.text

        let size = self.textSizeSlider.stepValue

        if let newFontName = self.textFontName.text,
            let newFont = UIFont(name: newFontName, size: CGFloat(size)) {
            
            self.settingsCoordinator.textFont = newFont
        }

        if let textColor = self.textColorSwatchView.swatchColor {
            self.settingsCoordinator.textColor = textColor
        }

        if let boxColor = self.boxColorSwatchView.swatchColor {
            self.settingsCoordinator.boxColor = boxColor
        }

        let bleedStyle: BleedStyle = self.bleedStyleSwitch.isOn ? .perspective : .still
        self.settingsCoordinator.imageBleedStyle = bleedStyle

        self.settingsCoordinator.endBatchChanges()
    }

    // Ensure the massage placeholder text shows when there is no message text
    // and hides when there is some text
    // It is always hidden while editing
    private func updatePlaceholderTextVisibility() {

        let hidden = self.isEditingMessage || !self.messageTextView.text.isEmpty

        self.messagePlaceholder.isHidden = hidden
    }
}

extension TextAttributesViewController: FontPickerViewControllerDelegate {

    // The selected font has changed
    func didChangeSelectedFont(internalName: String) {

        self.textFontName.text = TextAttributesHelper.fontDisplayNameFrom(internalName: internalName)
        self.navigationController?.popViewController(animated: true)
    }
}

extension TextAttributesViewController: ColorPickerViewControllerDelegate {

    func colorPicker(_ picker: ColorPickerViewController, didChangeTo color: UIColor) {

        if self.colorSwatchBeingEdited == self.boxColorSwatchView {
            self.boxColorSwatchView.swatchColor = color
        }
        else if self.colorSwatchBeingEdited == self.textColorSwatchView {
            self.textColorSwatchView.swatchColor = color
        }
    }

    func colorPickerWillClose(_ picker: ColorPickerViewController) {

        self.colorSwatchBeingEdited = nil

        // This is only called if we presented by pushing, so:
        self.navigationController?.popViewController(animated: true)
    }
}

extension TextAttributesViewController: UIPopoverPresentationControllerDelegate {

    // Detect closure of the Colour Picker and save the final result
    @objc
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.colorSwatchBeingEdited = nil
    }
}

extension TextAttributesViewController: UITextViewDelegate {

    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.isEditingMessage = true
        self.updatePlaceholderTextVisibility()
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        self.isEditingMessage = false
        self.updatePlaceholderTextVisibility()
    }
}
