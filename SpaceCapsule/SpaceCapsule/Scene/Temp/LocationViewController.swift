//
//  LocationViewController.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/16.
//

import UIKit
import CoreLocation

final class LocationViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization() // 유저에게 사용자 위치 가져오기 권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도 지정
        locationManager.startUpdatingLocation() // 유저 위치 가져오기 시작
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("메모리 부족!")
    }
    
    // 사용자 위치 업데이트 될 때마다 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            print("현재 사용자 위치 - 경도: \(coordinate.latitude), 위도: \(coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 가져오기 실패!")
    }
}
