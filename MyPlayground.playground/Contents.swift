//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
//import EFColorPicker
@testable import LockScreenTextFramework


//let bundle = Bundle(identifier: "com.staveleytaylor.ben.LockScreenTextFramework")
//let storyboard = UIStoryboard(name: "Main", bundle: bundle)
//
//let testVC = storyboard.instantiateInitialViewController()
//
//// Present the view controller in the Live View window
//PlaygroundPage.current.liveView = testVC

let view = TranslucentColorSwatchView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
PlaygroundPage.current.liveView = view

view.swatchColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)


