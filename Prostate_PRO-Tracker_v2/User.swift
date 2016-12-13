//
//  User.swift
//  Prostate PRO-Tracker
//
//  Created by Jackson Thea on 4/16/16.
//  Copyright © 2016 Jackson Thea. All rights reserved.
//

import Foundation

class User: NSObject {
    let userDefaults = UserDefaults.standard
    
    var uuid: String? {
        set {
            userDefaults.set(newValue, forKey: Globals.userDefaultUuidKey)
        }
        get {
            return userDefaults.string(forKey: Globals.userDefaultUuidKey)
        }
    }
    var storedRemotely: Bool? {
        set {
            userDefaults.set(newValue, forKey: Globals.userDefaultStoredRemotelyKey)
        }
        get {
            return userDefaults.bool(forKey: Globals.userDefaultStoredRemotelyKey)
        }
    }
    var dateTimeAdded: Date? {
        set {
            userDefaults.set(newValue, forKey: Globals.userDefaultDateTimeAddedKey)
        }
        get {
            return userDefaults.object(forKey: Globals.userDefaultDateTimeAddedKey) as? Date
        }
    }
    var firstName: String? {
        set {
            userDefaults.set(newValue, forKey: Globals.userDefaultFirstNameKey)
        }
        get {
            return userDefaults.string(forKey: Globals.userDefaultFirstNameKey)
        }
    }
    var lastName: String? {
        set {
            userDefaults.set(newValue, forKey: Globals.userDefaultLastNameKey)
        }
        get {
            return userDefaults.string(forKey: Globals.userDefaultLastNameKey)
        }
    }
    var isConsented: Bool? {
        set {
            userDefaults.set(newValue, forKey: Globals.userDefaultIsConsented)
        }
        get {
            return userDefaults.bool(forKey: Globals.userDefaultIsConsented)
        }
    }
    
    static let sharedInstance = User()
    
    override init() {
        super.init()
    }
    
    init(uuid: String, storedRemotely: Bool, dateTimeAdded: Date, firstName: String, lastName: String, isConsented: Bool) {
        super.init()
        User.sharedInstance.uuid = uuid
        User.sharedInstance.storedRemotely = storedRemotely
        User.sharedInstance.dateTimeAdded = dateTimeAdded
        User.sharedInstance.firstName = firstName
        User.sharedInstance.lastName = lastName
        User.sharedInstance.isConsented = isConsented
    }
    
//    static let sharedInstance = User()
    
}
