//
//  CapsuleDetailViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import MapKit
import RxCocoa
import RxSwift
import UIKit

final class CapsuleDetailViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleDetailCoordinator?

    var input = Input()
    var output = Output()

    lazy var mapSnapshotInfo = Observable.zip(input.frameWidth, output.mapCoordinate)

    struct Input {
        var viewDidDisappear = PublishSubject<Void>()
        var frameWidth = PublishSubject<CGFloat>()
    }

    struct Output {
        var imageCell = BehaviorRelay<[DetailImageCell.Cell]>(value: [])
        var capsuleData = BehaviorRelay<[Capsule]>(value: [])
        var mapCoordinate = PublishSubject<CLLocationCoordinate2D>()
        var mapSnapshot = BehaviorRelay<[UIImage]>(value: [])
    }

    init() {
        bind()
    }

    private func bind() {
        mapSnapshotInfo
            .withUnretained(self)
            .subscribe(onNext: { owner, snapshotInfo in
                let (width, coordinate) = (snapshotInfo.0, snapshotInfo.1)
                owner.drawMapSnapshot(width: width, at: coordinate)
            })
            .disposed(by: disposeBag)

        input.viewDidDisappear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.finish()
            })
            .disposed(by: disposeBag)
    }

    func fetchCapsule(with uuid: String?) {
        guard let uuid,
              let capsule = AppDataManager.shared.capsule(uuid: uuid) else {
            return
        }

        // MARK: 캡슐 정보 업데이트

        output.capsuleData.accept([capsule])

        // MARK: 캡슐 지도 업데이트

        output.mapCoordinate.onNext(
            CLLocationCoordinate2D(latitude: capsule.geopoint.latitude, longitude: capsule.geopoint.longitude)
        )

        // MARK: 캡슐 이미지 업데이트

        guard let firstImageURL = capsule.images.first else {
            return
        }

        let firstCell = DetailImageCell.Cell(
            imageURL: firstImageURL,
            capsuleInfo: DetailImageCell.CapsuleInfo(
                address: capsule.simpleAddress,
                date: capsule.memoryDate.dateString
            )
        )

        let otherCells = capsule.images[1 ..< capsule.images.count].map {
            DetailImageCell.Cell(imageURL: $0, capsuleInfo: nil)
        }
        
        output.imageCell.accept([firstCell] + otherCells)
    }

    private func drawMapSnapshot(width: CGFloat, at center: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)

        let options: MKMapSnapshotter.Options = .init()
        options.region = MKCoordinateRegion(center: center, span: span)
        options.size = CGSize(width: width - (FrameResource.detailContentHInset * 2),
                              height: FrameResource.detailMapHeight)

        let snapshotShooter = MKMapSnapshotter(options: options)
        snapshotShooter.start { [weak self] snapshot, error in
            guard let snapshot = snapshot else {
                return
            }

            if error != nil {
                return
            }

            if let drawImage = self?.drawAnnotation(with: center, on: snapshot) {
                self?.output.mapSnapshot.accept([drawImage])
            }
        }
    }

    private func drawAnnotation(with center: CLLocationCoordinate2D, on snapshot: MKMapSnapshotter.Snapshot) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
        snapshot.image.draw(at: .zero)

        let point = snapshot.point(for: center)
        let annotation = CustomAnnotation(uuid: nil, memoryDate: nil, latitude: center.latitude, longitude: center.longitude)
        annotation.isOpenable = true
        let annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        let rect = CGRect(x: point.x - (annotationView.bounds.width / 2),
                          y: point.y - (annotationView.bounds.height),
                          width: annotationView.bounds.width,
                          height: annotationView.bounds.height)

        annotationView.drawHierarchy(in: rect, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
