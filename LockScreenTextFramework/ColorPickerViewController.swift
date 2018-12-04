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

}

class ColorPickerViewController: UIViewController {

    // MARK: Nib properties

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

    var beforeColor: UIColor = UIColor.white {
        didSet {
            self.beforeSwatch.swatchColor = self.beforeColor
        }
    }
    var selectedColor: UIColor = UIColor.white {
        didSet {
            self.afterSwatch.swatchColor = self.selectedColor

            // Show the alpha and brightness
            var alpha: CGFloat = 0
            var brightness: CGFloat = 0
            self.selectedColor.getHue(nil, saturation: nil, brightness: &brightness, alpha: &alpha)
            self.brightnessSlider.value = Float(brightness)
            self.transparencySlider.value = Float(alpha)

            self.delegate?.colorPicker(self, didChangeTo: self.selectedColor)
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

        if let selectedColor = sender.view?.backgroundColor {
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
