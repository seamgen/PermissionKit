//
//  LocationWhenInUsePermission.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import CoreLocation


extension Permission {
    
    public static let locationWhenInUse: LocationWhenInUsePermission = LocationWhenInUsePermission()
}


public final class LocationWhenInUsePermission: NSObject, RequestablePermission {
    
    fileprivate lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    fileprivate var completion: ((PermissionStatus) -> Void)!
    
    public var status: PermissionStatus {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            return .notDetermined
        case .authorizedWhenInUse, .authorizedAlways:
            return .authorized
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        }
    }
    
    public var hasBeenRequested: Bool {
        return status != .notDetermined
    }
    
    public func request(_ completion: @escaping (PermissionStatus) -> Void) {
        assertUsageKeyExists(.locationWhenInUse)
        
        guard !hasBeenRequested else {
            DispatchQueue.main.async {
                completion(self.status)
            }
            return
        }
        
        self.completion = completion
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}


extension LocationWhenInUsePermission: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            guard status != .notDetermined else { return }
            self.completion(self.status)
            self.completion = nil
            self.locationManager.delegate = nil
        }
    }
}

