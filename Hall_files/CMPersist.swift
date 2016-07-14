//
//  CMPersist.swift
//  Cardio-M
//
//  Created by E. Kevin Hall on 8/15/15.
//  Copyright (c) 2015 E. Kevin Hall. All rights reserved.
//

import UIKit
import CoreData

protocol ProfileHTMLDelegate {
  func profileHTMLReturnedWith(htmlString: String)
  func serverStatus(up: Bool)
}

enum ParseError: ErrorType {
  case MissingAttribute(message: String)
}

@objc class CMPersist: NSObject {
  static let sharedInstance = CMPersist()
  let nik = NIKApiInvoker.sharedInstance()
  
  var htmlDelegate: ProfileHTMLDelegate?
  
  var moc: NSManagedObjectContext!
  let userDefaults = NSUserDefaults.standardUserDefaults()
  
  var sessionId: String? {
    return userDefaults.objectForKey(kSessionKey) as? String
  }
  
  //MARK: - Login / Logout
  func dbSessionLogin() -> Bool {
    nik.restPath(Globals.kSessionURL,
      method: "POST",
      queryParams: [:],
      body: Globals.kUserHeader,
      headerParams: Globals.kHeaderParams,
      contentType: Globals.kContentTypeJSON,
      completionBlock: {(response: Dictionary!, error: NSError!) in
        if ((error) != nil) {
          print(">> DB Session Persist Error: \(error)")
        }
        else {
          print(">> DB Session Response: \(response)")
          let localSessionId = response["session_id"] as! String
          print("Session ID: \(localSessionId)")
          self.userDefaults.setObject(localSessionId, forKey: kSessionKey)
        }
    })
    return true
  }
  
  func dbSessionLogout() -> Bool {
    nik.restPath(Globals.kSessionURL,
      method: "DELETE",
      queryParams: [:],
      body: Globals.kUserHeader,
      headerParams: Globals.kHeaderParams,
      contentType: Globals.kContentTypeJSON,
      completionBlock: {(response: Dictionary!, error: NSError!) in
        if ((error) != nil) {
          print(">> DB Session Delete Error: \(error)")
        }
        else {
          self.userDefaults.removeObjectForKey(kSessionKey)
          print("DB closed: \(self.userDefaults.objectForKey(kSessionKey))")
        }
    })
    return true
  }
  
  //MARK: - Persist User
  func _persistUser(user: User, moc: NSManagedObjectContext) {
    var headerParams = Globals.kHeaderParams
    let session = self.userDefaults.objectForKey(kSessionKey) as! String
    var nameParent = ""
    var nameState = ""
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = "YYYY-MM-dd"
    let dobString = formatter.stringFromDate(user.dateOfBirth)
    
    let timeformatter = NSDateFormatter()
    timeformatter.dateFormat = "YYY-MM-dd HH:mm a"
    let dateAdded = timeformatter.stringFromDate(NSDate())
    
    if let parent = user.nameParent {
      nameParent = parent
    }
    
    if let state = user.stateOfResidence {
      nameState = state
    }
    
    headerParams["X-DreamFactory-Session-Token"] = session
    
    nik.restPath(Globals.kUserURL,
      method: "POST",
      queryParams: [:],
      body: ["dateAdded" : dateAdded,
        "uuidUser" : user.uuidUser,
        "uuidFamily" : user.uuidFamily,
        "dateOfBirth" : dobString,
        "state" : nameState,
        "isMale" : user.isMale,
        "nameGiven" : user.nameGiven,
        "nameParent" : nameParent,
        "willShare" : user.willShare,
        "restrictsDoctor" : user.restrictsDoctor,
        "restrictsSelf" : user.restrictsSelf,
        "positiveGenotype" : user.positivePhenotypeValue,
        "positivePhenotype" : user.positiveGenotypeValue,
        "educationType" : user.typeEducationValue,
        "cardiomyopathyType" : user.typeCardiomyopathyValue,
        "participantType" : user.typeUserValue,
        "assocCondition" : user.assocConditionValue,
        "ethnicityType" : user.typeEthnicityValue,
        "takesMeds" : user.takesMeds],
      headerParams: headerParams,
      contentType: Globals.kContentTypeJSON,
      completionBlock: {(response: Dictionary!, error: NSError!) in
        if ((error) != nil) {
          print(">> DB User Persist Error: \(error)")
          self.dbSessionLogout()
        }
        else {
          print(">> DB Session Response: \(response)")
          user.storedRemotely = true
          do {
            try moc.save()
          } catch _ {
          }
          print(">> USER remote: \(user.storedRemotely)")
          self.dbSessionLogout()
        }
    })
  }
  
