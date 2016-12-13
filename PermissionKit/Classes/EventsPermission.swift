//
//  EventsPermission.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import EventKit


extension Permission {
    
    public static let events: EventsPermission = EventsPermission()
}


public final class EventsPermission: RequestablePermission {
    
    public var status: PermissionStatus {
        switch EKEventStore.authorizationStatus(for: .event) {
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
        EKEventStore().requestAccess(to: EKEntityType.event) { _, _ in
            DispatchQueue.main.async {
                completion(self.status)
            }
        }
    }
}


