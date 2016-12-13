//
//  CameraPermission.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import AVFoundation


extension Permission {
    
    public static let camera: CameraPermission = CameraPermission()
}


public final class CameraPermission: RequestablePermission {
    
    public var status: PermissionStatus {
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch status {
        case .notDetermined:    return .notDetermined
        case .authorized:       return .authorized
        case .restricted:       return .restricted
        case .denied:           return .denied
        }
    }
    
    public var hasBeenRequested: Bool {
        return status != .notDetermined
    }
    
    public func request(_ completion: @escaping (PermissionStatus) -> Void) {
        assertUsageKeyExists(.camera)
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { _ in
            DispatchQueue.main.async {
                completion(self.status)
            }
        }
    }
}

