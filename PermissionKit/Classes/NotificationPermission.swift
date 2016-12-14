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
    
    fileprivate var completion: ((PermissionStatus) -> Void)!
    
    public var status: PermissionStatus {
        if UIApplication.shared.currentUserNotificationSettings?.types.isEmpty == false {
            return .authorized
        }
        
        return hasBeenRequested ? .denied : .notDetermined
    }
    
    public var hasBeenRequested: Bool {
        return UserDefaults.standard.hasRequestedNotificationPermission
    }
    
    public func request(_ completion: @escaping (PermissionStatus) -> Void) {
        if #available(iOS 10.0, *) {
            request(withOptions: [.alert, .badge, .sound], completion: completion)
        } else {
            let notificationTypes: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings.init(types: notificationTypes, categories: nil)
            request(withSettings: settings, completion: completion)
        }
    }
    
    @available(iOS, deprecated: 10.0)
    public func request(withSettings settings: UIUserNotificationSettings, completion: @escaping (PermissionStatus) -> Void) {
        guard !hasBeenRequested else {
            DispatchQueue.main.async {
                completion(self.status)
            }
            return
        }
        
        self.completion = completion
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
    @available(iOS 10.0, *)
    public func request(withOptions options: UNAuthorizationOptions, completion: @escaping (PermissionStatus) -> Void) {
        guard !hasBeenRequested else {
            DispatchQueue.main.async {
                completion(self.status)
            }
            return
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            DispatchQueue.main.async {
                UserDefaults.standard.hasRequestedNotificationPermission = true
                completion(self.status)
            }
        }
    }
}


extension NotificationPermission {
    
    @objc func applicationWillResignActive() {
        DispatchQueue.main.async {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self, name: .UIApplicationWillResignActive, object: nil)
            notificationCenter.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        }
    }
    
    @objc func applicationDidBecomeActive() {
        DispatchQueue.main.async {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self, name: .UIApplicationWillResignActive, object: nil)
            notificationCenter.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
            
            UserDefaults.standard.hasRequestedNotificationPermission = true
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.completion(self.status)
                self.completion = nil
            }
        }
    }
}
