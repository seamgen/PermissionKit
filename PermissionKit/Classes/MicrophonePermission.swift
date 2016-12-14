//
//  MicrophonePermission.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import AVFoundation


extension Permission {
    
    public static let microphone: MicrophonePermission = MicrophonePermission()
}


public final class MicrophonePermission: NSObject, RequestablePermission {
    
    public var status: PermissionStatus {
        let status = AVAudioSession.sharedInstance().recordPermission()
        
        switch status {
        case AVAudioSessionRecordPermission.denied:
            return .denied
        case AVAudioSessionRecordPermission.granted:
            return .authorized
        case AVAudioSessionRecordPermission.undetermined:
            return .notDetermined
        default:
            return .notDetermined
        }
    }
    
    public var hasBeenRequested: Bool {
        return !status.isNotDetermined
    }
    
    public func request(_ completion: @escaping (PermissionStatus) -> Void) {
        self.assertUsageKeyExists(.microphone)
        
        guard !hasBeenRequested else {
            DispatchQueue.main.async {
                completion(self.status)
            }
            return
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { _ in
            DispatchQueue.main.async {
                completion(self.status)
            }
        }
    }
}

