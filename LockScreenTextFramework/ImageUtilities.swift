//
//  ImageUtilities.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 08/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit
import os.log

// Stateless 'class' so using an enum to prevent instantiation

enum ImageUtilities {

    static func imageFromView(_ view: UIView) -> UIImage {

        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)

        let image = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }

        return image
    }

    /// Saves an image into the Images directory of the container
    /// Any existing file of the same name will be overwritten
    ///
    /// - Parameters:
    ///   - image: image to save
    ///   - nameWithoutExtension: file system name to use. This will be largely invisible to the user
    ///     but they may see it if they export the image to a Mac.
    ///   - quality: 0 to 1. The default is 0.85 (85%) which is fairly good
    /// - Returns: The URL that was written; nil if error
    @discardableResult
    static func saveAsJpeg(image: UIImage, nameWithoutExtension: String, quality: CGFloat = 0.85) -> URL? {

        // Constrain to legal bounds
        let validatedQuality = min(max(quality, 0), 1)
        let nameWithExtension = nameWithoutExtension.appending(".jpg")

        let data = image.jpegData(compressionQuality: validatedQuality)

        let directory = FileManagerUtilities.urlForKnownDirectory(KnownDirectory.images)
        let file = directory.appendingPathComponent(nameWithExtension, isDirectory: false)

        do {
            try data?.write(to: file)
        } catch {
            os_log("Error writing to %@ (%@)", "\(file)", "\(error)")
            return nil
        }

        return file
    }

    /// Restore a saved JPEG image
    ///
    /// - Parameter name: nameWithoutExtension
    /// - Returns: image
    static func readSavedJpegImage(nameWithoutExtension: String) -> UIImage? {

        let directory = FileManagerUtilities.urlForKnownDirectory(KnownDirectory.images)
        let nameWithExtension = nameWithoutExtension.appending(".jpg")
        let file = directory.appendingPathComponent(nameWithExtension, isDirectory: false)

        return UIImage(contentsOfFile: file.path)
    }

}
