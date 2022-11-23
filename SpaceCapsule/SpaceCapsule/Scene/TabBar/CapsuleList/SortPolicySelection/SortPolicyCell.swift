//
//  SortPolicyCell.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/23.
//

import UIKit
import SnapKit

enum SortPolicy: String {
    case nearest = "가까운 순"
    case furthest = "멀리 있는 순"
    case latest = "최신 순"
    case oldest = "오래된 순"
}

final class SortPolicyCell: UITableViewCell {
    static let identifier = "SortPolicyCell"
    
    var descriptionLabel = {
        let label = ThemeLabel(text: "가까운 순(기본)", size: 24, color: .themeBlack)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: SortPolicyCell.identifier)
        addSubview()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubview() {
        [descriptionLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    func makeConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.top.equalToSuperview().offset(FrameResource.verticalPadding)
        }
    }

    func configure(sortPolicy: SortPolicy) {
        descriptionLabel.text = sortPolicy.rawValue
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            descriptionLabel.textColor = .themeColor300
        } else {
            descriptionLabel.textColor = .themeBlack
        }
    }
}