  func dbPersistUser(user: User, moc: NSManagedObjectContext) {
    let group: dispatch_group_t = dispatch_group_create()
    let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    dispatch_group_enter(group)
    
    if self.sessionId == nil {
      nik.restPath(Globals.kSessionURL,
        method: "POST",
        queryParams: [:],
        body: Globals.kUserHeader,
        headerParams: Globals.kHeaderParams,
        contentType: Globals.kContentTypeJSON,
        completionBlock: {(response: Dictionary!, error: NSError!) in
          if ((error) != nil) {
            print(">> DB Session Persist Error: \(error)")
          }
          else {
            let localSessionId = response["session_id"] as! String
            
            print(">> DB Session Response: \(response)")
            print("Session ID: \(localSessionId)")
            
            self.userDefaults.setObject(localSessionId, forKey: kSessionKey)
            dispatch_group_leave(group)
          }
      })
    }
    else {
      dispatch_group_leave(group)
    }
    
    dispatch_group_notify(group, queue, {
      self._persistUser(user, moc: moc)
    })
  }
  
  //MARK: - Persist Walk
//  func _persistWalk(walk: Walk, uuidUser: String, moc: NSManagedObjectContext) {
//    var headerParams = Globals.kHeaderParams
//    let session = self.userDefaults.objectForKey(kSessionKey) as! String
//    
//    let dateFormatter = NSDateFormatter()
//    dateFormatter.dateFormat = "YYYY-MM-dd"
//    let dateString = dateFormatter.stringFromDate(walk.timeEnd!) as String
//    
//    let timeFormatter = NSDateFormatter()
//    timeFormatter.dateFormat = "HH:mm"
//    let timeString = timeFormatter.stringFromDate(walk.timeEnd!) as String
//    
//    headerParams["X-DreamFactory-Session-Token"] = session
//    print("session: \(session)")
//    
//    let hrArray = walk.heartRateMeasurements.description as String ?? "empty"
//    let hrSecondsArray = walk.heartRateSeconds.description as String ?? "empty"
//    let distanceArray = walk.distanceArray.description as String
//    let distanceSeconds = walk.distanceSeconds.description as String
//    
//    print("ARRAYS FROM PERSIST: \(hrArray) AND \(hrSecondsArray)")
//    
//    nik.restPath(Globals.kWalkURL,
//      method: "POST",
//      queryParams: [:],
//      body: ["timeEnd" : timeString,
//        "dateEnd" : dateString,
//        "totalYards" : walk.totalYards,
//        "totalSteps" : walk.totalSteps,
//        "distanceSeconds": distanceSeconds,
//        "distanceArray" : distanceArray,
//        "hrArray" : hrArray,
//        "hrSecondsArray" : hrSecondsArray,
//        "uuidUser" : uuidUser],
//      headerParams: headerParams,
//      contentType: Globals.kContentTypeJSON,
//      completionBlock: {(response: Dictionary!, error: NSError!) in
//        if ((error) != nil) {
//          print(">> DB User Persist Error: \(error)")
//          self.dbSessionLogout()
//        }
//        else {
//          print(">> DB Session Response: \(response)")
//          walk.storedRemotely = true
//          do {
//            try moc.save()
//          } catch _ {
//          }
//          print(">> WALK remote: \(walk.storedRemotely)")
//          self.dbSessionLogout()
//        }
//    })
//  }
//  
//  func dbPersistWalk(walk: Walk, uuidUser: String, moc: NSManagedObjectContext) {
//    let group: dispatch_group_t = dispatch_group_create()
//    let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//    
//    dispatch_group_enter(group)
//    
//    if self.sessionId == nil {
//      nik.restPath(Globals.kSessionURL,
//        method: "POST",
//        queryParams: [:],
//        body: Globals.kUserHeader,
//        headerParams: Globals.kHeaderParams,
//        contentType: Globals.kContentTypeJSON,
//        completionBlock: {(response: Dictionary!, error: NSError!) in
//          if ((error) != nil) {
//            print(">> DB Session Persist Error: \(error)")
//          }
//          else {
//            let localSessionId = response["session_id"] as! String
//            
//            print(">> DB Session Response: \(response)")
//            print("Session ID: \(localSessionId)")
//            
//            self.userDefaults.setObject(localSessionId, forKey: kSessionKey)
//            dispatch_group_leave(group)
//          }
//      })
//    }
//    else {
//      dispatch_group_leave(group)
//    }
//    
//    dispatch_group_notify(group, queue, {
//      self._persistWalk(walk, uuidUser: uuidUser, moc: moc)
//    })
//  }
  
