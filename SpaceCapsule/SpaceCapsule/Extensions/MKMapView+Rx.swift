//
//  MKMapView+Rx.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/20.
//

import Foundation

import MapKit
import RxCocoa
import RxSwift

final class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, MKMapViewDelegate, DelegateProxyType {
    static func registerKnownImplementations() {
        register { mapView -> RxMKMapViewDelegateProxy in
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
        return RxMKMapViewDelegateProxy.proxy(for: base)
    }

    var calloutAccessoryControlTapped: Observable<(MKMapView, MKAnnotationView, UIButton)> {
        return delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:annotationView:calloutAccessoryControlTapped:)))
            .map { param in
                if let mapview = param[safe: 0] as? MKMapView,
                   let annotationView = param[safe: 1] as? MKAnnotationView,
                   let button = param[safe: 2] as? UIButton {
                    return (mapview, annotationView, button)
                }
                return (MKMapView(), MKAnnotationView(), UIButton())
            }
    }

    var regionDidChangeAnimated: Observable<(MKMapView)> {
        return delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map { param in
                if let mapView = param[safe: 0] as? MKMapView {
                    return (mapView)
                }
                return (MKMapView())
            }
    }

}
