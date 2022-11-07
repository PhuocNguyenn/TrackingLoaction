//
//  CLLocationManager+Rx.swift
//  TrackingLocation
//
//  Created by Phuoc Nguyen on 06/11/2022.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}


class RxCLLLoationManagerDelegateProxy:
    DelegateProxy<CLLocationManager, CLLocationManagerDelegate>,
    CLLocationManagerDelegate,
    DelegateProxyType {
    
    weak public private(set) var manager: CLLocationManager?
    
    init(manager: ParentObject) {
        self.manager = manager
        super.init(parentObject: manager,
                   delegateProxy: RxCLLLoationManagerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        register { parent in
            RxCLLLoationManagerDelegateProxy(manager: parent)
        }
    }
}


extension Reactive where Base: CLLocationManager {
    var delegate : DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLLoationManagerDelegateProxy.proxy(for: base)
    }
    
    var didUpdateLocation: Observable<[CLLocation]> {
        delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .compactMap { $0[1] as? [CLLocation] }
    }
    
    var didChangeAuthorization: Observable<CLAuthorizationStatus> {
        delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:)))
            .compactMap { $0[1] as? CLAuthorizationStatus }
    }
    
}
