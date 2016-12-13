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
  var sweepingTimer: Timer?
  var interval = Globals.kSweeperInterval
  let user = User.sharedInstance
  
  var moc = Globals.appDelegate!.managedObjectContext!
  
  func ageFromDateInMinutes(_ date: Date) -> Int {
    let cal = Calendar.current
    let unit: NSCalendar.Unit = .minute
    
    let endDate = Date()
    
    let components = (cal as NSCalendar).components(unit, from: date, to: endDate, options: [])
    let minutes = components.minute
    
    return minutes!
  }
  
  func sweepSurveys() {
    let fr = NSFetchRequest<NSFetchRequestResult>(entityName: Globals.surveyIdentifier)
    fr.returnsObjectsAsFaults = false
    var result: [Survey]
    
    do {
        result = (try moc.fetch(fr)) as! [Survey]
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
    let defaults = UserDefaults.standard
    let fileManager = FileManager.default
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let contents: [AnyObject]?
    do {
      contents = try fileManager.contentsOfDirectory(atPath: docDir) as [AnyObject]?
    }
    
    catch {
      contents = nil
    }
    
    if let contents = contents {
      for item in contents {
        if item.hasSuffix(".pdf") {
          print("PDF: \(item)", terminator: "")
          if defaults.bool(forKey: item as! String) != true {
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
  
  func sweep(_ sender: AnyObject) {
    print("Sweeping...")
    sweepUsers()
    sweepConsents()
    sweepSurveys()
//    sweepTOS()
  }
  
  func beginSweeping() {
    stopSweeping()
    sweepingTimer = Timer.scheduledTimer(timeInterval: interval,
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