  func dSort(dict: [Int: AnyObject]) -> String {
    var returnString = "["
    let sortedKeys = Array(dict.keys).sort(<)
    let count = sortedKeys.count
    for (index, key) in sortedKeys.enumerate() {
      if index != count - 1 {
        returnString = returnString + "\(key): " + "\(dict[key]!), "
      }
      else {
        returnString = returnString + "\(key): " + "\(dict[key]!)"
      }
    }
    returnString = returnString + "]"
    return returnString
  }
  
  //MARK: - Persist Survey
  func _persistSurvey(survey: Survey, user: User, moc: NSManagedObjectContext) {
    var headerParams = Globals.kHeaderParams
    let session = self.userDefaults.objectForKey(kSessionKey) as! String
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    let dateString = dateFormatter.stringFromDate(survey.dateCompleted)
    
    let timeFormatter = NSDateFormatter()
    timeFormatter.dateFormat = "HH:mm"
    let timeString = timeFormatter.stringFromDate(survey.dateCompleted)
    
    let sAnswers = "\(dSort(survey.answers))"
    let pAnswers = "\(dSort(survey.cellNumber))"
    
    print(">> COUNT: \(sAnswers.length) Answers \(sAnswers) +++ \(pAnswers)")
    
    headerParams["X-DreamFactory-Session-Token"] = session
    
    nik.restPath(Globals.kSurveyURL,
      method: "POST",
      queryParams: [:],
      body: ["dateCompleted" : dateString,
        "timeCompleted" : timeString,
        "uuidUser" : user.uuidUser,
        "sAnswers" : sAnswers,
        "pAnswers" : pAnswers,
        "typeUser" : user.typeUserValue,
        "surveyClassString" : survey.surveyClassString],
      headerParams: headerParams,
      contentType: Globals.kContentTypeJSON,
      completionBlock: {(response: Dictionary!, error: NSError!) in
        if ((error) != nil) {
          print(">> DB Survey Persist Error: \(error)")
          self.dbSessionLogout()
        }
        else {
          print(">> DB Session Response: \(response)")
          survey.storedRemotely = true
          do {
            try moc.save()
          } catch _ {
          }
          print(">> survey: \(survey.dateCompleted) remote: \(survey.storedRemotely)")
          self.dbSessionLogout()
        }
    })
  }
  
