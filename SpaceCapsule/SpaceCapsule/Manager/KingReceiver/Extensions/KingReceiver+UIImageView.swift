//
//  KingReceiver+UIImageView.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/11/20.
//

import UIKit

extension UIImageView: KingReceiverCompatible {}

extension KingReceiverWrapper where Base: UIImageView {
    /// `UIImageView.kr.setImage` 처럼 사용 가능
    func setImage(
        with absoluteURL: String,
        placeholder: UIImage? = nil,
        indicator: UIActivityIndicatorView = UIActivityIndicatorView(),
        cachePolicy: ImageCacheFactory.Policy = .memory,
        resizing: Bool = true,
        scale: CGFloat = 1
    ) {
        guard let url = URL(string: absoluteURL) else {
            base.image = placeholder
            return
        }

        start(indicator: indicator)

        let imageCache = ImageCacheFactory.make(with: cachePolicy)

        imageCache.fetch(with: url) { data in
            DispatchQueue.main.async {
                defer { self.stop(indicator: indicator) }

                guard let data else {
                    base.image = placeholder
                    return
                }

                base.image = resizing ?
                    resizeImage(data: data, to: base.frame.size, scale: scale) :
                    UIImage(data: data)
            }
        }
    }

    func setImage(with data: Data, scale: CGFloat = 1) {
        base.image = resizeImage(data: data, to: base.frame.size, scale: scale)
    }

    /// 로딩 indicator 시작
    private func start(indicator: UIActivityIndicatorView?) {
        guard let indicator else {
            return
        }

        stop(indicator: indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        base.addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: base.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: base.bottomAnchor),
            indicator.leadingAnchor.constraint(equalTo: base.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: base.trailingAnchor),
        ])

        indicator.startAnimating()
    }

    /// 로딩 indicator 종료
    private func stop(indicator: UIActivityIndicatorView?) {
        indicator?.stopAnimating()
        indicator?.removeFromSuperview()
    }

    /// 이미지 스케일링, `scale` 낮은 값일수록 저화질
    /// thumbnail 만 보여줘야 하거나 blur 처리되는 부분에서 사용 가능
    private func resizeImage(data: Data, to targetSize: CGSize, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else { return nil }

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
