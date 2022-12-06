//
//  DetailImageCell.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/06.
//

import SnapKit
import UIKit

final class ZoomableImageCell: UICollectionViewCell {
    let zoomableImageView = ZoomableImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        zoomableImageView.setZoomScale(1, animated: false)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(data: Data) {
        zoomableImageView.imageView.image = UIImage(data: data)
    }

    private func addSubViews() {
        addSubview(zoomableImageView)
    }

    private func makeConstraints() {
        zoomableImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
