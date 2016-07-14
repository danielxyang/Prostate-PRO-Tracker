//
//  AppDelegate.swift
//  Prostate Cancer
//
//  Created by Jackson Thea on 9/2/15.
//  Copyright (c) 2015 Jackson Thea. All rights reserved.
//

import UIKit
import CoreData
import ResearchKit

struct Globals{
    static var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    static var user = User.sharedInstance
    
    static let kHostBaseURL = "https://pcardiomyopapp.medicine.yale.edu/"
    
    static let kSessionURL = kHostBaseURL + "/rest/user/session"
    static let kUserURL = kHostBaseURL + "/rest/db/p_user"
    static let kSurveyURL = kHostBaseURL + "/rest/db/p_survey"
    
    static let kConsentURL = kHostBaseURL + "/rest/files/applications/prostateapp/consent/"
    static let kProfileURL = kHostBaseURL + "/rest/files/applications/prostateapp/profile.html?include_properties=true&content=true"
    static let kTosUrl     = kHostBaseURL + "/rest/files/applications/prostateapp/tos_updated.html?include_properties=true&content=true"
    
    static let kTos_ChckedDataDate = "TOSCheckedDate"
    
    
    static let kAppName = "prostateapp"
    static let kHeaderParams = ["X-DreamFactory-Application-Name": "prostateapp"]
    static let kContentTypeJSON = "application/json"
    static let kContentTypeHTML = "text/html"
    static let kContentTypeOctet = "application/octet-stream"
    
    
    static let kUserHeader = ["email": "p_user@pcardiomyopapp.medicine.yale.edu", "password": "7kitesinthesky"]
    
    static let kRestDuration: NSTimeInterval = 0
    static let kSweeperInterval: NSTimeInterval = 20
    static let kReminderDurationDays: NSTimeInterval = 7
    static let kReminderDuration: NSTimeInterval = (kReminderDurationDays)/*numDays*/*60*60*24 /*...convert from days to seconds*/
    //    static let kReminderDuration: NSTimeInterval = 15 //for debugging (in seconds)
    
    static let ScreenHeight = UIScreen.mainScreen().bounds.size.height
    static let ScreenWidth = UIScreen.mainScreen().bounds.size.width
    
    static let kCurrentTab = "currentTab"
    
    
    static let consentIdentifier = "Consent"
    static let surveyIdentifier = "Survey"
    static let getInvolvedIdentifier = "GetInvolved"
    //    static let userIdentifier = "User"
    
    static let userDefaultUuidKey = "uuid"
    static let userDefaultStoredRemotelyKey = "storedRemotely"
    static let userDefaultDateTimeAddedKey = "dateTimeAdded"
    static let userDefaultFirstNameKey = "firstName"
    static let userDefaultLastNameKey = "lastName"
    static let userDefaultIsConsented = "isConsented"
    
    static let surveyQuestionIdentifiers = ["Urinary Function", "Urinary Control", "Number of Diapers", "Urinary Dripping", "Urination Pain", "Weak Urine Stream", "Urinating Frequently", "Rectal Pain/Urgency", "Increased BM Frequency", "Overall BM", "Ability to Orgasm", "Erection Quality", "Sexual Function", "Hot Flashes/Breast Enlargement", "Feeling Depressed", "Lack of Energy"]
    static let getInvolvedQuestionIdentifiers = ["Date of Birth", "Race", "Race Clarification", "Prostate Cancer Stage", "T-Stage", "Cancer in Lymph Nodes", "Gleason Score", "Pre-treatment PSA", "Hormonal Therapy?", "Surgery?", "Robotic Surgery?", "Open Surgery?", "Radiation?", "Radiation Type", "Chemotherapy?"]
    
    static let appBlueUI = UIColor(colorLiteralRed: 0.0, green: 122/255.0, blue: 1.0, alpha: 1.0)
    static let appBlueCG = appBlueUI.CGColor
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //        get permission for local notifications
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil))
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        CMPersist.sharedInstance.dbSessionLogout()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        CMPersist.sharedInstance.dbSessionLogin()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    
    
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.xxxx.ProjectName" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Prostate_PRO_Tracker_v2", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Prostate_PRO-Tracker_v2.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
}

