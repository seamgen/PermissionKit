//
//  PermissionStatus.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import Foundation


public enum PermissionStatus {
    case notDetermined
    case authorized
    case denied
    case restricted
}


extension PermissionStatus {
    
    public var isAuthorized: Bool {
        return self == .authorized
    }
    
    public var isDenied: Bool {
        return self == .denied
    }
    
    public var isRestricted: Bool {
        return self == .restricted
    }
    
    public var isNotDetermined: Bool {
        return self == .notDetermined
    }
}


extension PermissionStatus: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .notDetermined:    return "Not determined"
        case .authorized:       return "Authorized"
        case .denied:           return "Denied"
        case .restricted:       return "Restricted"
        }
    }
}
