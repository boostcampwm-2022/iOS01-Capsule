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

    private let mapView = CustomRefreshableMapView()
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
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
        mapView.selectedAnnotations.removeAll()
    }

    private func configure() {
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

                if let currentLocation = owner.locationManager.location?.coordinate {
                    owner.addCircleLocation(at: currentLocation)
                }
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
            identifier: "regionsToMonitor" // TODO: ??
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
        guard let currentLocation = locationManager.location else { return }

        annotationsToMonitor
            .forEach {
                let distance = currentLocation.distance(from: CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude))

                $0.isOpenable = (distance <= Settings.openableRange) ? true : false
            }
    }
}

// TODO: Overlay 필요없을 때 삭제
extension CapsuleMapViewController: MKMapViewDelegate {
    private func addCircleLocation(at center: CLLocationCoordinate2D) {
//        if let previousOverlay = smallOverlay {
//            mapView.removeOverlay(previousOverlay)
//        }

//        let circle = MKCircle(center: center, radius: Settings.openableRange)
//        mapView.addOverlay(circle)
//        smallOverlay = circle
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
