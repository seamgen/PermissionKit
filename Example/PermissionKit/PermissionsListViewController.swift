//
//  PermissionsListViewController.swift
//  PermissionKit
//
//  Created by Sam Gerardi on 12/13/16.
//  Copyright © 2016 Seamgen. All rights reserved.
//

import UIKit
import PermissionKit


class PermissionsListViewController: UITableViewController {
    
    enum PermissionRows {
        case camera
        case contacts
        case events
        case locationAlways
        case locationWhenInUse
        case mediaLibrary
        case microphone
        case notifications
        case photoLibrary
        case reminders
        case speechRecognition
        
        var title: String {
            switch self {
            case .camera:               return "Camera"
            case .contacts:             return "Contacts"
            case .events:               return "Events"
            case .locationAlways:       return "Location Always"
            case .locationWhenInUse:    return "Location When In Use"
            case .mediaLibrary:         return "Media Library"
            case .microphone:           return "Microphone"
            case .notifications:        return "Notifications"
            case .photoLibrary:         return "Photo Library"
            case .reminders:            return "Reminders"
            case .speechRecognition:    return "Speech Recognition"
            }
        }
        
        var permission: RequestablePermission {
            switch self {
            case .camera:               return Permission.camera
            case .contacts:             return Permission.contacts
            case .events:               return Permission.events
            case .locationAlways:       return Permission.locationAlways
            case .locationWhenInUse: 	return Permission.locationWhenInUse
            case .mediaLibrary:         return Permission.mediaLibrary
            case .microphone:           return Permission.microphone
            case .notifications:        return Permission.notification
            case .photoLibrary:         return Permission.photoLibrary
            case .reminders:            return Permission.reminders
            case .speechRecognition:    return Permission.speechRecognition
            }
        }
        
        static var allRows: [PermissionRows] {
            return [.camera,
                    .contacts,
                    .events,
                    .locationWhenInUse,
                    .locationAlways,
                    .mediaLibrary,
                    .microphone,
                    .notifications,
                    .photoLibrary,
                    .reminders,
                    .speechRecognition]
        }
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonTapped))
    }
    
    
    // MARK: Methods
    
    func settingsButtonTapped() {
        let url = URL(string: UIApplicationOpenSettingsURLString)!
        UIApplication.shared.openURL(url)
    }
    
    
    // MARK: Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PermissionRows.allRows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = "Cell"
        let row = PermissionRows.allRows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: key) ?? UITableViewCell(style: .default, reuseIdentifier: key)
        cell.textLabel?.text = row.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = PermissionRows.allRows[indexPath.row]
        let viewController = PermissionViewController(row.permission, row.title)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

