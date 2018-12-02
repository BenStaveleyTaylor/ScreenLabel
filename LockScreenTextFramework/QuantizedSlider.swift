//
//  QuantizedSlider.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 01/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

// Like a UISlider but not continuous; returns one of the steps values
// .value is the raw slider value which is the step number
// .stepValue is the value of the step
class QuantizedSlider: UISlider {

    var steps: [Int] {
        return [0, 1]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // awakeFromNib will be called next
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }

    private func commonInit() {

        // Must have at least two steps
        assert(self.steps.count > 1)

        // Set the slider to go from 0 to count-1
        self.minimumValue = 0
        self.maximumValue = Float(self.steps.count-1)
    }

    var stepValue: Int {
        get {
            let index: Int = lroundf(self.value)
            return self.steps[index]
        }
        set {
            // Which step index is this?
            var index = 0
            for step in self.steps {
                if step >= newValue {
                    break
                }
                index += 1
            }

            index = min(index, self.steps.count-1)
            self.value = Float(index)
        }
    }
}
