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
        
        // MARK: LocationManager
        locationManager.rx.didChangeAuthorization.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, status in
                owner.implementStatus(status)
            })
            .disposed(by: disposeBag)
        
        locationManager.rx.didUpdateLocations.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, locations in
                if let location = locations.last {
                    //owner.addCircleLocation(at: location.coordinate)
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: MapView
        capsuleMapView.map.rx.calloutAccessoryControlTapped.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                let (mapview, annotationView, button) = data
                owner.presentToDetailAlert()
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
    
    private func addAnnotations(coordinates: [CLLocationCoordinate2D]) {
        for coordinate in coordinates {
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            pin.title = "캡슐 이름"
            capsuleMapView.map.addAnnotation(pin)
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
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: center, span: span)
        capsuleMapView.map.setRegion(region, animated: true)
    }
    
    private func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}
