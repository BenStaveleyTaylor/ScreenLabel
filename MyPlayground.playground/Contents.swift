//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
@testable import LockScreenTextFramework


let vc = ColorPickerViewController(startingColor: UIColor.green, delegate: nil)

PlaygroundPage.current.liveView = vc

