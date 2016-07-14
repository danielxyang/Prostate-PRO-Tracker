//
//  DasSweeper.swift
//  Cardio-M
//
//  Created by E. Kevin Hall on 9/15/15.
//  Copyright (c) 2015 E. Kevin Hall. All rights reserved.
//

import Foundation
import CoreData

class DasSweeper: NSObject {
  
  static let sharedInstance = DasSweeper()
  var sweepingTimer: NSTimer?
  var interval = Globals.kSweeperInterval
  let user = User.sharedInstance
  
  var moc = Globals.appDelegate!.managedObjectContext!
  
  func ageFromDateInMinutes(date: NSDate) -> Int {
    let cal = NSCalendar.currentCalendar()
    let unit: NSCalendarUnit = .Minute
    
    let endDate = NSDate()
    
    let components = cal.components(unit, fromDate: date, toDate: endDate, options: [])
    let minutes = components.minute
    
    return minutes
  }
  
  func sweepSurveys() {
    let fr = NSFetchRequest(entityName: Globals.surveyIdentifier)
    fr.returnsObjectsAsFaults = false
    var result: [Survey]
    
    do {
        result = (try moc.executeFetchRequest(fr)) as! [Survey]
    } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
        return
    }
    
    for survey in result {
      print("Survey: \(survey.type) - \(user.uuid) - \(survey.storedRemotely)")
      if survey.storedRemotely == false {
        print("Sending survey: \(survey.type) == \(user.uuid)")
        CMPersist.sharedInstance.dbPersistSurvey(survey, user: user, moc: moc)
      }
    }
  }
  
  func sweepUsers() {
    if user.uuid == nil {
        print("no user. Only before consent.")
        return
    }
    if user.storedRemotely == false {
        print("Sending USER: \(user.uuid)")
        CMPersist.sharedInstance.dbPersistUser(user, moc: moc)
    }
  }
  
  func sweepConsents() {
    let defaults = NSUserDefaults.standardUserDefaults()
    let fileManager = NSFileManager.defaultManager()
    let docDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let contents: [AnyObject]?
    do {
      contents = try fileManager.contentsOfDirectoryAtPath(docDir)
    }
    
    catch {
      contents = nil
    }
    
    if let contents = contents {
      for item in contents {
        if item.hasSuffix(".pdf") {
          print("PDF: \(item)", terminator: "")
          if defaults.boolForKey(item as! String) != true {
            print("... not persisted!")
            CMPersist.sharedInstance.dbPostPDF(item as! String, fileString: docDir + "/" + (item as! String))
          }
          else {
            print("... is persisted in defaults")
          }
        }
      }
    }
  }
  
//  func sweepTOS() {
//    let tos_loadDate: NSDate? = NSUserDefaults.standardUserDefaults().objectForKey(Globals.kTos_ChckedDataDate) as? NSDate
//    if let tos_loadDate = tos_loadDate {
//      if ageFromDateInMinutes(tos_loadDate) > 1440 {
//        print("Checking TOS")
//        CMPersist.sharedInstance.dbGetTOS()
//      }
//      else {
//        print(">> Checked TOS in last 24 hours, not rechecking")
//      }
//    }
//    else {
//      print("Checking TOS")
//      CMPersist.sharedInstance.dbGetTOS()
//    }
//  }
  
  func sweep(sender: AnyObject) {
    print("Sweeping...")
    sweepUsers()
    sweepConsents()
    sweepSurveys()
//    sweepTOS()
  }
  
  func beginSweeping() {
    stopSweeping()
    sweepingTimer = NSTimer.scheduledTimerWithTimeInterval(interval,
      target: self,
      selector: #selector(DasSweeper.sweep(_:)),
      userInfo: nil,
      repeats: true)
  }
  
  func stopSweeping() {
    if let timer = sweepingTimer {
      timer.invalidate()
      sweepingTimer = nil
    }
  }
  
  override init() {
    super.init()
    print("sweeper initiated")
    beginSweeping()
  }
  
}
