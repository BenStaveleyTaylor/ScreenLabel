//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import EFColorPicker
import LockScreenTextFramework


let bundle = Bundle(identifier: "com.staveleytaylor.ben.LockScreenTextFramework")
let storyboard = UIStoryboard(name: "Main", bundle: bundle)

let testVC = storyboard.instantiateInitialViewController()

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = testVC
