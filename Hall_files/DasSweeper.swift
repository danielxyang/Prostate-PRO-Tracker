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
    let fr = NSFetchRequest(entityName: "Survey")
    fr.returnsObjectsAsFaults = false
    
    let result = (try! moc.executeFetchRequest(fr)) as! [Survey]
    for survey in result {
      print("Survey: \(survey.surveyClassString) - \(survey.uuid) - \(survey.storedRemotely)")
      if survey.storedRemotely == false {
        let user = survey.user
        print("Sending survey: \(survey.surveyClassString) == \(survey.uuid)")
        CMPersist.sharedInstance.dbPersistSurvey(survey, user: user, moc: moc)
      }
    }
  }
  
//  func sweepWalks() {
//    let fr = NSFetchRequest(entityName: "Walk")
//    fr.returnsObjectsAsFaults = false
//    
//    let result = (try! moc.executeFetchRequest(fr)) as! [Walk]
//    for walk in result {
//      // This line crashed for Michele:
//      // https://fabric.io/tengerine/ios/apps/com.ekhall.cardio-m/issues/55fb0ef2f5d3a7f76b19e68f/sessions/0c49ec68a01f47079476e2b3a57743ab
//      //println("Walk: \(walk.user.uuidUser), \(walk.totalYards) - \(walk.storedRemotely)")
//      if walk.storedRemotely == false {
//        let user = walk.user
//        if walk.totalYards.floatValue > 0 {
//          print("Sending walk: \(walk.totalYards) \(walk.timeEnd)")
//          CMPersist.sharedInstance.dbPersistWalk(walk, uuidUser: user.uuidUser, moc: moc)
//        }
//      }
//    }
//  }
  
//  func sweepMDSurveys() {
//    let fr = NSFetchRequest(entityName: "PhysicianSurvey")
//    fr.returnsObjectsAsFaults = false
//    
//    let result = (try! moc.executeFetchRequest(fr)) as! [PhysicianSurvey]
//    for survey in result {
//      print("Physician Survey: \(survey.dateCompleted) - \(survey.storedRemotely)")
//      if survey.storedRemotely == false {
//        let user = survey.user
//        print("Sending PHY SURV: \(survey.dateCompleted), user: \(survey.user.uuidUser)")
//        CMPersist.sharedInstance.dbPersistPhysicianSurvey(survey, user: user, moc: moc)
//      }
//    }
//  }
  
  func sweepUsers() {
    let fr = NSFetchRequest(entityName: "User")
    fr.returnsObjectsAsFaults = false
    
    let result = (try! moc.executeFetchRequest(fr)) as! [User]
    for user in result {
      print("User: \(user.uuidUser) - \(user.storedRemotely)")
      if user.storedRemotely == false {
        print("Sending USER: \(user.uuidUser)")
        CMPersist.sharedInstance.dbPersistUser(user, moc: moc)
      }
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
  
  func sweepTOS() {
    let tos_loadDate: NSDate? = NSUserDefaults.standardUserDefaults().objectForKey(Globals.kTos_ChckedDataDate) as? NSDate
    if let tos_loadDate = tos_loadDate {
      if ageFromDateInMinutes(tos_loadDate) > 1440 {
        print("Checking TOS")
        CMPersist.sharedInstance.dbGetTOS()
      }
      else {
        print(">> Checked TOS in last 24 hours, not rechecking")
      }
    }
    else {
      print("Checking TOS")
      CMPersist.sharedInstance.dbGetTOS()
    }
  }
  
  func sweep(sender: AnyObject) {
    print("Sweeping...")
    sweepUsers()
    sweepConsents()
    sweepSurveys()
    sweepWalks()
    sweepMDSurveys()
    sweepTOS()
  }
  
  func beginSweeping() {
    stopSweeping()
    sweepingTimer = NSTimer.scheduledTimerWithTimeInterval(interval,
      target: self,
      selector: "sweep:",
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
    beginSweeping()
  }
  
}
