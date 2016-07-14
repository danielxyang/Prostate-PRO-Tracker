//
//  User.swift
//  Prostate PRO-Tracker
//
//  Created by Jackson Thea on 4/16/16.
//  Copyright © 2016 Jackson Thea. All rights reserved.
//

import Foundation

class User: NSObject {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var uuid: String? {
        set {
            userDefaults.setObject(newValue, forKey: Globals.userDefaultUuidKey)
        }
        get {
            return userDefaults.stringForKey(Globals.userDefaultUuidKey)
        }
    }
    var storedRemotely: Bool? {
        set {
            userDefaults.setObject(newValue, forKey: Globals.userDefaultStoredRemotelyKey)
        }
        get {
            return userDefaults.boolForKey(Globals.userDefaultStoredRemotelyKey)
        }
    }
    var dateTimeAdded: NSDate? {
        set {
            userDefaults.setObject(newValue, forKey: Globals.userDefaultDateTimeAddedKey)
        }
        get {
            return userDefaults.objectForKey(Globals.userDefaultDateTimeAddedKey) as? NSDate
        }
    }
    var firstName: String? {
        set {
            userDefaults.setObject(newValue, forKey: Globals.userDefaultFirstNameKey)
        }
        get {
            return userDefaults.stringForKey(Globals.userDefaultFirstNameKey)
        }
    }
    var lastName: String? {
        set {
            userDefaults.setObject(newValue, forKey: Globals.userDefaultLastNameKey)
        }
        get {
            return userDefaults.stringForKey(Globals.userDefaultLastNameKey)
        }
    }
    var isConsented: Bool? {
        set {
            userDefaults.setObject(newValue, forKey: Globals.userDefaultIsConsented)
        }
        get {
            return userDefaults.boolForKey(Globals.userDefaultIsConsented)
        }
    }
    
    static let sharedInstance = User()
    
    override init() {
        super.init()
    }
    
    init(uuid: String, storedRemotely: Bool, dateTimeAdded: NSDate, firstName: String, lastName: String, isConsented: Bool) {
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