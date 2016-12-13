//
//  CoreDataHandler.swift
//  Prostate PRO-Tracker
//
//  Created by Jackson Thea on 4/29/16.
//  Copyright © 2016 Jackson Thea. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHandler: NSObject {
    static let sharedInstance = CoreDataHandler()
    
    func fetchCoreDataSurveys() -> [Survey] {
        var surveys: [Survey]
        let managedContext = Globals.appDelegate!.managedObjectContext!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Globals.surveyIdentifier)
        fetchRequest.returnsObjectsAsFaults = false
        
        //        get core data surveys
        do {
            surveys = try managedContext.fetch(fetchRequest) as! [Survey]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
        return surveys
    }
    
    func setLocalNotification() {
//        remove any notifications that are already there
        removeLocalNotifications()
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "You haven't responded in \(Int(Globals.kReminderDurationDays)) days." // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = Date().addingTimeInterval(Globals.kReminderDuration)// todo item due date (when notification will be fired)
//        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["UUID": Globals.user.uuid!, ] // assign a unique identifier to the notification so that we can retrieve it later
//        notification.category = "TODO_CATEGORY"
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func removeLocalNotifications() {
        for notification in UIApplication.shared.scheduledLocalNotifications! { // loop through notifications...
            if (notification.userInfo!["UUID"] as! String == Globals.user.uuid!) { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
                UIApplication.shared.cancelLocalNotification(notification) // there should be a maximum of one match on UUID
//                break
            }
        }
    }
    
}
