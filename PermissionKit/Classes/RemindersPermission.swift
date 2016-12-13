//
//  RemindersPermission.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import EventKit


extension Permission {
    
    public static let reminders: RemindersPermission = RemindersPermission()
}


public final class RemindersPermission: RequestablePermission {
    
    public var status: PermissionStatus {
        switch EKEventStore.authorizationStatus(for: .reminder) {
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
        
        EKEventStore().requestAccess(to: EKEntityType.reminder) { _, _ in
            DispatchQueue.main.async {
                completion(self.status)
            }
        }
    }
}

