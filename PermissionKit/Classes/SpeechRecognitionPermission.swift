//
//  SpeechRecognitionPermission.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import Speech


extension Permission {
    
    public static let speechRecognition: SpeechRecognitionPermission = SpeechRecognitionPermission()
}


public final class SpeechRecognitionPermission: RequestablePermission {
    
    private func assertFrameworkIsAvailable() {
        guard #available(iOS 10.0, *) else { fatalError("The Speech framework is not available.") }
    }
    
    public var status: PermissionStatus {
        assertFrameworkIsAvailable()
        
        switch SFSpeechRecognizer.authorizationStatus() {
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
        assertFrameworkIsAvailable()
        assertUsageKeyExists(.microphone)
        assertUsageKeyExists(.speechRecognition)
        
        SFSpeechRecognizer.requestAuthorization { _ in
            DispatchQueue.main.async {
                completion(self.status)
            }
        }
    }
}

