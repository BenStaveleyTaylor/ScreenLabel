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
enum PointSizeSlider {

    private static let pointSizeSteps: [Int] = [6, 7, 8, 9, 10, 12, 14, 16, 18, 20, 24,
                                                28, 32, 36, 40, 48, 56, 64, 72, 84, 96,
                                                112, 128, 144, 160, 176, 192, 208, 224, 256]

    // We represent text sizes by a slider value which is the index into pointSizeSteps
    static func sliderIndexToSize(_ sliderIndex: Int) -> CGFloat {
        if sliderIndex < self.numPointSizeSteps {
            return CGFloat(self.pointSizeSteps[sliderIndex])
        }

        return CGFloat(self.pointSizeSteps.last!)
    }

    static func sizeToSliderIndex(_ size: CGFloat) -> Int {

        guard let min = self.pointSizeSteps.first else {
            return 0
        }

        if size < CGFloat(min) {
            return 0
        }

        let roundedSize: CGFloat = round(size)

        for index in 0..<self.numPointSizeSteps {
            let val = self.pointSizeSteps[index]

            if CGFloat(val) >= roundedSize {
                return index
            }
        }

        // If we got here, it's off the end
        return self.numPointSizeSteps-1
    }

    static var numPointSizeSteps: Int {
        return self.pointSizeSteps.count
    }
}
