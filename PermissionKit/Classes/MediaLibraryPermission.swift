//
//  MediaLibraryPermission.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import MediaPlayer


extension Permission {
    
    public static let mediaLibrary: MediaLibraryPermission = MediaLibraryPermission()
}


public final class MediaLibraryPermission: NSObject, RequestablePermission {
    
    public var status: PermissionStatus {
        switch MPMediaLibrary.authorizationStatus() {
        case .notDetermined:    return .notDetermined
        case .authorized:       return .authorized
        case .restricted:       return .restricted
        case .denied:           return .denied
        }
    }
    
    public var hasBeenRequested: Bool {
        return !status.isNotDetermined
    }
    
    public func request(_ completion: @escaping (PermissionStatus) -> Void) {
        self.assertUsageKeyExists(.mediaLibrary)
        
        guard !hasBeenRequested else {
            DispatchQueue.main.async {
                completion(self.status)
            }
            return
        }
        
        MPMediaLibrary.requestAuthorization { _ in
            DispatchQueue.main.async {
                completion(self.status)
            }
        }
    }
}

