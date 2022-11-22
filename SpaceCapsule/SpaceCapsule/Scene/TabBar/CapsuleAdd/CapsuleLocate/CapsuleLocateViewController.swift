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
    var viewModel: CapsuleLocateViewModel
    let capsuleMapView = CapsuleLocateView()
    let locationManager = CLLocationManager()
    
    init(viewModel: CapsuleLocateViewModel) {
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
        viewModel.input.isDragging
            .withUnretained(self)
            .bind { owner, isDragging in
                if isDragging {
                    owner.capsuleMapView.cursor.backgroundColor = .lightGray
                } else {
                    owner.capsuleMapView.cursor.backgroundColor = .green
                    
                }
            }.disposed(by: disposeBag)
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
        capsuleMapView.map.delegate = self
        capsuleMapView.map.mapType = MKMapType.standard
    }
    
    private func goToCurrentLocation() {
        guard let center = locationManager.location?.coordinate else {
            return
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        capsuleMapView.map.setRegion(region, animated: true)
    }

}

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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        let coordinate = mapView.region.center
        
        do {
            let request = try KakaoAPIManager.shared.getRequest(for: .coordToAddress((x: String(coordinate.longitude),
                                                                        y: String(coordinate.latitude))))
            let result: Observable<Result<KakaoResponse, NetworkError>> = NetworkManager.shared.send(request: request)
            result
                .map { result -> [Document] in
                    switch result {
                    case let .success(value):
                        return value.documents
                    case let .failure(error):
                        print(error)
                        return []
                    }
                }
                .subscribe(onNext: {
                    let address = $0.first?.address
                    print("\(address?.region1DepthName ?? "") \(address?.region2DepthName ?? "")")
                })
                .disposed(by: disposeBag)
        } catch {
            print(error)
        }
    }
    
}

extension CapsuleLocateViewController: UIGestureRecognizerDelegate {
    private func configureGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(sender:)))
        panGesture.delegate = self
        capsuleMapView.map.addGestureRecognizer(panGesture)
    }
    
    @objc func drag(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            viewModel.input.isDragging.accept(true)
        case .ended, .cancelled:
            viewModel.input.isDragging.accept(false)
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       return true
    }
}
