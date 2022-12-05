//
//  CapsuleLocateViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import CoreLocation
import MapKit
import RxSwift
import UIKit

final class CapsuleLocateViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleLocateViewModel?

    let mainView = CapsuleLocateView()
    let locationManager = LocationManager.shared.core

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        goToCurrentLocation()
        bind()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }

    func bind() {
        // Drag
        viewModel?.input.isDragging
            .withUnretained(self)
            .bind { owner, isDragging in
                if isDragging {
                    owner.mainView.cursor.image = .locateDisabled
                } else {
                    owner.mainView.cursor.image = .locate
                }
            }.disposed(by: disposeBag)

        viewModel?.output.doneButtonState
            .withUnretained(self)
            .subscribe(onNext: { owner, state in
                owner.mainView.doneButton.isEnabled = state
                owner.mainView.doneButton.backgroundColor = state ? .themeColor200 : .themeGray200
            })
            .disposed(by: disposeBag)

        // 주소
        viewModel?.output.fullAddress
            .subscribe(onNext: { [weak self] in
                self?.mainView.locationLabel.text = $0 ?? LocationError.invalidGeopoint.errorDescription
            })
            .disposed(by: disposeBag)

        // 취소
        mainView.cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.input.cancel.onNext(())
            })
            .disposed(by: disposeBag)

        // 완료
        mainView.doneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.input.done.onNext(())
            })
            .disposed(by: disposeBag)

        mainView.locateMap.rx.regionDidChangeAnimated
            .subscribe(onNext: { [weak self] mapView, _ in
                let coordinate = mapView.centerCoordinate
                
                self?.viewModel?.output.geopoint.onNext(
                    GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                )
            })
            .disposed(by: disposeBag)
    }

    private func configure() {
        view.backgroundColor = .white

        configureLocationManager()
        configureGesture()
    }

    private func goToCurrentLocation() {
        guard let center = LocationManager.shared.coordinate else {
            return
        }

        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)

        mainView.locateMap.setRegion(region, animated: true)
    }
}

// MARK: - CLLocationManager

extension CapsuleLocateViewController: CLLocationManagerDelegate {
    private func configureLocationManager() {
        locationManager.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        LocationManager.shared.checkAuthorization(status: status)
    }
}

// MARK: - Gesture Recognizer

extension CapsuleLocateViewController: UIGestureRecognizerDelegate {
    private func configureGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(sender:)))
        panGesture.delegate = self

        mainView.locateMap.addGestureRecognizer(panGesture)
    }

    @objc func drag(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            viewModel?.input.isDragging.accept(true)
        case .ended, .cancelled:
            viewModel?.input.isDragging.accept(false)
        default:
            break
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
