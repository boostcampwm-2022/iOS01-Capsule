//
//  LoadingIndicatorView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/24.
//

import SnapKit
import UIKit

final class LoadingIndicatorView: UIView, BaseView {
    let indicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        addSubViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .black.withAlphaComponent(0.3)
        indicator.startAnimating()
        indicator.color = .themeColor300
    }

    func addSubViews() {
        addSubview(indicator)
    }

    func makeConstraints() {
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

#if canImport(SwiftUI) && DEBUG
    import SwiftUI
    struct LoadingIndicatorViewPreview: PreviewProvider {
        static var previews: some View {
            UIViewPreview {
                LoadingIndicatorView()
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
