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
    var viewModel: CapsuleMapViewModel?
    let capsuleMapView = CapsuleMapView()
    let locationManager = CLLocationManager()
    
    override func loadView() {
        view = capsuleMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        goToCurrentLocation()
        bind()
    }
    
    func bind() {
        return
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
