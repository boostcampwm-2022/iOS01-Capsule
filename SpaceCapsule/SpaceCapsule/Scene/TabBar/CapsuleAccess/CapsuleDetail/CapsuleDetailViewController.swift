//
//  CapsuleDetailViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import RxSwift
import SnapKit

final class CapsuleDetailViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleDetailViewModel?
    
    private let scrollView = CustomScrollView()
    private let mainView = CapsuleDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.imageCollectionView.applyDataSource()
        viewModel?.addImage()
    
        bind()
        
        // TODO: 구현 후에 지우기
        let center = GeoPoint(latitude: 37.583577, longitude: 127.019607)
        viewModel?.fetchCapsuleMap(at: center, width: view.frame.width)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(origin: .zero, size: view.frame.size)
        scrollView.backgroundColor = .themeBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
        mainView.backgroundColor = .themeBackground
        
        makeConstrinats()
    }
    
    func bind() {
        viewModel?.output.imageData
            .withUnretained(self)
            .subscribe(onNext: { owner, items in
                owner.mainView.imageCollectionView
                    .applySnapshot(items: items)
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.mapSnapshot
            .withUnretained(self)
            .subscribe(onNext: { owner, mapImage in
                owner.mainView.mapView.image = mapImage.first
            })
            .disposed(by: disposeBag)
    }
    
    private func makeConstrinats() {
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
