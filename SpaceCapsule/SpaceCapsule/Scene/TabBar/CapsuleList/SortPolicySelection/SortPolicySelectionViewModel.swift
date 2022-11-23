//
//  SortPolicySelectionViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/23.
//

import Foundation
import RxCocoa
import RxSwift

final class SortPolicySelectionViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: SortPolicySelectionCoordinator?

    var input = Input()

    struct Input {
        
    }

    init() {
        bind()
    }

    private func bind() {
        
    }
    
}
