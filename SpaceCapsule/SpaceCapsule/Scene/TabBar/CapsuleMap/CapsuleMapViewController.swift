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
    struct Settings {
        static let openableRange: Double = LocationManager.openableRange
        static let monitoringRange: Double = 1000
        static let monitoringUpdateRange: Double = 850
        static let locationUpdateRange: Double = 5
    }

    let disposeBag = DisposeBag()
    var viewModel: CapsuleMapViewModel?

    private let mapView = CapsuleMapView()
    private let locationManager = LocationManager.shared.core
    private var annotationsToMonitor = [CustomAnnotation]() {
        didSet { markIfOpenable() }
    }

    private var smallOverlay: MKCircle?
    private var bigOverlay: MKCircle?

    deinit {
        mapView.delegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        makeConstraints()

        bind()
        goToCurrentLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.input.viewWillAppear.onNext(())
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
        mapView.selectedAnnotations.removeAll()
    }

    private func configure() {
        view.backgroundColor = .themeBackground
        view.addSubview(mapView)
        mapView.delegate = self
    }

    private func makeConstraints() {
        mapView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bindNotification() {
        NotificationCenter.default.rx
            .notification(UIApplication.didEnterBackgroundNotification)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.locationManager.stopUpdatingLocation()
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .withUnretained(self)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                owner.locationManager.startUpdatingLocation()
            })
            .disposed(by: disposeBag)
    }

    private func bindLocationManager() {
        locationManager.rx.didChangeAuthorization
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, status in
                if LocationManager.shared.checkAuthorization(status: status) {
                    owner.goToCurrentLocation()
                }
            })
            .disposed(by: disposeBag)

        locationManager.rx.didUpdateLocations
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.markIfOpenable()
            })
            .disposed(by: disposeBag)

        locationManager.rx.willExitMonitoringRegion
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, region in
                owner.resetMonitoringRegion(from: region)
            })
            .disposed(by: disposeBag)
    }

    func bind() {
        bindNotification()
        bindLocationManager()

        viewModel?.output.annotations
            .withUnretained(self)
            .bind { owner, annotations in
                owner.removeAllAnnotations()
                owner.addInitialAnnotations(annotations: annotations)
                owner.mapView.stopRotatingRefreshButton()
            }
            .disposed(by: disposeBag)

        mapView.rx.calloutAccessoryControlTapped
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, annotationView in
                guard let annotation = annotationView.1.annotation as? CustomAnnotation,
                      let uuid = annotation.uuid else {
                    return
                }
                owner.viewModel?.input.tapCapsule.onNext(uuid)
            })
            .disposed(by: disposeBag)

        mapView.refreshButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.mapView.rotateRefreshButton()
                owner.viewModel?.input.tapRefresh.onNext(())
            })
            .disposed(by: disposeBag)
    }

    private func goToCurrentLocation() {
        guard let currentLocation = locationManager.location?.coordinate else {
            return
        }

        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: currentLocation, span: span)
        mapView.setRegion(region, animated: true)

        resetMonitoringRegion(from: nil)
    }

    private func removeAllAnnotations() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }

    // MARK: 처음 Annotation 그릴 때 사용

    private func addInitialAnnotations(annotations: [CustomAnnotation]) {
//        let annotations = coordinates.map { CustomAnnotation(coordinate: $0) }
        updateAnnotationsToMonitor(annotations)
        mapView.addAnnotations(annotations)
    }

    private func updateAnnotationsToMonitor(_ annotations: [CustomAnnotation]) {
        guard let currentLocation = locationManager.location else {
            return
        }

        annotationsToMonitor = annotations.filter {
            let distance = currentLocation.distance(from: CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude))

            return distance <= Settings.monitoringRange
        }
    }

    // MARK: Region 업데이트 및 AnnotationsToMonitor 새로 계산

    private func resetMonitoringRegion(from previousRegion: CLRegion?) {
        guard let currentLocation = locationManager.location?.coordinate else {
            return
        }

        let customAnnotations = mapView.annotations.compactMap { $0 as? CustomAnnotation }
        updateAnnotationsToMonitor(customAnnotations)

        if let previousRegion = previousRegion {
            locationManager.stopMonitoring(for: previousRegion)
        }

        let newRegion = CLCircularRegion(
            center: currentLocation,
            radius: Settings.monitoringUpdateRange,
            identifier: "regionsToMonitor"
        )

        newRegion.notifyOnExit = true

        locationManager.startMonitoring(for: newRegion)

        if let bigOverlay = bigOverlay {
            mapView.removeOverlay(bigOverlay)
        }

        let bigCircle = MKCircle(center: currentLocation, radius: Settings.monitoringRange)
        mapView.addOverlay(bigCircle)
        bigOverlay = bigCircle
    }

    private func markIfOpenable() {
        guard let currentLocation = locationManager.location else {
            return
        }

        annotationsToMonitor
            .forEach {
                let distance = currentLocation.distance(from: CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude))

                $0.isOpenable = (distance <= Settings.openableRange) ? true : false
            }
    }
}

extension CapsuleMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is CustomAnnotation:
            let annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            return annotationView

        case is MKUserLocation:
            let userLocationview = MKUserLocationView(annotation: annotation, reuseIdentifier: "userLocation")
            userLocationview.zPriority = .max
            return userLocationview

        default:
            return nil
        }
    }
}
