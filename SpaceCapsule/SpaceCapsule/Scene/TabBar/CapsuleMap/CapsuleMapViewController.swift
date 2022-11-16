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
    
    func bind() {
        
        viewModel.input.annotations
            .bind { coordinates in
                coordinates.forEach { coordinate in
                    self.addAnnotation(coordinate: coordinate)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "캡슐 이름"
        capsuleMapView.map.addAnnotation(pin)
    }
    
    private func configure() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        capsuleMapView.map.mapType = MKMapType.standard
        capsuleMapView.map.showsUserLocation = true
        capsuleMapView.map.setUserTrackingMode(.follow, animated: true)
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
    
    
}
