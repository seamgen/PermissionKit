    //
//  LocationAlwaysPermission.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import CoreLocation


extension Permission {
    
    public static let locationAlways: LocationAlwaysPermission = LocationAlwaysPermission()
}


public final class LocationAlwaysPermission: NSObject, RequestablePermission, CLLocationManagerDelegate {
    
    fileprivate lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    fileprivate var completion: ((PermissionStatus) -> Void)!
    
    public var status: PermissionStatus {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            return .notDetermined
        case .authorizedWhenInUse:
            return hasBeenRequested ? .denied : .notDetermined
        case .authorizedAlways:
            return .authorized
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        }
    }
        
    public var hasBeenRequested: Bool {
        return UserDefaults.standard.hasRequestedLocationAlwaysPermission
    }
    
    public func request(_ completion: @escaping (PermissionStatus) -> Void) {
        assertUsageKeyExists(.locationAlways)
        
        guard !hasBeenRequested else {
            DispatchQueue.main.async {
                completion(self.status)
            }
            return
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleForegroundNotification(_:)),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
        
        self.completion = completion
        locationManager.requestAlwaysAuthorization()
        UserDefaults.standard.hasRequestedLocationAlwaysPermission = true
    }
    
    @objc private func handleForegroundNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            NotificationCenter.default.removeObserver(self)
            self.completion(self.status)
            self.completion = nil
            self.locationManager.delegate = nil
        }
    }
}

