//
//  ExportActivityItem.swift
//  Lock Message
//
//  Created by Ben Staveley-Taylor on 07/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

class ExportActivityItem: NSObject {
    
    var viewRoot: UIView
    
    init(withViewRoot view: UIView) {
        self.viewRoot = view
        
        super.init()
    }
    
}

extension ExportActivityItem: UIActivityItemSource {
    
    // called to determine data type. only the class of the return type is consulted. it should match what -itemForActivityType: returns later
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        
        // Only care about the type -- return an empty image
        return UIImage()
    }
    
    // called to fetch data after an activity is selected. you can return nil.
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        // Convert the view into an image
        
        let renderer = UIGraphicsImageRenderer(size: self.viewRoot.bounds.size)
        let image = renderer.image { ctx in
            self.viewRoot.drawHierarchy(in: self.viewRoot.bounds, afterScreenUpdates: true)
         }

//    let data = image.pngData()
//    let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//    let url = URL(fileURLWithPath: documents).appendingPathComponent("renderer.image.png")
//    try? data?.write(to: url)

        return image
    }
    
    // if activity supports a Subject field
    public func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        
        let template = NSLocalizedString("ActivitySubjectDescription", comment: "")
        let productName = NSLocalizedString("ProductTitle", comment: "")
        
        return String(format: template, productName)
    }
}
