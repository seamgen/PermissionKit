//
//  ContactsPermission.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import Contacts


extension Permission {
    
    public static let contacts: ContactsPermission = ContactsPermission()
}


public final class ContactsPermission: RequestablePermission {
    
    public var status: PermissionStatus {
        switch CNContactStore.authorizationStatus(for: .contacts) {
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
        assertUsageKeyExists(.contacts)
        
        guard !hasBeenRequested else {
            DispatchQueue.main.async {
                completion(self.status)
            }
            return
        }
        
        CNContactStore().requestAccess(for: .contacts) { _, _ in
            DispatchQueue.main.async {
                completion(self.status)
            }
        }
    }
}


