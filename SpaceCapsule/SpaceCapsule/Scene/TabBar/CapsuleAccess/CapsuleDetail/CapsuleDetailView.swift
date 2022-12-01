//
//  CapsuleDetailView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import MapKit

final class CapsuleDetailView: UIView, BaseView {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    let imageCollectionView = DetailImageCollectionView(frame: .zero)
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = FrameResource.spacing400
        return stackView
    }()
    
    private let closedDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .themeGray300
        label.font = .themeFont(ofSize: 16)
        return label
    }()
    
    private let descriptionView: UITextView = {
       let view = UITextView()
        view.isUserInteractionEnabled = false
        view.textColor = .themeGray300
        view.font = .themeFont(ofSize: 24)
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let mapView: UIImageView = {
        let mapView = UIImageView()
        mapView.contentMode = .scaleAspectFit
        mapView.layer.borderWidth = 0.5
        mapView.layer.borderColor = UIColor.themeGray300?.cgColor
        return mapView
    }()
    
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
        // TODO: 구현 후 삭제필요
        closedDateLabel.text = "밀봉시간: 2010년 7월 1일"
        descriptionView.text = "날씨가 너무 좋았던 날\n 영준이를 오랜만에 봐서 좋았다\n 지수랑 민중이랑 영준이랑 김치 떡볶이 먹고 인생네컷도 찍었다.\n 지수는 소주를 3병이나 먹는게 진짜 신기하다"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addMapSnapshot()
    }
    
    func addSubViews() {
        [closedDateLabel,
         descriptionView,
         mapView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        [imageCollectionView,
         contentStackView
        ].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        self.addSubview(mainStackView)
    }
    
    func makeConstraints() {
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(FrameResource.detailImageCollectionViewHeight)
        }
        
        contentStackView.snp.makeConstraints {
            $0.width.equalToSuperview().inset(FrameResource.detailContentHInset)
        }
        
        mapView.snp.makeConstraints {
            $0.height.equalTo(FrameResource.detailMapHeight)
        }
    }
    
    private func addMapSnapshot() {
        // TODO: 선택한 캡슐 위치 좌표 입력으로 변경
        let center = CLLocationCoordinate2D(latitude: 37.583577, longitude: 127.019607)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let options: MKMapSnapshotter.Options = .init()
        options.region = MKCoordinateRegion(center: center, span: span)
        options.size = CGSize(width: frame.size.width - (FrameResource.detailContentHInset * 2),
                              height: FrameResource.detailMapHeight)
        
        let snapshotShooter = MKMapSnapshotter(options: options)
        
        snapshotShooter.start { snapshot, error in
            guard let snapshot = snapshot else {
                print("no snapshot passed")
                return
            }
            
            if error != nil {
                print("error")
                return
            }
            
            DispatchQueue.main.async {
                self.mapView.image = snapshot.image
            }
        }
    }
}
