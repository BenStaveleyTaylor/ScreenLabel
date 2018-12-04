//
//  ColorPickerWheelView.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 03/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

// An image view for hosting Circular shapes, e.g. the color wheel

// This is a standard image view except the hit test only registers
// when the event is inside the circle.

class ColorPickerWheelView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let bundle = Bundle(for: type(of: self))
        self.image = UIImage(named: "ColorPickerWheel", in: bundle, compatibleWith: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Let the nib/storyboard specify the image
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

//    func colorAtPoint(_ point: CGPoint) -> UIColor? {
//
//    }

}
