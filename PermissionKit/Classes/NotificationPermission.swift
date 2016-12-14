//
//  NotificationPermission.swift
//  Pods
//
//  Created by Sam Gerardi on 12/14/16.
//
//

import Foundation
import UserNotifications


extension Permission {
    
    public static let notification: NotificationPermission = NotificationPermission()
}


public class NotificationPermission: NSObject, RequestablePermission {
    
    fileprivate var timer: Timer?
    
    fileprivate var requestedSettings: UIUserNotificationSettings?
    
    fileprivate var completion: ((PermissionStatus) -> Void)!
    
    public var status: PermissionStatus {
        guard hasBeenRequested else { return .notDetermined }
        
        if let requestedSettings = requestedSettings, let currentSettings = UIApplication.shared.currentUserNotificationSettings {
            return requestedSettings.types == currentSettings.types ? .authorized : .notDetermined
        }
        
        return hasBeenRequested ? .denied : .notDetermined
    }
    
    public var hasBeenRequested: Bool {
        return UserDefaults.standard.hasRequestedNotificationPermission
    }
    
    public func request(_ completion: @escaping (PermissionStatus) -> Void) {
        let notificationTypes: UIUserNotificationType = [.alert, .badge, .sound]
        let settings = UIUserNotificationSettings.init(types: notificationTypes, categories: nil)
        request(withSettings: settings, completion: completion)
    }
    
    public func request(withSettings settings: UIUserNotificationSettings, completion: @escaping (PermissionStatus) -> Void) {
        self.requestedSettings = settings
        self.completion = completion
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(applicationDidBecomeActive), userInfo: nil, repeats: false)
        
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
}


extension NotificationPermission {
    
    @objc func applicationWillResignActive() {
        DispatchQueue.main.async {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self, name: .UIApplicationWillResignActive, object: nil)
            notificationCenter.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    @objc func applicationDidBecomeActive() {
        DispatchQueue.main.async {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self, name: .UIApplicationWillResignActive, object: nil)
            notificationCenter.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
            self.timer?.invalidate()
            self.timer = nil
            
            UserDefaults.standard.hasRequestedNotificationPermission = true
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.completion(self.status)
                self.completion = nil
            }
        }
    }
}
