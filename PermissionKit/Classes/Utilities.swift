//
//  Utilities.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import Foundation


internal enum UsageKey: String {
    case camera             = "NSCameraUsageDescription"
    case contacts           = "NSContactsUsageDescription"
    case locationWhenInUse  = "NSLocationWhenInUseUsageDescription"
    case locationAlways     = "NSLocationAlwaysUsageDescription"
    case microphone         = "NSMicrophoneUsageDescription"
    case photoLibrary       = "NSPhotoLibraryUsageDescription"
    case speechRecognition  = "NSSpeechRecognitionUsageDescription"
}


extension RequestablePermission {
    
    internal func assertUsageKeyExists(_ key: UsageKey) {
        guard (Bundle.main.object(forInfoDictionaryKey: key.rawValue) != nil) else {
            fatalError("info.plist is missing usage description for key `\(key.rawValue)`")
        }
    }
}


extension UserDefaults {
    
    internal struct Keys {
        static let hasRequestedNotificationPermission: String = "com.seamgen.permissionKit.hasRequestedNotificationPermission"
        static let hasRequestedLocationAlwaysPermission: String = "com.seamgen.permissionKit.hasRequestedLocationAlwaysPermission"
    }
    
    internal var hasRequestedNotificationPermission: Bool {
        get { return UserDefaults.standard.bool(forKey: Keys.hasRequestedNotificationPermission) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.hasRequestedNotificationPermission) }
    }
    
    internal var hasRequestedLocationAlwaysPermission: Bool {
        get { return UserDefaults.standard.bool(forKey: Keys.hasRequestedLocationAlwaysPermission) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.hasRequestedLocationAlwaysPermission) }
    }
}

