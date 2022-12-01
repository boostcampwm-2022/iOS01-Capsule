//
//  CapsuleDetailViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import RxSwift
import RxCocoa

final class CapsuleDetailViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleDetailCoordinator?
    
    var input = Input()
    var output = Output()
    
    struct Input {
        var imageData = BehaviorRelay<[DetailImageCollectionView.Cell]>(value: [])
    }
    
    struct Output {}
    
    func addImage() {
        input.imageData.accept([.sampleImage1, .sampleImage2, .sampleImage3, .sampleImage4, .sampleImage5])
    }
}
