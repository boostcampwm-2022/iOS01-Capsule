//
//  HomeViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxSwift

final class HomeViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: HomeCoordinator?
    
    init() {
        
    }
    
    func bind() {}
}
