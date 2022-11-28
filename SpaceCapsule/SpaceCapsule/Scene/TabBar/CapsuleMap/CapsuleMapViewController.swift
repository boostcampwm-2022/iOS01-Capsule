//
//  CapsuleMapViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import CoreLocation
import MapKit
import RxSwift
import UIKit

final class CapsuleMapViewController: UIViewController, BaseViewController {
    let disposeBag = DisposeBag()
    var viewModel: CapsuleMapViewModel?
    private let capsuleMapView = MKMapView()
    private let locationManager = CLLocationManager()
    private var annotationsToMonitor = [CustomAnnotation]() { didSet { markIfOpenable()} }
    private let mapSettings: (openableRange: Double, monitoringRange: Double, toUpdateRange: Double) = (100, 1000, 500)
    
    private var smallOverlay: MKCircle?
    private var bigOverlay: MKCircle?
    
    deinit {
        capsuleMapView.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addConstraints()
        bindNotification()
        bind()
        goToCurrentLocation()
        viewModel?.fetchAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    private func configure() {
        view.addSubview(capsuleMapView)
        capsuleMapView.delegate = self
        capsuleMapView.mapType = MKMapType.standard
        capsuleMapView.showsUserLocation = true
        capsuleMapView.setUserTrackingMode(.follow, animated: true)

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func addConstraints() {
        capsuleMapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindNotification() {
        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.locationManager.stopUpdatingLocation()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .withUnretained(self)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.locationManager.startUpdatingLocation()
            })
            .disposed(by: disposeBag)
    }
    
    func bind() {
        locationManager.rx.didChangeAuthorization.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, status in
                weakSelf.implementStatus(status)
            })
            .disposed(by: disposeBag)
        
        viewModel?.input.annotations
            .withUnretained(self)
            .bind { weakSelf, coordinates in
                weakSelf.removeAllAnnotations()
                weakSelf.addInitialAnnotations(coordinates: coordinates)
            }
            .disposed(by: disposeBag)
    
        locationManager.rx.didUpdateLocations.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.markIfOpenable()
                if let coordinate = weakSelf.locationManager.location?.coordinate {
                    weakSelf.addCircleLocation(at: coordinate)
                }
            })
            .disposed(by: disposeBag)
        
        locationManager.rx.willExitMonitoringRegion.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, region in
                weakSelf.resetMonitoringRegion(from: region)
            })
            .disposed(by: disposeBag)
        
        capsuleMapView.rx.calloutAccessoryControlTapped.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.presentToDetailAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func implementStatus(_ status: CLAuthorizationStatus) {
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
    
    private func goToCurrentLocation() {
        guard let center = locationManager.location?.coordinate else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: center, span: span)
        capsuleMapView.setRegion(region, animated: true)

        resetMonitoringRegion(from: nil)
    }
    
    private func presentToDetailAlert() {
        let alertController = UIAlertController(title: "캡슐입니다", message: "해당 캡슐로 이동할까요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func removeAllAnnotations() {
        let annotations = capsuleMapView.annotations
        capsuleMapView.removeAnnotations(annotations)
    }
    
    // MARK: 처음 Annotation 그릴 때 사용
    private func addInitialAnnotations(coordinates: [CLLocationCoordinate2D]) {
        let annotations = coordinates.map { CustomAnnotation(coordinate: $0) }
        updateAnnotationsToMonitor(annotations)
        capsuleMapView.addAnnotations(annotations)
    }

    private func updateAnnotationsToMonitor(_ annotations: [CustomAnnotation]) {
        guard let currentPos = locationManager.location else { return }
        annotationsToMonitor = annotations.filter { currentPos.distance(from: CLLocation(latitude: $0.coordinate.latitude,
                                                                                         longitude: $0.coordinate.longitude)) <= mapSettings.monitoringRange
        }
    }
    
    // MARK: Region 업데이트 및 AnnotationsToMonitor 새로 계산
    private func resetMonitoringRegion(from previousRegion: CLRegion?) {
        guard let center = locationManager.location?.coordinate else { return }
        
        let customAnnotations = capsuleMapView.annotations.compactMap { $0 as? CustomAnnotation }
        updateAnnotationsToMonitor(customAnnotations)
        
        if let previousRegion = previousRegion {
            locationManager.stopMonitoring(for: previousRegion)
        }
        
        let newRegion = CLCircularRegion(center: center, radius: mapSettings.toUpdateRange, identifier: "regionsToMonitor")
        newRegion.notifyOnExit = true
        
        locationManager.startMonitoring(for: newRegion)
        
        if let bigOverlay = bigOverlay {
            capsuleMapView.removeOverlay(bigOverlay)
        }
        let bigCircle = MKCircle(center: center, radius: mapSettings.monitoringRange)
        capsuleMapView.addOverlay(bigCircle)
        bigOverlay = bigCircle
        
    }
    
    private func markIfOpenable() {
        guard let currentLocation = locationManager.location else { return }
        
        annotationsToMonitor
            .forEach {
                let location = currentLocation.distance(from: CLLocation(latitude: $0.coordinate.latitude,
                                                                         longitude: $0.coordinate.longitude))
                $0.isOpenable = (location <= mapSettings.openableRange) ? true : false
            }
    }
}

// TODO: Overlay 필요없을 때 삭제
extension CapsuleMapViewController: MKMapViewDelegate {
    private func addCircleLocation(at center: CLLocationCoordinate2D) {
        if let previousOverlay = smallOverlay {
            capsuleMapView.removeOverlay(previousOverlay)
        }
        
        let circle = MKCircle(center: center, radius: mapSettings.openableRange)
        capsuleMapView.addOverlay(circle)
        smallOverlay = circle
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            circleRenderer.fillColor = .white
            circleRenderer.alpha = 0.2
            circleRenderer.strokeColor = .black
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is CustomAnnotation:
            return CustomAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        default:
            return nil
        }
    }
}
