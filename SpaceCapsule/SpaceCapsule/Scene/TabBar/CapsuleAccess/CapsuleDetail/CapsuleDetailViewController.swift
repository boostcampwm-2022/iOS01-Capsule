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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(origin: .zero, size: view.frame.size)
        scrollView.backgroundColor = .red
        
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
        mainView.backgroundColor = .yellow
        
        makeConstrinats()
    }
    
    func bind() {
        
    }
    
    private func makeConstrinats() {
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
