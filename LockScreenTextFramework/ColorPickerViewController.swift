//
//  ColorPickerViewController.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 02/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

// Client must implement this
protocol ColorPickerViewControllerDelegate: AnyObject {

    // User has selected a new color. This happens many times before a final "OK"
    // For example as the user pans around the color wheel, this is issues repeatedly
    func colorPicker(_ picker: ColorPickerViewController, didChangeTo color: UIColor)

    // Sent just before the color picker closes -- but only if it is a navigation
    // push/pop situation. This is not sent when presentated as a popover. In that UI case
    // use UIPopoverPresentationControllerDelegate popoverPresentationControllerDidDismissPopover
    func colorPickerWillClose(_ picker: ColorPickerViewController)
}

class ColorPickerViewController: UIViewController {

    // MARK: Nib properties

    @IBOutlet private weak var containingStackView: UIStackView!
    @IBOutlet private weak var colorWheelImageView: UIImageView!
    @IBOutlet private weak var swatchesStack: UIStackView!
    @IBOutlet private weak var lighterLabel: UILabel!
    @IBOutlet private weak var brightnessSlider: UISlider!
    @IBOutlet private weak var darkerLabel: UILabel!
    @IBOutlet private weak var clearerLabel: UILabel!
    @IBOutlet private weak var transparencySlider: UISlider!
    @IBOutlet private weak var opaquerLabel: UILabel!
    @IBOutlet private weak var beforeSwatch: TranslucentColorSwatchView!
    @IBOutlet private weak var beforeLabel: UILabel!
    @IBOutlet private weak var afterSwatch: TranslucentColorSwatchView!
    @IBOutlet private weak var afterLabel: UILabel!

    // MARK: Other properties
    var settingsInitialised: Bool = false

    var beforeColor = UIColor.white {
        didSet {
            self.beforeSwatch.swatchColor = self.beforeColor
        }
    }
    var selectedColor = UIColor.white {
        didSet {
            self.afterSwatch.swatchColor = self.selectedColor

            // Show the alpha and brightness
            var alpha: CGFloat = 0
            var brightness: CGFloat = 0
            self.selectedColor.getHue(nil, saturation: nil, brightness: &brightness, alpha: &alpha)
            self.brightnessSlider.value = Float(brightness)
            self.transparencySlider.value = Float(alpha)

            // Only call the delegate after the initial load has finished
            if self.settingsInitialised {
                self.delegate?.colorPicker(self, didChangeTo: self.selectedColor)
            }
        }
    }
    weak var delegate: ColorPickerViewControllerDelegate?

    var startingColor: UIColor?

    lazy var colorWheelImageData: CFData? = self.colorWheelImageView.image?.cgImage?.dataProvider?.data

    // MARK: View lifecycle

    convenience init(startingColor: UIColor, delegate: ColorPickerViewControllerDelegate?) {

        let selfClass = type(of: self)
        let className = String(describing: selfClass)
        let bundle = Bundle(for: selfClass)
        self.init(nibName: className, bundle: bundle)

        self.startingColor = startingColor
        self.delegate = delegate
    }

    // This allows the xib-based ViewController to be referenced in a Storyboard
    // see https://japko.net/2014/09/08/loading-swift-uiviewcontroller-from-xib-in-storyboard/

    override func loadView() {
        let selfClass = type(of: self)
        let className = String(describing: selfClass)
        let bundle = Bundle(for: selfClass)
        bundle.loadNibNamed(className, owner: self, options: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the labels
        self.title = Resources.localizedString("PickColorTitle")
        self.afterLabel.text = Resources.localizedString("ColourAfterTitle")
        self.beforeLabel.text = Resources.localizedString("ColourBeforeTitle")
        self.darkerLabel.text = Resources.localizedString("ColourDarkerTitle")
        self.lighterLabel.text = Resources.localizedString("ColourLighterTitle")
        self.clearerLabel.text = Resources.localizedString("ColourClearerTitle")
        self.opaquerLabel.text = Resources.localizedString("ColourOpaquerTitle")

        // Set borders on all color swatches
        for swatch in self.swatchesStack.subviews {
            swatch.setBorder()
        }
        self.beforeSwatch.setBorder()
        self.afterSwatch.setBorder()

        // Start with no color change
        if let startingColor = self.startingColor {
            self.beforeColor = startingColor
            self.selectedColor = startingColor
        }

        // Turn the brightness slider from horizontal to vertical
        self.brightnessSlider.transform = CGAffineTransform(rotationAngle: .pi / -2)

        // Replace the standard Back button so we can tell when we are dismissed
        if self.navigationController != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                    target: self,
                                                                    action: #selector(onDone(_:)))
        }

        self.settingsInitialised = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }

    // Determine the size when presented as a popover
    override var preferredContentSize: CGSize {
        get {
            self.containingStackView.layoutIfNeeded()
            return self.containingStackView.bounds.size
        }
        set {
            // Ignored
        }
    }

    // -------------------------------------------------------------------------
    // MARK: Actions from the UI
    // -------------------------------------------------------------------------

    @IBAction private func onColorWheelPan(_ sender: UIPanGestureRecognizer) {
        self.selectColorFromWheelTouch(gestureRecognizer: sender)
    }

    @IBAction private func onColorWheelTap(_ sender: UITapGestureRecognizer) {
        self.selectColorFromWheelTouch(gestureRecognizer: sender)
    }

    @IBAction private func onColorSwatchTap(_ sender: UITapGestureRecognizer) {

        // The tapped view might be a plain UIView, or it might be a TranslucentColorSwatchView
        let maybeColor: UIColor?

        switch sender.view {
        case let view as TranslucentColorSwatchView:
            maybeColor = view.swatchColor

        default:
            maybeColor = sender.view?.backgroundColor
        }

        if let selectedColor = maybeColor {
            self.selectedColor = selectedColor
        }
    }

    @IBAction private func onBrightnessChanged(_ sender: UISlider) {

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var alpha: CGFloat = 0
        if self.selectedColor.getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha) {

            let newBrightness = CGFloat(sender.value)
            let newColor = UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
            self.selectedColor = newColor
        }
    }

    @IBAction private func onTransparencyChanged(_ sender: UISlider) {

        let newAlpha = CGFloat(sender.value)
        let newColor = self.selectedColor.withAlphaComponent(newAlpha)
        self.selectedColor = newColor
    }

    @objc
    private func onDone(_ sender: UIBarButtonItem) {

        self.delegate?.colorPickerWillClose(self)
    }

    // -------------------------------------------------------------------------
    // MARK: Private methods
    // -------------------------------------------------------------------------

    private func selectColorFromWheelTouch(gestureRecognizer: UIGestureRecognizer) {

        if gestureRecognizer.numberOfTouches > 0 {
            let touchLoc = gestureRecognizer.location(ofTouch: 0, in: self.colorWheelImageView)

            if self.colorWheelImageView.point(inside: touchLoc, with: nil) {

                if let pickedColor = self.colorWheelImageView.color(at: touchLoc) {
                    self.selectedColor = pickedColor
                }
            }
        }
    }

}
