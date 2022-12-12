//
//  UIImage+.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/10.
//

import UIKit.UIImage

extension UIImage {
    static func resize(data: Data, to targetSize: CGSize, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
            return nil
        }

        let maxDimension = max(targetSize.width, targetSize.height) * scale
        let resizingOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension,
        ] as CFDictionary

        guard let resizedImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, resizingOptions) else {
            return nil
        }

        return UIImage(cgImage: resizedImage)
    }
}
