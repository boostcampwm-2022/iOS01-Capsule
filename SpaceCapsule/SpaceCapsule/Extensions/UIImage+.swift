//
//  UIImage.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/15.
//

import UIKit

extension UIImage {
    static let logo = UIImage(named: "logo")
    static let logoWithBG = UIImage(named: "logoWithBG")
    static let logoWithText = UIImage(named: "logoWithText")

    static let homeFill = UIImage(systemName: "house.fill")
    static let mapFill = UIImage(systemName: "map.fill")
    static let gridFill = UIImage(systemName: "circle.grid.2x2.fill")
    static let profileFill = UIImage(systemName: "person.fill")
    static let addCapsuleFill = UIImage(systemName: "plus")

    static let addImage = UIImage(systemName: "plus.square.on.square")
    static let mapPin = UIImage(systemName: "mappin.and.ellipse")
    static let chevronLeft = UIImage(systemName: "chevron.left")
    static let chevronRight = UIImage(systemName: "chevron.right")
    static let close = UIImage(systemName: "xmark")
    static let sort = UIImage(systemName: "arrow.up.arrow.down")
    static let lock = UIImage(systemName: "lock.fill")
    static let triangleDown = UIImage(systemName: "arrowtriangle.down.fill")
}

extension UIImage {
    func resize(_ newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }

        return renderImage
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
