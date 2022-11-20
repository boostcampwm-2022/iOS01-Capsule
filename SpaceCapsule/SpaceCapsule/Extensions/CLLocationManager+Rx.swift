//
//  CLLocationManager+Rx.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/20.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, CLLocationManagerDelegate, DelegateProxyType {
    
    static func registerKnownImplementations() {
        self.register { (manager) -> RxCLLocationManagerDelegateProxy in
               RxCLLocationManagerDelegateProxy(parentObject: manager, delegateProxy: self)
           }
    }
    
    static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
        object.delegate = delegate
    }
}

//MARK: location의 변화를 관찰할 observable 추가!
extension Reactive where Base: CLLocationManager {
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: self.base)
    }
    
    var didChangeAuthorization: Observable<CLAuthorizationStatus> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:)))
            .map { param in
                let statusNum = param[1] as? Int32
                return CLAuthorizationStatus(rawValue: statusNum ?? 0) ?? CLAuthorizationStatus.notDetermined
            }
    }
    
    // didUpdateLocations가 일어날 때마다 해당 delegate는 위치를 CLLocation으로 바꾼다
    var didUpdateLocations: Observable<[CLLocation]> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map { param in
                return param[1] as? [CLLocation] ?? []
            }
    }
}
