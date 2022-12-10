//
//  UIImage+.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/10.
//

import UIKit.UIImage

extension UIImage {
//    func resize(_ newWidth: CGFloat) -> UIImage {
//        let scale = newWidth / self.size.width
//        let newHeight = self.size.height * scale
//
//        let size = CGSize(width: newWidth, height: newHeight)
//        let render = UIGraphicsImageRenderer(size: size)
//        let renderImage = render.image { _ in
//            self.draw(in: CGRect(origin: .zero, size: size))
//        }
//
//        return renderImage
//    }

    func resize(newWidth: CGFloat, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let data = pngData(),
              let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
            return nil
        }

        let ratio = newWidth / self.size.width
        let newHeight = self.size.height * ratio
        let maxDimension = max(newWidth, newHeight) * scale
        
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
