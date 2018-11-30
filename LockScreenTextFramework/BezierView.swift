//
//  BezierView.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 29/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

class BezierView: UIView {

    var path: UIBezierPath?
    var lineColour: UIColor = UIColor.black
    var lineWidth: CGFloat = 1

    override func draw(_ rect: CGRect) {
        if let path = path {

            self.lineColour.setStroke()
            path.lineWidth = self.lineWidth
            path.stroke()
        }
    }
}
