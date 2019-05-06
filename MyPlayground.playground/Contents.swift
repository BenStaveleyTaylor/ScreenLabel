//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
@testable import LockScreenTextFramework


let dateFormatter = DateFormatter()
let date = Date(timeIntervalSinceReferenceDate: 410219999)

// US English Locale (en_US)
dateFormatter.locale = Locale(identifier: "en_US")
dateFormatter.setLocalizedDateFormatFromTemplate("JJmm") // set template after setting locale
print(dateFormatter.string(from: date)) // December 31

// British English Locale (en_GB)
dateFormatter.locale = Locale(identifier: "en_GB")
dateFormatter.setLocalizedDateFormatFromTemplate("jmm") // // set template after setting locale
print(dateFormatter.string(from: date)) // 31 December
