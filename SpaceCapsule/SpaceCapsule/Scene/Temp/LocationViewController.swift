//
//  LocationViewController.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/16.
//

import UIKit

import CoreLocation
import RxSwift

final class LocationViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private let kakaoAPIManager = KakaoAPIManager.shared
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 유저에게 사용자 위치 가져오기 권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도 지정
        locationManager.distanceFilter = 100 // 100m내의 위치 변화일 때 didUpdateLocation 실행
        locationManager.startUpdatingLocation() // 유저 위치 가져오기 시작
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("메모리 부족!")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 가져오기 실패!")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        do {
            let request = try kakaoAPIManager.getRequest(for: .coordToAddress((x: String(coordinate.longitude),
                                                                        y: String(coordinate.latitude))))
            let result: Observable<Result<KakaoResponse, NetworkError>> = networkManager.send(request: request)
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