  func dbPersistSurvey(survey: Survey, user: User, moc: NSManagedObjectContext) {
    let group: dispatch_group_t = dispatch_group_create()
    let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    dispatch_group_enter(group)
    
    if self.sessionId == nil {
      nik.restPath(Globals.kSessionURL,
        method: "POST",
        queryParams: [:],
        body: Globals.kUserHeader,
        headerParams: Globals.kHeaderParams,
        contentType: Globals.kContentTypeJSON,
        completionBlock: {(response: Dictionary!, error: NSError!) in
          if ((error) != nil) {
            print(">> DB Session Persist Error: \(error)")
          }
          else {
            let localSessionId = response["session_id"] as! String
            
            print(">> DB Session Response: \(response)")
            print("Session ID: \(localSessionId)")
            
            self.userDefaults.setObject(localSessionId, forKey: kSessionKey)
            dispatch_group_leave(group)
          }
      })
    }
    else {
      dispatch_group_leave(group)
    }
    
    dispatch_group_notify(group, queue, {
      self._persistSurvey(survey, user: user, moc: moc)
    })
  }
  
  //MARK: - Persist Physician Survey
//  func _persistPhysicianSurvey(survey: PhysicianSurvey, user: User, moc: NSManagedObjectContext) {    
//    var headerParams = Globals.kHeaderParams
//    let session = self.userDefaults.objectForKey(kSessionKey) as! String
//    
//    let dateFormatter = NSDateFormatter()
//    dateFormatter.dateFormat = "YYYY-MM-dd"
//    let dateString = dateFormatter.stringFromDate(survey.dateCompleted)
//    
//    let timeFormatter = NSDateFormatter()
//    timeFormatter.dateFormat = "HH:mm"
//    let timeString = timeFormatter.stringFromDate(survey.dateCompleted)
//    
//    headerParams["X-DreamFactory-Session-Token"] = session
//    
//    nik.restPath(Globals.kPhysicianSurveyURL,
//      method: "POST",
//      queryParams: [:],
//      body: ["dateCompleted" : dateString,
//        "timeCompleted" : timeString,
//        "uuidUser" : user.uuidUser,
//       "jsonAnswers" : survey.jsonAnswers,
//        ],
//      headerParams: headerParams,
//      contentType: Globals.kContentTypeJSON,
//      completionBlock: {(response: Dictionary!, error: NSError!) in
//        if ((error) != nil) {
//          print(">> DB Survey Persist Error: \(error)")
//          self.dbSessionLogout()
//        }
//        else {
//          print(">> DB Session Response: \(response)")
//          survey.storedRemotely = true
//          do {
//            try moc.save()
//          } catch _ {
//          }
//          print(">> survey: \(survey.dateCompleted) remote: \(survey.storedRemotely)")
//          self.dbSessionLogout()
//        }
//    })
//  }
//  
//  func dbPersistPhysicianSurvey(survey: PhysicianSurvey, user: User, moc: NSManagedObjectContext) {
//    let group: dispatch_group_t = dispatch_group_create()
//    let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//    
//    dispatch_group_enter(group)
//    
//    if self.sessionId == nil {
//      nik.restPath(Globals.kSessionURL,
//        method: "POST",
//        queryParams: [:],
//        body: Globals.kUserHeader,
//        headerParams: Globals.kHeaderParams,
//        contentType: Globals.kContentTypeJSON,
//        completionBlock: {(response: Dictionary!, error: NSError!) in
//          if ((error) != nil) {
//            print(">> DB Session Persist Error: \(error)")
//          }
//          else {
//            let localSessionId = response["session_id"] as! String
//            
//            print(">> DB Session Response: \(response)")
//            print("Session ID: \(localSessionId)")
//            
//            self.userDefaults.setObject(localSessionId, forKey: kSessionKey)
//            dispatch_group_leave(group)
//          }
//      })
//    }
//    else {
//      dispatch_group_leave(group)
//    }
//    
//    dispatch_group_notify(group, queue, {
//      self._persistPhysicianSurvey(survey, user: user, moc: moc)
//    })
//    
//  }
  
//  func _getProfileHTML() {
//    var headerParams = Globals.kHeaderParams
//    let session = self.userDefaults.objectForKey(kSessionKey) as! String
//    var profileHTML: String!
//    
//    headerParams["X-DreamFactory-Session-Token"] = session
//    
//    nik.restPath(Globals.kProfileURL,
//      method: "GET",
//      queryParams: nil,
//      body: nil,
//      headerParams: headerParams,
//      contentType: Globals.kContentTypeJSON,
//      completionBlock: {(response: Dictionary!, error: NSError!) in
//        if ((error) != nil) {
//          profileHTML = "Failed Profile get inside getProfile Closure"
//          print("error: \(error)")
//          //self.htmlDelegate?.profileHTMLReturnedWith(profileHTML + ": " + error.localizedDescription)
//          self.dbSessionLogout()
//        }
//        else {
//          let bundle = NSBundle.mainBundle()
//          let cssPath = bundle.pathForResource("profile", ofType: "css")
//          let htmlPath = bundle.pathForResource("profile", ofType: "html")
//          let css = try? String(contentsOfFile: cssPath!, encoding: NSUTF8StringEncoding)
//          let html = try? String(contentsOfFile: htmlPath!, encoding: NSUTF8StringEncoding)
//          
//          if response != nil {
//            let base64String = response["content"] as! String
//            
//            let decodedData = NSData(base64EncodedString: base64String, options:NSDataBase64DecodingOptions(rawValue: 0))
//            let decodedString = NSString(data: decodedData!, encoding: NSUTF8StringEncoding) as! String
//            
//            dispatch_sync(dispatch_get_main_queue(), {self.htmlDelegate?.serverStatus(true)})
//            
//            profileHTML = css! + decodedString + html! + "</body></html>"
//            self.userDefaults.setObject(profileHTML, forKey: kProfileHTML)
//            self.userDefaults.setObject(NSDate(), forKey: kProfileHTMLLoadedDate)
//            
//          } else {
//            dispatch_sync(dispatch_get_main_queue(), {self.htmlDelegate?.serverStatus(false)})
//            profileHTML = css! + "<p class=\"error\">(Tried & Failed Server News Update)</p>" + html! + "</body></html>"
//          }
//          
//          self.htmlDelegate?.profileHTMLReturnedWith(profileHTML)
//          self.dbSessionLogout()
//        }
//    })
//  }
//  
//  func dbGetProfileHTML() {
//    let group: dispatch_group_t = dispatch_group_create()
//    let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//    var profileHTML: String!
//    var localSessionId: String!
//    
//    dispatch_group_enter(group)
//    if self.sessionId == nil {
//      
//      nik.restPath(Globals.kSessionURL,
//        method: "POST",
//        queryParams: [:],
//        body: Globals.kUserHeader,
//        headerParams: Globals.kHeaderParams,
//        contentType: Globals.kContentTypeJSON,
//        completionBlock: {(response: Dictionary!, error: NSError!) in
//          if ((error) != nil) {
//            print(">> DB Session Persist Error: \(error)")
//            dispatch_sync(dispatch_get_main_queue(), {self.htmlDelegate?.serverStatus(false)})
//            
//            let bundle = NSBundle.mainBundle()
//            let cssPath = bundle.pathForResource("profile", ofType: "css")
//            let htmlPath = bundle.pathForResource("profile", ofType: "html")
//            let css = try? String(contentsOfFile: cssPath!, encoding: NSUTF8StringEncoding)
//            let html = try? String(contentsOfFile: htmlPath!, encoding: NSUTF8StringEncoding)
//            profileHTML = css! + "<p class=\"error\">(Tried & Failed Server News Update)</p>" + html!
//            self.htmlDelegate?.profileHTMLReturnedWith(profileHTML)
//            
//          }
//          else {
//            localSessionId = response["session_id"] as! String
//            
//            print(">> DB Session Response: \(response)")
//            print("Session ID: \(localSessionId)")
//            
//            self.userDefaults.setObject(localSessionId, forKey: kSessionKey)
//            dispatch_group_leave(group)
//          }
//      })
//    }
//    else {
//      dispatch_group_leave(group)
//    }
//    
//    dispatch_group_notify(group, queue, {
//      self._getProfileHTML()
//    })
//    
//  }
  
