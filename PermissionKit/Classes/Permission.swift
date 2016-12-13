//
//  Permission.swift
//  Pods
//
//  Created by Sam Gerardi on 12/13/16.
//
//

import Foundation





public struct Permission {
    
    private init() { }
}


public protocol RequestablePermission {
    
    var status: PermissionStatus { get }
    
    var hasBeenRequested: Bool { get }
    
    func request(_ completion: @escaping (PermissionStatus) -> Void)
}



