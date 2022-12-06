//
//  DetailImageViewController.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/06.
//

import RxSwift
import UIKit

final class DetailImageViewController: UIViewController {
    var disposeBag = DisposeBag()
    var viewModel: DetailImageViewModel?

    private let mainView = DetailImageView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        viewModel?.fetchData()
    }

    private func bind() {
        viewModel?.output.imageData
            .subscribe(onNext: { [weak self] imageData in
                let index = imageData.index
                self?.mainView.imageView.image = UIImage(data: imageData.data[index])
            })
            .disposed(by: disposeBag)
    }
}
