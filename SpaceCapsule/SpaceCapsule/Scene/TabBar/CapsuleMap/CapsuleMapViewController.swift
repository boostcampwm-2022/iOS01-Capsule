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

final class CapsuleMapViewController: UIViewController, BaseViewController, MKMapViewDelegate {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleMapViewModel?
    let capsuleMapView = CapsuleMapView()
    let locationManager = CLLocationManager()
    var annotationsToMonitor = [CustomAnnotation]() { didSet { markIfOpenable()} }
    
    // MARK: 후에 지울 것
    var smallOverlay: MKCircle?
    var bigOverlay: MKCircle?

    override func loadView() {
        view = capsuleMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        capsuleMapView.map.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        //        capsuleMapView.map.rx.setDelegate(self)
        //            .disposed(by: disposeBag)
        
        capsuleMapView.map.delegate = self
        configure()
        goToCurrentLocation()
        bind()
        bind2()
        viewModel?.fetchAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goToCurrentLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func bind2() {
        locationManager.rx.didChangeAuthorization.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, status in
                owner.implementStatus(status)
            })
            .disposed(by: disposeBag)
        
        locationManager.rx.didUpdateLocations.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, locations in
                owner.capsuleMapView.map.removeAnnotations(owner.annotationsToMonitor)
                owner.addAnnotations(coordinates: owner.annotationsToMonitor.map{ $0.coordinate })
                if let coordinate = owner.locationManager.location?.coordinate {
                    owner.addCircleLocation(at: coordinate)
                }
            })
            .disposed(by: disposeBag)
        
        locationManager.rx.willExitMonitoringRegion.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, region in
                owner.changeMonitoring(currentRegion: region)
            })
            .disposed(by: disposeBag)
        
        capsuleMapView.map.rx.calloutAccessoryControlTapped.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                let (mapview, annotationView, button) = data
                owner.presentToDetailAlert()
            })
            .disposed(by: disposeBag)
    }
    
    func bind() {
        viewModel?.input.annotations
            .withUnretained(self)
            .bind { owner, coordinates in
                owner.removeAnnotations()
                owner.addFirstAnnotations(coordinates: coordinates)
            }
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
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
    
    private func presentToDetailAlert() {
        let alertController = UIAlertController(title: "캡슐입니다", message: "해당 캡슐로 이동할까요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func removeAnnotations() {
        if !capsuleMapView.map.annotations.isEmpty {
            let annotations = capsuleMapView.map.annotations
            capsuleMapView.map.removeAnnotations(annotations)
        }
    }
    
    private func changeMonitoring(currentRegion: CLRegion?) {
        // AnnotationsToMonitor는 여기서만 수정되어야해!!
        print("과거 region의 감시하던 annotations:\(annotationsToMonitor)")
        let customAnnotations = capsuleMapView.map.annotations.compactMap{ $0 as? CustomAnnotation }
        updateAnnotationsToMonitor(customAnnotations)

        if let currentRegion = currentRegion {
            locationManager.stopMonitoring(for: currentRegion)
        }
        
        guard let center = locationManager.location?.coordinate else { return }
        
        let newRegion = CLCircularRegion(center: center,
                                         radius: 500,
                                         identifier: "regionsToMonitor")
        
        newRegion.notifyOnExit = true
        
        if let bigOverlay = bigOverlay {
            capsuleMapView.map.removeOverlay(bigOverlay)
        }
        let circle2 = MKCircle(center: center, radius: 500)
        locationManager.startMonitoring(for: newRegion)
        capsuleMapView.map.addOverlay(circle2)
        bigOverlay = circle2
        print("현재 region의 감시하던 annotations:\(annotationsToMonitor)")
    }
    
    private func addFirstAnnotations(coordinates: [CLLocationCoordinate2D]) {
        let annotations = coordinates.map { coordinate in
            return CustomAnnotation(coordinate: coordinate)
        }
        updateAnnotationsToMonitor(annotations)
        capsuleMapView.map.addAnnotations(annotations)
    }
    
    private func addAnnotations(coordinates: [CLLocationCoordinate2D]) {
        let annotations = coordinates.map { coordinate in
            return CustomAnnotation(coordinate: coordinate)
        }
        //updateAnnotationsToMonitor(annotations)
        annotationsToMonitor = annotations
        markIfOpenable()
        capsuleMapView.map.addAnnotations(annotations)
    }
    
    // 이거는 큰 이동 때마다
    private func updateAnnotationsToMonitor(_ annotations: [CustomAnnotation]) {
        guard let currentPos = locationManager.location else { return }
        
        annotationsToMonitor = annotations.filter { currentPos.distance(from: CLLocation(latitude: $0.coordinate.latitude,
                                                                                         longitude: $0.coordinate.longitude)) <= 500}
    }
    
    // 이거는 매 이동마다
    private func markIfOpenable() {
        guard let currentPos = locationManager.location else { return }
        annotationsToMonitor.compactMap { $0 as? CustomAnnotation }.filter { currentPos.distance(from: CLLocation(latitude: $0.coordinate.latitude,
                                                                           longitude: $0.coordinate.longitude)) <= 200 }
        .forEach {
            $0.isOpenable = true
        }
    }
    
    private func configure() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        capsuleMapView.map.mapType = MKMapType.standard
        capsuleMapView.map.showsUserLocation = true
        capsuleMapView.map.setUserTrackingMode(.follow, animated: true)
        // capsuleMapView.map.isZoomEnabled = false
    }
    
    private func goToCurrentLocation() {
        guard let center = locationManager.location?.coordinate else {
            return
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: center, span: span)
        capsuleMapView.map.setRegion(region, animated: true)

        changeMonitoring(currentRegion: nil)
    }
    
    private func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func addCircleLocation(at center: CLLocationCoordinate2D) {
        // 사용자를 쫓아다니는 overlay
        if let previousOverlay = smallOverlay {
            capsuleMapView.map.removeOverlay(previousOverlay)
        }
        
        let circle = MKCircle(center: center, radius: 200)
        capsuleMapView.map.addOverlay(circle)
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
}