  func _getTOS() {
    var headerParams = Globals.kHeaderParams
    let session = self.userDefaults.objectForKey(kSessionKey) as! String
    
    headerParams["X-DreamFactory-Session-Token"] = session
    
    nik.restPath(Globals.kTosUrl,
      method: "GET",
      queryParams: nil,
      body: nil,
      headerParams: headerParams,
      contentType: Globals.kContentTypeJSON,
      completionBlock: {(response: Dictionary!, error: NSError!) in
        if ((error) != nil) {
          print("error in TOS Retrieve: \(error.localizedDescription)")
          self.dbSessionLogout()
        }
        else {
          
          if response != nil {
            if let base64String = response["content"] as? String,
              let decodedData = NSData(base64EncodedString: base64String, options:NSDataBase64DecodingOptions(rawValue: 0))
            {
              let fileManager = NSFileManager.defaultManager()
              let docDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
              print("DocDir: \(docDir)")
              fileManager.createFileAtPath(docDir + "/tos_update.html", contents: decodedData, attributes: nil)
              
              self.userDefaults.setObject(NSDate(), forKey: Globals.kTos_ChckedDataDate)
              self.userDefaults.synchronize()
            }
          } else {
            print("Error in TOS Write: \(error.localizedDescription)")
          }
          
          self.dbSessionLogout()
        }
    })
  }

  
  func dbGetTOS() {
    let group: dispatch_group_t = dispatch_group_create()
    let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    var localSessionId: String!
    
    dispatch_group_enter(group)
    
    if self.sessionId == nil {
      nik.restPath(Globals.kSessionURL,
        method: "POST",
        queryParams: [:],
        body: Globals.kUserHeader,
        headerParams: Globals.kHeaderParams,
        contentType: Globals.kContentTypeJSON,
        completionBlock: {(response: Dictionary!, error: NSError!) in
          if ((error) != nil) {
            print(">> DB Session Persist Error: \(error)")
          }
          else {
            localSessionId = response["session_id"] as! String
            
            print(">> DB Session Response: \(response)")
            print("Session ID: \(localSessionId)")
            
            self.userDefaults.setObject(localSessionId, forKey: kSessionKey)
            dispatch_group_leave(group)
          }
      })
    }
    else {
      dispatch_group_leave(group)
    }
    
    dispatch_group_notify(group, queue, {
      self._getTOS()
    })
  }

  
//  func _getCohortData() {
//    var headerParams = Globals.kHeaderParams
//    let session = self.userDefaults.objectForKey(kSessionKey) as! String
//    //var profileHTML: String!
//    
//    headerParams["X-DreamFactory-Session-Token"] = session
//    
//    nik.restPath(Globals.kCohortURL,
//      method: "GET",
//      queryParams: nil,
//      body: nil,
//      headerParams: headerParams,
//      contentType: Globals.kContentTypeJSON,
//      completionBlock: {(response: Dictionary!, error: NSError!) in
//        if ((error) != nil) {
//          print("error in Cohort Retrieve: \(error.localizedDescription)")
//          self.dbSessionLogout()
//        }
//        else {
//
//          if response != nil {
//            let base64String = response["content"] as! String
//            
//            let decodedData = NSData(base64EncodedString: base64String, options:NSDataBase64DecodingOptions(rawValue: 0))
//            let decodedString = NSString(data: decodedData!, encoding: NSUTF8StringEncoding) as! String
//            let encodedData = decodedString.dataUsingEncoding(NSUTF8StringEncoding)!
//            
//            //var error: NSError?
//            do {
//              let jsonDict = try NSJSONSerialization.JSONObjectWithData(encodedData, options: []) as? NSDictionary
//              if let dict = jsonDict {
//                
//                let agearray = dict.objectForKey("agegroups") as! [NSDictionary]
//                let agegroups = agearray.first!
//                self.userDefaults.setObject(agegroups, forKey: Globals.kCohort_Age)
//                
//                let cmarray = dict.objectForKey("cardiomyopathies") as! [NSDictionary]
//                let cardiomyopathies = cmarray.first!
//                self.userDefaults.setObject(cardiomyopathies, forKey: Globals.kCohort_Cm)
//                
//                let genearray = dict.objectForKey("genes") as! [NSDictionary]
//                let genes = genearray.first!
//                self.userDefaults.setObject(genes, forKey: Globals.kCohort_Genes)
//                
//                self.userDefaults.setObject(NSDate(), forKey: Globals.kCohort_CheckedDataDate)
//                
//                self.userDefaults.synchronize()
//                
//              }
//            } catch {
//              
//            }
//            
//          } else {
//            print("Error in Cohort Decode: \(error.localizedDescription)")
//          }
//          
//          self.dbSessionLogout()
//        }
//    })
//  }
//  
//  func dbGetCohortData() {
//    let group: dispatch_group_t = dispatch_group_create()
//    let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//    var localSessionId: String!
//
//    dispatch_group_enter(group)
//    
//    if self.sessionId == nil {
//      nik.restPath(Globals.kSessionURL,
//        method: "POST",
//        queryParams: [:],
//        body: Globals.kUserHeader,
//        headerParams: Globals.kHeaderParams,
//        contentType: Globals.kContentTypeJSON,
//        completionBlock: {(response: Dictionary!, error: NSError!) in
//          if ((error) != nil) {
//            print(">> DB Session Persist Error: \(error)")
//          }
//          else {
//            localSessionId = response["session_id"] as! String
//            
//            print(">> DB Session Response: \(response)")
//            print("Session ID: \(localSessionId)")
//            
//            self.userDefaults.setObject(localSessionId, forKey: kSessionKey)
//            dispatch_group_leave(group)
//          }
//      })
//    }
//    else {
//      dispatch_group_leave(group)
//    }
//    
//    dispatch_group_notify(group, queue, {
//      self._getCohortData()
//    })
//  }
  
