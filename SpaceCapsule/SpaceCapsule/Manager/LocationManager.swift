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
    static let openableRange = 100.0
    
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
    func reverseGeocode(with point: GeoPoint) -> Observable<Address> {
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)

        return Observable.create { emitter in
            self.geocoder.reverseGeocodeLocation(location, preferredLocale: self.locale) { placemarks, error in
                guard let placemark = placemarks?.first,
                      error == nil else {
                    emitter.onError(LocationError.invalidGeopoint)
                    return
                }

                let rawValues = placemark
                    .description
                    .split(separator: ", ")
                    .map { String($0) }

                guard let rawAddress = rawValues.last(where: { $0.hasPrefix("대한민국") }),
                      let validInfo = rawAddress.components(separatedBy: "@")[safe: 0] else { // @ 아래로 불필요한 정보
                    emitter.onError(LocationError.invalidGeopoint)
                    return
                }

                var separated = validInfo.components(separatedBy: " ")
                separated.removeFirst()

                let fullAddress = separated.joined(separator: " ")
                let simpleAddress = "\(separated[safe: 0] ?? "") \(separated[safe: 1] ?? "")"

                emitter.onNext(Address(full: fullAddress, simple: simpleAddress))
            }

            return Disposables.create {}
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

    func location(_ coordinate: CLLocationCoordinate2D) -> CLLocation {
        return CLLocation(latitude: coordinate.latitude,
                          longitude: coordinate.longitude)
    }

    func distance(capsuleCoordinate: CLLocationCoordinate2D) -> Double {
        guard let currentCoordinate = coordinate else {
            return 0.0
        }
        let currentLocation = location(currentCoordinate)
        let capsuleLocation = location(capsuleCoordinate)
        return currentLocation.distance(from: capsuleLocation)
    }

    func isOpenable(capsuleCoordinate: CLLocationCoordinate2D) -> Bool {
        return distance(capsuleCoordinate: capsuleCoordinate) <= LocationManager.openableRange ? true : false
    }
}
