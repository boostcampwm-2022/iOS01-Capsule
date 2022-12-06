//
//  DetailImageView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/06.
//

import SnapKit
import UIKit

final class ZoomableImageView: UIScrollView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        addDoubleTapRecognizer()
        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        minimumZoomScale = 1
        maximumZoomScale = 3

        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        delegate = self
    }

    private func addSubViews() {
        addSubview(imageView)
    }

    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }

    private func addDoubleTapRecognizer() {
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
    }

    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        let scale: CGFloat = zoomScale == 1 ? 2 : 1
        setZoomScale(scale, animated: true)
    }
}

extension ZoomableImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
