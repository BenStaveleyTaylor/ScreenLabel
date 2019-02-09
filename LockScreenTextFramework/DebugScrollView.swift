//
//  DebugScrollView.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 09/02/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

class DebugScrollView: UIScrollView {

    override var contentOffset: CGPoint {
        didSet {
            print("contentOffset changed to: \(self.contentOffset)")
         }
    }

    override var zoomScale: CGFloat {
        didSet {
            print("zoomScale changed to: \(self.zoomScale)")
        }
    }
}
