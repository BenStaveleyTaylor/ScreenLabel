//
//  PointSizeSlider.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 24/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

// Point sizes are quantized and only these steps are allowed
// Only integral font sizes are supported
class PointSizeSlider: QuantizedSlider {

    override var steps: [Int] {
        
        // List of allowed point sizes
        return [
            7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 20, 24,
            28, 32, 36, 40, 48, 56, 64, 72, 84, 96,
            112, 128, 144, 160, 176, 192, 208, 224, 256
        ]
    }
}
