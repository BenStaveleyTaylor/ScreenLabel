//
//  ColorPickerWheelView.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 03/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit
import os.log

// An image view for hosting Circular shapes, e.g. the color wheel

// This is a standard image view except the hit test only registers
// when the event is inside the circle.

class ColorPickerWheelView: UIImageView {

    var lastActionedBrightness: CGFloat = 0
    var lastActionedRadius: CGFloat = 0

    var brightness: CGFloat = 1.0 {
        didSet {
            // Need to change the wheel image to match
            // Only do if change is > 0.01 (of a value between 0 and 1)
            // Optimisation since redrawing the wheel can be very slow
            if lastActionedBrightness == 0 || abs(self.brightness-lastActionedBrightness) > 0.02 {
                self.lastActionedBrightness = self.brightness
                self.image = self.colorWheel(brightness: self.brightness, radius: self.radius)
            }
        }
    }
    
    var radius: CGFloat = 0 {
        didSet {
            // Need to change the wheel image to match
            // Only do if change is > 1px
            if lastActionedRadius == 0 || abs(self.radius-lastActionedRadius) > 1 {
                self.lastActionedRadius = self.radius
                self.image = self.colorWheel(brightness: self.brightness, radius: self.radius)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Resize the wheel, for best quality
        self.radius = self.bounds.width/2
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        if self.point(inside: point, with: event) {
            return self
        }

        return nil
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        let targetCircle = UIBezierPath(ovalIn: self.bounds)
        return targetCircle.contains(point)
    }

    func colorWheel(brightness: CGFloat, radius: CGFloat) -> UIImage? {

        os_log("Regenerating colorWheel at brightness: %@, radius: %@", "\(brightness)", "\(radius)")

        let filter = CIFilter(name: "CIHueSaturationValueGradient", parameters: [
            "inputColorSpace": CGColorSpaceCreateDeviceRGB(),
            "inputDither": 0,
            "inputRadius": radius,
            "inputSoftness": 0,
            "inputValue": brightness
        ])

        if let filterOutput = filter?.outputImage {
            return UIImage(ciImage: filterOutput)
        }

        return nil
    }
}
