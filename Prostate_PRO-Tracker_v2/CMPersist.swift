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
  func profileHTMLReturnedWith(_ htmlString: String)
  func serverStatus(_ up: Bool)
}

enum ParseError: Error {
  case missingAttribute(message: String)
}

let kSessionKey = "SessionKey"

@objc class CMPersist: NSObject {
  static let sharedInstance = CMPersist()
  let nik = NIKApiInvoker.sharedInstance()
  
  var htmlDelegate: ProfileHTMLDelegate?
  
  var moc: NSManagedObjectContext!
  let userDefaults = UserDefaults.standard
  
  var sessionId: String? {
    return userDefaults.object(forKey: kSessionKey) as? String
  }
  
  //MARK: - Login / Logout
  func dbSessionLogin() -> Bool {
    nik?.restPath(Globals.kSessionURL,
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
          self.userDefaults.set(localSessionId, forKey: kSessionKey)
        }
    })
    return true
  }
  
  func dbSessionLogout() -> Bool {
    nik?.restPath(Globals.kSessionURL,
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
          self.userDefaults.removeObject(forKey: kSessionKey)
          print("DB closed: \(self.userDefaults.object(forKey: kSessionKey))")
        }
    })
    return true
  }
  
  //MARK: - Persist User
  func _persistUser(_ user: User, moc: NSManagedObjectContext) {
    var headerParams = Globals.kHeaderParams
    let session = self.userDefaults.object(forKey: kSessionKey) as! String
    
    
    let timeformatter = DateFormatter()
    timeformatter.dateFormat = "YYY-MM-dd HH:mm a"
    let dateTimeAdded = Date()
    let dateTimeAddedString = timeformatter.string(from: dateTimeAdded)
    user.dateTimeAdded = dateTimeAdded

    
    headerParams["X-DreamFactory-Session-Token"] = session
    
    nik?.restPath(Globals.kUserURL,
      method: "POST",
      queryParams: [:],
      body: ["uuid" : user.uuid!,
        "dateTimeAdded" : dateTimeAddedString,
        "firstName" : user.firstName!,
        "lastName" : user.lastName!,
        "isConsented" : user.isConsented!],
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
          print(">> USER remote: \(user.storedRemotely!)")
          self.dbSessionLogout()
        }
    })
  }
  
  func dbPersistUser(_ user: User, moc: NSManagedObjectContext) {
    let group: DispatchGroup = DispatchGroup()
    let queue: DispatchQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
    
    group.enter()
    
    if self.sessionId == nil {
      nik?.restPath(Globals.kSessionURL,
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
            
            self.userDefaults.set(localSessionId, forKey: kSessionKey)
            group.leave()
          }
      })
    }
    else {
      group.leave()
    }
    
    group.notify(queue: queue, execute: {
      self._persistUser(user, moc: moc)
    })
  }
    
    func arrayToString(_ array: NSArray, type: String) ->String {
        var returnString = "["
        let count = array.count
        let questionIdentifiers = (type == Globals.surveyIdentifier) ? Globals.surveyQuestionIdentifiers : Globals.getInvolvedQuestionIdentifiers
        for (index, val) in array.enumerated() {
            let unOptionaledVal: AnyObject = val as AnyObject? ?? "nil" as AnyObject
            if index != count - 1 {
                returnString += "\(questionIdentifiers[index]): \(unOptionaledVal), "
            } else {
                returnString += "\(questionIdentifiers[index]): \(unOptionaledVal)]"
            }
        }
        return returnString
    }
  
  //MARK: - Persist Survey
  func _persistSurvey(_ survey: Survey, user: User, moc: NSManagedObjectContext) {
    var headerParams = Globals.kHeaderParams
    let session = self.userDefaults.object(forKey: kSessionKey) as! String
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYY-MM-dd HH:mm a"
    let dateTimeCompletedString = dateFormatter.string(from: survey.dateTimeCompleted as Date)
    let dateTimeAdded = Date()
    let dateTimeAddedString = dateFormatter.string(from: dateTimeAdded)
    survey.dateTimeAdded = dateTimeAdded
    
    let sAnswers = arrayToString(survey.answers, type: survey.type)
    
    print(">> COUNT: \(sAnswers.characters.count) Answers \(sAnswers)")
    
    headerParams["X-DreamFactory-Session-Token"] = session
    
    nik?.restPath(Globals.kSurveyURL,
      method: "POST",
      queryParams: [:],
      body: ["uuidUser" : user.uuid!,
        "dateTimeCompleted" : dateTimeCompletedString,
        "dateTimeAdded" : dateTimeAddedString,
        "surveyType" : survey.type,
        "sAnswers" : sAnswers],
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
          print(">> survey: \(survey.dateTimeCompleted) remote: \(survey.storedRemotely)")
          self.dbSessionLogout()
        }
    })
  }
  
  func dbPersistSurvey(_ survey: Survey, user: User, moc: NSManagedObjectContext) {
    let group: DispatchGroup = DispatchGroup()
    let queue: DispatchQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
    
    group.enter()
    
    if self.sessionId == nil {
      nik?.restPath(Globals.kSessionURL,
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
            
            self.userDefaults.set(localSessionId, forKey: kSessionKey)
            group.leave()
          }
      })
    }
    else {
      group.leave()
    }
    
    group.notify(queue: queue, execute: {
      self._persistSurvey(survey, user: user, moc: moc)
    })
  }
