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
    let locationManager = CLLocationManager()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

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
            .bind { weakSelf, isDragging in
                if isDragging {
                    weakSelf.mainView.cursor.backgroundColor = .lightGray
                } else {
                    weakSelf.mainView.cursor.backgroundColor = .green
                }
            }.disposed(by: disposeBag)

        // 주소
        viewModel?.output.fullAddress
            .subscribe(onNext: { [weak self] in
                self?.mainView.locationLabel.text = $0 ?? "해당 지역의 주소를 불러올 수 없습니다."
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
            .subscribe(onNext: {[weak self] in
                self?.viewModel?.input.done.onNext(())
            })
            .disposed(by: disposeBag)
    }

    private func configure() {
        configureLocationManager()
        configureMap()
        configureGesture()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func configureMap() {
        mainView.locateMap.delegate = self
        mainView.locateMap.mapType = MKMapType.standard
    }

    private func goToCurrentLocation() {
        guard let center = locationManager.location?.coordinate else {
            return
        }

        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)

        mainView.locateMap.setRegion(region, animated: true)
    }
}

// MARK: - MKMapView, CLLocationManager

extension CapsuleLocateViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            locationManager.startUpdatingLocation()
            goToCurrentLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("GPS 권한 요청 거부됨")
            locationManager.requestWhenInUseAuthorization()
        default:
            print("GPS: Default")
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        let coordinate = mapView.region.center

        viewModel?.fetchLocation(x: coordinate.longitude, y: coordinate.latitude)
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
