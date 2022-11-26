//
//  LocationManager.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/26.
//

import CoreLocation
import Foundation
import RxSwift

struct Address {
    let full: String
    let simple: String
}

final class LocationManager {
    static let shared = LocationManager()

    private init() {}

    private let geocoder = CLGeocoder()
    private let locale = Locale(identifier: "ko_KR")

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
}