//
//  func _getTOS() {
//    var headerParams = Globals.kHeaderParams
//    let session = self.userDefaults.objectForKey(kSessionKey) as! String
//    
//    headerParams["X-DreamFactory-Session-Token"] = session
//    
//    nik.restPath(Globals.kTosUrl,
//      method: "GET",
//      queryParams: nil,
//      body: nil,
//      headerParams: headerParams,
//      contentType: Globals.kContentTypeJSON,
//      completionBlock: {(response: Dictionary!, error: NSError!) in
//        if ((error) != nil) {
//          print("error in TOS Retrieve: \(error.localizedDescription)")
//          self.dbSessionLogout()
//        }
//        else {
//          
//          if response != nil {
//            if let base64String = response["content"] as? String,
//              let decodedData = NSData(base64EncodedString: base64String, options:NSDataBase64DecodingOptions(rawValue: 0))
//            {
//              let fileManager = NSFileManager.defaultManager()
//              let docDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
//              print("DocDir: \(docDir)")
//              fileManager.createFileAtPath(docDir + "/tos_update.html", contents: decodedData, attributes: nil)
//              
//              self.userDefaults.setObject(NSDate(), forKey: Globals.kTos_ChckedDataDate)
//              self.userDefaults.synchronize()
//            }
//          } else {
//            print("Error in TOS Write: \(error.localizedDescription)")
//          }
//          
//          self.dbSessionLogout()
//        }
//    })
//  }
//
//  
//  func dbGetTOS() {
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
//      self._getTOS()
//    })
//  }
//  
  func patchURLForUser(_ thisUser: User) -> String {
    /// %3D is url encoded from = , %22 is "
    return Globals.kUserURL + "?filter=uuidUser%3D%22" + thisUser.uuid! + "%22"
  }
  
//  func _withdrawUser(thisUser: User, date: NSDate) {
//    var headerParams = Globals.kHeaderParams
//    let session = self.userDefaults.objectForKey(kSessionKey) as! String
//    let user = User.sharedInstance
//    
//    let timeformatter = NSDateFormatter()
//    timeformatter.dateFormat = "YYY-MM-dd HH:mm a"
//    let dateWithdrew = timeformatter.stringFromDate(date)
//    
//    headerParams["X-DreamFactory-Session-Token"] = session
//    nik.restPath(patchURLForUser(user!), //Globals.kUserURL + uuidEncoded,
//      method: "PATCH",
//      queryParams: nil,
//      body: ["withdrew" : true,
//        "withdrewDate" : dateWithdrew],
//      headerParams: headerParams,
//      contentType: Globals.kContentTypeJSON,
//      completionBlock: {(response: Dictionary!, error: NSError!) in
//        if ((error) != nil) {
//          print(">> DB User Persist Error: \(error)")
//        }
//        else {
//          print(">> DB Session Response: \(response)")
//        }
//    })
//  }
  
//  func dbWithdrawUser(thisUser: User, date: NSDate) {
//    let group: dispatch_group_t = dispatch_group_create()
//    let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
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
//      self._withdrawUser(thisUser, date: date)
//    })
//  }
  
  func _postPDF(_ filename: String, fileString: String) {
    var headerParams = Globals.kHeaderParams
    let session = self.userDefaults.object(forKey: kSessionKey) as! String
    let user = User.sharedInstance
    var familyName: String = ""
    
    headerParams["X-DreamFactory-Session-Token"] = session
    
    let fileURL = URL(fileURLWithPath: fileString)
    let fileData = try? Data(contentsOf: fileURL)
    let file: NIKFile = NIKFile(nameData: filename, mimeType: Globals.kContentTypeOctet, data: fileData)
    
    if let fname = user.lastName {
      familyName = fname
    }
    
    nik?.restPath(Globals.kConsentURL + filename,
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
          
          let defaults = UserDefaults.standard
          
          // Because these are just PDFs, we set a Bool UserDefault
          // after they are persisted with the filename as a key.
          
          defaults.set(true, forKey: filename)
          
          print(">> DB Session Response: \(response)")
        }
    })
    
    let timeformatter = DateFormatter()
    timeformatter.dateFormat = "YYY-MM-dd HH:mm a"
    let dateConsented = timeformatter.string(from: user.dateTimeAdded! as Date)
    
    nik?.restPath(patchURLForUser(user), //Globals.kUserURL + uuidEncoded,
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
  
  
  func dbPostPDF(_ filename: String, fileString: String) {
    let group: DispatchGroup = DispatchGroup()
    let queue: DispatchQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
    var localSessionId: String!
    
    group.enter()
    if self.sessionId == nil {
      
      nik?.restPath(Globals.kSessionURL,
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
            
            self.userDefaults.set(localSessionId, forKey: kSessionKey)
            group.leave()
          }
      })
    }
    else {
      group.leave()
    }
    
    group.notify(queue: queue, execute: {
      self._postPDF(filename, fileString: fileString)
    })
  }
}
