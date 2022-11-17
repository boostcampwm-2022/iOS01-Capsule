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

final class CapsuleMapViewController: UIViewController, BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleMapViewModel
    let capsuleMapView = CapsuleMapView()
    let locationManager = CLLocationManager()
    
    init(viewModel: CapsuleMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = capsuleMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        goToCurrentLocation()
        bind()
        viewModel.fetchAnnotations()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goToCurrentLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func bind() {
        viewModel.input.annotations
            .withUnretained(self)
            .bind { owner, coordinates in
                owner.removeAnnotations()
                owner.addAnnotations(coordinates: coordinates)
            }
            .disposed(by: disposeBag)
    }
    
    private func addCircleLocation(at center: CLLocationCoordinate2D) {
        capsuleMapView.map.removeOverlays(capsuleMapView.map.overlays)
        let circle = MKCircle(center: center, radius: 10)
        capsuleMapView.map.addOverlay(circle)
    }
    
    private func removeAnnotations() {
        if !capsuleMapView.map.annotations.isEmpty {
            let annotations = capsuleMapView.map.annotations
            capsuleMapView.map.removeAnnotations(annotations)
        }
    }
    
    private func addAnnotations(coordinates: [CLLocationCoordinate2D]) {
        for coordinate in coordinates {
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            pin.title = "캡슐 이름"
            capsuleMapView.map.addAnnotation(pin)
        }
    }
    
    private func configure() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        capsuleMapView.map.delegate = self
        capsuleMapView.map.mapType = MKMapType.standard
        capsuleMapView.map.showsUserLocation = true
        capsuleMapView.map.setUserTrackingMode(.follow, animated: true)
        capsuleMapView.map.isZoomEnabled = false
    }
    
    private func goToCurrentLocation() {
        guard let center = locationManager.location?.coordinate else {
            return
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        capsuleMapView.map.setRegion(region, animated: true)
    }

    private func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { // 어노테이션이 유저의 현재 뷰가 아님을 보장
            return nil
        }
        
        var annotationView = capsuleMapView.map.dequeueReusableAnnotationView(withIdentifier: "spaceCapsule")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "spaceCapsule")
            annotationView?.canShowCallout = true // tap이 가능한지
            annotationView?.backgroundColor = .themeColor100
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(systemName: "circle")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let alertController = UIAlertController(title: "캡슐입니다", message: "해당 캡슐로 이동할까요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let center = locations.last?.coordinate else {
            print("location 위치 인식 안돼ㅁ")
            return
        }
        addCircleLocation(at: center)
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
