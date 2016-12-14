//
//  PhotoLibraryPermission.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import Photos


extension Permission {
    
    public static let photoLibrary: PhotoLibraryPermission = PhotoLibraryPermission()
}


public final class PhotoLibraryPermission: RequestablePermission {
    
    public var status: PermissionStatus {
        switch PHPhotoLibrary.authorizationStatus() {
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
        assertUsageKeyExists(.photoLibrary)
        
        guard !hasBeenRequested else {
            DispatchQueue.main.async {
                completion(self.status)
            }
            return
        }
        
        PHPhotoLibrary.requestAuthorization { _  in
            DispatchQueue.main.async {
                completion(self.status)
            }
        }
    }
}

