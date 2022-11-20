//
//  MKMapView+Rx.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/20.
//

import Foundation

import RxSwift
import RxCocoa
import MapKit

class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, MKMapViewDelegate, DelegateProxyType {
    static func registerKnownImplementations() {
        self.register { (mapView) -> RxMKMapViewDelegateProxy in
               RxMKMapViewDelegateProxy(parentObject: mapView, delegateProxy: self)
           }
    }
    
    static func currentDelegate(for object: MKMapView) -> MKMapViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: MKMapViewDelegate?, to object: MKMapView) {
        object.delegate = delegate
    }
    
    
}

extension Reactive where Base: MKMapView {
    var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        return RxMKMapViewDelegateProxy.proxy(for: self.base)
    }
}