  func patchURLForUser(thisUser: User) -> String {
    /// %3D is url encoded from = , %22 is "
    return Globals.kUserURL + "?filter=uuidUser%3D%22" + thisUser.uuidUser + "%22"
  }
  
  func _withdrawUser(thisUser: User, date: NSDate) {
    var headerParams = Globals.kHeaderParams
    let session = self.userDefaults.objectForKey(kSessionKey) as! String
    let user = CurrentUser.sharedInstance.currentUser
    
    let timeformatter = NSDateFormatter()
    timeformatter.dateFormat = "YYY-MM-dd HH:mm a"
    let dateWithdrew = timeformatter.stringFromDate(date)
    
    headerParams["X-DreamFactory-Session-Token"] = session
    nik.restPath(patchURLForUser(user!), //Globals.kUserURL + uuidEncoded,
      method: "PATCH",
      queryParams: nil,
      body: ["withdrew" : true,
        "withdrewDate" : dateWithdrew],
      headerParams: headerParams,
      contentType: Globals.kContentTypeJSON,
      completionBlock: {(response: Dictionary!, error: NSError!) in
        if ((error) != nil) {
          print(">> DB User Persist Error: \(error)")
        }
        else {
          print(">> DB Session Response: \(response)")
        }
    })
  }
  
