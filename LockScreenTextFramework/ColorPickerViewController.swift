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
    // For example as the user pans around the color wheel, this is issued repeatedly
    func colorPicker(_ picker: ColorPickerViewController, didChangeTo color: UIColor)

    // Sent just before the color picker closes -- but only if it is a navigation
    // push/pop situation. This is not sent when presentated as a popover. In that UI case
    // use UIPopoverPresentationControllerDelegate popoverPresentationControllerDidDismissPopover
    func colorPickerWillClose(_ picker: ColorPickerViewController)
}

class ColorPickerViewController: UIViewController {

    // MARK: Nib properties

    @IBOutlet private var containingStackView: UIStackView!
    @IBOutlet private var colorWheelImageView: ColorPickerWheelView!
    @IBOutlet private var swatchesStack: UIStackView!
    @IBOutlet private var lighterLabel: UILabel!
    @IBOutlet private var brightnessSlider: UISlider!
    @IBOutlet private var darkerLabel: UILabel!
    @IBOutlet private var clearerLabel: UILabel!
    @IBOutlet private var transparencySlider: UISlider!
    @IBOutlet private var opaquerLabel: UILabel!
    @IBOutlet private var beforeSwatch: TranslucentColorSwatchView!
    @IBOutlet private var beforeLabel: UILabel!
    @IBOutlet private var afterSwatch: TranslucentColorSwatchView!
    @IBOutlet private var afterLabel: UILabel!
    @IBOutlet private var transparencyControlsStack: UIStackView!

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

    var startingColor: UIColor
    var allowTransparency: Bool

    lazy var colorWheelImageData: CFData? = self.colorWheelImageView.image?.cgImage?.dataProvider?.data

    // MARK: View lifecycle

    init(title: String,
         startingColor: UIColor,
         allowTransparency: Bool,
         delegate: ColorPickerViewControllerDelegate?) {

        self.allowTransparency = allowTransparency
        self.delegate = delegate

        // If transparency is not allowed, change the starting alpha to 1
        if allowTransparency {
            self.startingColor = startingColor
        } else {
            self.startingColor = startingColor.withAlphaComponent(1.0)
        }

        let selfClass = type(of: self)
        let className = String(describing: selfClass)
        let bundle = Bundle(for: selfClass)
        super.init(nibName: className, bundle: bundle)

        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
            self.view.backgroundColor = UIColor.white
        }

        self.title = title
    }

    @available(iOS, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.afterLabel.text = Resources.sharedInstance.localizedString("ColourAfterTitle")
        self.beforeLabel.text = Resources.sharedInstance.localizedString("ColourBeforeTitle")
        self.darkerLabel.text = Resources.sharedInstance.localizedString("ColourDarkerTitle")
        self.lighterLabel.text = Resources.sharedInstance.localizedString("ColourLighterTitle")
        self.clearerLabel.text = Resources.sharedInstance.localizedString("ColourClearerTitle")
        self.opaquerLabel.text = Resources.sharedInstance.localizedString("ColourOpaquerTitle")

        // Set borders on all color swatches
        for swatch in self.swatchesStack.subviews {
            swatch.setBorder()
        }
        self.beforeSwatch.setBorder()
        self.afterSwatch.setBorder()

        // Start with no color change
        self.beforeColor = self.startingColor
        self.selectedColor = self.startingColor

        // Hide transparency controls if appropriate
        self.transparencyControlsStack.isHidden = !self.allowTransparency

        // Turn the brightness slider from horizontal to vertical
        self.brightnessSlider.transform = CGAffineTransform(rotationAngle: .pi / -2)

        // Replace the standard Back button so we can tell when we are dismissed
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                target: self,
                                                                action: #selector(onDone(_:)))

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
        // swiftlint:disable:next unused_setter_value
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

            // Update the colour wheel
            var brightness: CGFloat = 0
            selectedColor.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
            self.colorWheelImageView.brightness = brightness
        }
    }

    @IBAction private func onBrightnessChanged(_ sender: UISlider) {

        let newBrightness = CGFloat(sender.value)

        // Redraw the wheel
        self.colorWheelImageView.brightness = newBrightness

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var alpha: CGFloat = 0
        if self.selectedColor.getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha) {

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
