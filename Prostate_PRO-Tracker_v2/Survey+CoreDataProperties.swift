//
//  Survey+CoreDataProperties.swift
//  Prostate PRO-Tracker
//
//  Created by Jackson Thea on 4/28/16.
//  Copyright © 2016 Jackson Thea. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

class Survey: NSManagedObject {

    @NSManaged var answers: NSArray
    @NSManaged var dateTimeAdded: NSDate?
    @NSManaged var dateTimeCompleted: NSDate
    @NSManaged var storedRemotely: NSNumber
    @NSManaged var type: String

}
