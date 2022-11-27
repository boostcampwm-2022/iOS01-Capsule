//
//  SortPolicyCell.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/23.
//

import UIKit
import SnapKit

final class SortPolicyCell: UITableViewCell {
    static let identifier = "SortPolicyCell"
    
    var descriptionLabel = {
        let label = ThemeLabel(text: SortPolicy.nearest.description, size: 24, color: .themeBlack)
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
    
    private func addSubview() {
        [descriptionLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.top.equalToSuperview().offset(FrameResource.verticalPadding)
        }
    }

    func configure(sortPolicy: SortPolicy) {
        descriptionLabel.text = sortPolicy.description
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        descriptionLabel.textColor = selected ? .themeColor300 : .themeBlack
    }
}