  func dbWithdrawUser(thisUser: User, date: NSDate) {
    let group: dispatch_group_t = dispatch_group_create()
    let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    var localSessionId: String!
    
    dispatch_group_enter(group)
    if self.sessionId == nil {
      
      nik.restPath(Globals.kSessionURL,
        method: "POST",
        queryParams: [:],
        body: Globals.kUserHeader,
        headerParams: Globals.kHeaderParams,
        contentType: Globals.kContentTypeJSON,
        completionBlock: {(response: Dictionary!, error: NSError!) in
          if ((error) != nil) {
            print(">> DB Session Persist Error: \(error)")
          }
          else {
            localSessionId = response["session_id"] as! String
            
            print(">> DB Session Response: \(response)")
            print("Session ID: \(localSessionId)")
            
            self.userDefaults.setObject(localSessionId, forKey: kSessionKey)
            dispatch_group_leave(group)
          }
      })
    }
    else {
      dispatch_group_leave(group)
    }
    
    dispatch_group_notify(group, queue, {
      self._withdrawUser(thisUser, date: date)
    })
  }
  
  func _postPDF(filename: String, fileString: String) {
    var headerParams = Globals.kHeaderParams
    let session = self.userDefaults.objectForKey(kSessionKey) as! String
    let user = CurrentUser.sharedInstance.currentUser
    var familyName: String = ""
    
    headerParams["X-DreamFactory-Session-Token"] = session
    
    let fileURL = NSURL(fileURLWithPath: fileString)
    let fileData = NSData(contentsOfURL: fileURL)
    let file: NIKFile = NIKFile(nameData: filename, mimeType: Globals.kContentTypeOctet, data: fileData)
    
    if let fname = user!.nameFamily {
      familyName = fname
    }
    
    nik.restPath(Globals.kConsentURL + filename,
      method: "POST",
      queryParams: nil,
      body: file,
      headerParams: headerParams,
      contentType: Globals.kContentTypeOctet,
      completionBlock: {(response: Dictionary!, error: NSError!) in
        if ((error) != nil) {
          print(">> DB Survey Persist Error: \(error)")
        }
        else {
          print("FILESTRING: \(fileString)")
          
          let defaults = NSUserDefaults.standardUserDefaults()
          
          // Because these are just PDFs, we set a Bool UserDefault
          // after they are persisted with the filename as a key.
          
          defaults.setBool(true, forKey: filename)
          
          print(">> DB Session Response: \(response)")
        }
    })
    
    let timeformatter = NSDateFormatter()
    timeformatter.dateFormat = "YYY-MM-dd HH:mm a"
    let dateConsented = timeformatter.stringFromDate(user!.dateEnrolled)
    
    nik.restPath(patchURLForUser(user!), //Globals.kUserURL + uuidEncoded,
      method: "PATCH",
      queryParams: nil,
      body: ["isConsented" : true,
        "nameFamily" : familyName,
        "dateConsented" : dateConsented],
      headerParams: headerParams,
      contentType: Globals.kContentTypeJSON,
      completionBlock: {(response: Dictionary!, error: NSError!) in
        if ((error) != nil) {
          print(">> DB User Persist Error: \(error)")
        }
        else {
          print(">> DB Session Response: \(response)")
        }
    })
  }
  
  
  func dbPostPDF(filename: String, fileString: String) {
    let group: dispatch_group_t = dispatch_group_create()
    let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    var localSessionId: String!
    
    dispatch_group_enter(group)
    if self.sessionId == nil {
      
      nik.restPath(Globals.kSessionURL,
        method: "POST",
        queryParams: [:],
        body: Globals.kUserHeader,
        headerParams: Globals.kHeaderParams,
        contentType: Globals.kContentTypeJSON,
        completionBlock: {(response: Dictionary!, error: NSError!) in
          if ((error) != nil) {
            print(">> DB Session Persist Error: \(error)")
          }
          else {
            localSessionId = response["session_id"] as! String
            
            print(">> DB Session Response: \(response)")
            print("Session ID: \(localSessionId)")
            
            self.userDefaults.setObject(localSessionId, forKey: kSessionKey)
            dispatch_group_leave(group)
          }
      })
    }
    else {
      dispatch_group_leave(group)
    }
    
    dispatch_group_notify(group, queue, {
      self._postPDF(filename, fileString: fileString)
    })
  }
}
