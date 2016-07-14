//
//  AppDelegate.swift
//  Cardio-M
//
//  Created by E. Kevin Hall on 7/10/15.
//  Copyright (c) 2015 E. Kevin Hall. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import CoreMotion
import ResearchKit

struct Globals{
  static var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
  
  static let kHostBaseURL = "https://pcardiomyopapp.medicine.yale.edu/"

  static let kSessionURL = kHostBaseURL + "/rest/user/session"
  static let kUserURL = kHostBaseURL + "/rest/db/p_user"
//  static let kWalkURL = kHostBaseURL + "/rest/db/cm_walk"
  static let kSurveyURL = kHostBaseURL + "/rest/db/p_survey"
//  static let kPhysicianSurveyURL = kHostBaseURL + "/rest/db/cm_physician"

  static let kConsentURL = kHostBaseURL + "/rest/files/applications/prostateapp/consent/"
  static let kProfileURL = kHostBaseURL + "/rest/files/applications/prostateapp/profile.html?include_properties=true&content=true"
//  static let kCohortURL  = kHostBaseURL + "/rest/files/applications/cmapp/studydata.json?include_properties=true&content=true"
  static let kTosUrl     = kHostBaseURL + "/rest/files/applications/prostateapp/tos_updated.html?include_properties=true&content=true"
  
  static let kTos_ChckedDataDate = "TOSCheckedDate"
//  static let kCohort_CheckedDataDate = "CohortCheckedDate"
//  static let kCohort_Cm = "CohortCMData"
//  static let kCohort_hcm = "hcm"
//  static let kCohort_rcm = "rcm"
//  static let kCohort_dcm = "dcm"
//  static let kCohort_nc = "nc"
//  static let kCohort_isch = "isch"
//  static let kCohort_arr = "arr"
  
//  static let kCohort_Age = "CohortAgeData"
//  static let kCohort_2to4 = "2to4"
//  static let kCohort_5to7 = "5to7"
//  static let kCohort_8to12 = "8to12"
//  static let kCohort_13to18 = "13to18"
//  static let kCohort_19to25 = "19to25"
//  static let kCohort_over25 = "over25"
  
//  static let kCohort_Genes = "CohortGeneData"
  
  static let kAppName = "prostateapp"
  static let kHeaderParams = ["X-DreamFactory-Application-Name": "prostateapp"]
  static let kContentTypeJSON = "application/json"
  static let kContentTypeHTML = "text/html"
  static let kContentTypeOctet = "application/octet-stream"

    
    static let kUserHeader = ["email": "p_user@pcardiomyopapp.medicine.yale.edu", "password": "7kitesinthesky"]
  
//  static let kWalkDuration: NSTimeInterval = 360
  static let kRestDuration: NSTimeInterval = 0
  static let kSweeperInterval: NSTimeInterval = 20
  
  static let ScreenHeight = UIScreen.mainScreen().bounds.size.height
  static let ScreenWidth = UIScreen.mainScreen().bounds.size.width
  
  static let kCurrentTab = "currentTab"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    // This app uses push notifications for support kit.
    
    // Check for Cohort Data if not there or older than 2 hours
    let loadDate: NSDate? = NSUserDefaults.standardUserDefaults().objectForKey(Globals.kCohort_CheckedDataDate) as? NSDate
    if let loadDate = loadDate {
      if ageFromDateInMinutes(loadDate) > 120 {
        CMPersist.sharedInstance.dbGetCohortData()
      }
      else {
        print(">> Checked COHORT DATA in last 2 hours, not rechecking")
      }
    }
    else {
      CMPersist.sharedInstance.dbGetCohortData()
    }
    
    let tos_loadDate: NSDate? = NSUserDefaults.standardUserDefaults().objectForKey(Globals.kTos_ChckedDataDate) as? NSDate
    if let tos_loadDate = tos_loadDate {
      if ageFromDateInMinutes(tos_loadDate) > 1440 {
        CMPersist.sharedInstance.dbGetTOS()
      }
      else {
        print(">> Checked TOS in last 24 hours, not rechecking")
      }
    }
    else {
      CMPersist.sharedInstance.dbGetTOS()
    }
    
    // Crashlytics
    Fabric.with([Crashlytics()])

    // SupportKit
    SupportKit.initWithSettings(SKTSettings(appToken: "de5yw4wafzz8gjce7vt81i3j9"))
    
    // Appearance Globals
    UIView.cmAppearanceWhenContainedIn(ORKStepViewController).tintColor = UIColor.colorFromRGB(137, g: 1, b: 54)
    UIButton.cmAppearanceWhenContainedIn(UITableViewCell).tintColor = cmRedTint
    
    UINavigationBar.appearance().barTintColor = cmKBeige
    UINavigationBar.appearance().tintColor = cmKTextGrey
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : cmKTextGrey,
      NSFontAttributeName: UIFont(name: "SFUIDisplay-Regular", size: 20.0)!]
    
    return true
  }
  
  func ageFromDateInMinutes(date: NSDate) -> Int {
    let cal = NSCalendar.currentCalendar()
    let unit: NSCalendarUnit = .Minute
    
    let endDate = NSDate()
    
    let components = cal.components(unit, fromDate: date, toDate: endDate, options: [])
    let minutes = components.minute
    
    return minutes
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
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ekhall.Cardio_M" in the application's documents Application Support directory.
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    print("Doc Dir: \(urls[urls.count-1])")
    return urls[urls.count-1] 
    }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    let modelURL = NSBundle.mainBundle().URLForResource("Cardio_M", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Cardio_M.sqlite")
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

// MARK: - UIDevice detection
private let DeviceList = [
  /* iPod 5 */          "iPod5,1": "iPod Touch 5",
  /* iPhone 4 */        "iPhone3,1":  "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4",
  /* iPhone 4S */       "iPhone4,1": "iPhone 4S",
  /* iPhone 5 */        "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
  /* iPhone 5C */       "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C",
  /* iPhone 5S */       "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
  /* iPhone 6 */        "iPhone7,2": "iPhone 6",
  /* iPhone 6 Plus */   "iPhone7,1": "iPhone 6 Plus",
  /* iPad 2 */          "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
  /* iPad 3 */          "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
  /* iPad 4 */          "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
  /* iPad Air */        "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
  /* iPad Air 2 */      "iPad5,1": "iPad Air 2", "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
  /* iPad Mini */       "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
  /* iPad Mini 2 */     "iPad4,4": "iPad Mini", "iPad4,5": "iPad Mini", "iPad4,6": "iPad Mini",
  /* iPad Mini 3 */     "iPad4,7": "iPad Mini", "iPad4,8": "iPad Mini", "iPad4,9": "iPad Mini",
  /* Simulator */       "x86_64": "Simulator", "i386": "Simulator"
]



