//
//  LocationManager.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/26.
//

import CoreLocation
import Foundation
import RxSwift

final class LocationManager {
    static let shared = LocationManager()

    private init() {}

    let core: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
        manager.requestWhenInUseAuthorization()

        return manager
    }()

    var coordinate: CLLocationCoordinate2D? {
        core.location?.coordinate
    }

    private let geocoder = CLGeocoder()
    private let locale = Locale(identifier: "ko_KR")

    // 좌표 -> 주소
    func observableAddress(with point: GeoPoint) -> Observable<Address> {
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)

        return Observable.create { emitter in
            self.coordToAddress(point: point) { address in
                guard let address else {
                    emitter.onError(LocationError.invalidGeopoint)
                    return
                }

                emitter.onNext(address)
            }

            return Disposables.create {}
        }
    }

    func coordToAddress(point: GeoPoint, completion: @escaping (Address?) -> Void) {
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)

        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            guard let placemark = placemarks?.first,
                  error == nil else {
                completion(nil)
                return
            }

            let rawValues = placemark
                .description
                .split(separator: ", ")
                .map { String($0) }

            guard let rawAddress = rawValues.last(where: { $0.hasPrefix("대한민국") }),
                  let validInfo = rawAddress.components(separatedBy: "@")[safe: 0] else { // @ 아래로 불필요한 정보
                completion(nil)
                return
            }

            var separated = validInfo.components(separatedBy: " ")
            separated.removeFirst()

            let fullAddress = separated.joined(separator: " ")
            let simpleAddress = "\(separated[safe: 0] ?? "") \(separated[safe: 1] ?? "")"

            completion(Address(full: fullAddress, simple: simpleAddress))
        }
    }

    // 위치 권한 상태 확인
    @discardableResult
    func checkAuthorization(status: CLAuthorizationStatus) -> Bool {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            core.startUpdatingLocation()
            return true

        case .restricted, .notDetermined:
            core.requestWhenInUseAuthorization()

        case .denied:
            core.requestWhenInUseAuthorization()

        @unknown default:
            return false
        }

        return false
    }
}
