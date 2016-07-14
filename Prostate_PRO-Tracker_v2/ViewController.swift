//
//  ViewController.swift
//  Prostate Cancer
//
//  Created by Jackson Thea on 9/2/15.
//  Copyright (c) 2015 Jackson Thea. All rights reserved.
//

import UIKit
import ResearchKit
import CoreData

class ViewController: UIViewController {
    
    let sweeper = DasSweeper.sharedInstance
    var user = User.sharedInstance
    let coreDataHandler = CoreDataHandler.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setButtonColor(consentButton)
        setButtonColor(respondButton)
        setButtonColor(getInvolvedButton)
        setButtonColor(trackResultsButton)
        setHelpButtonColor(helpButton)
        
        //only apply the blur if the user hasn't disabled transparency effects
        //        if !UIAccessibilityIsReduceTransparencyEnabled() {
        //            backgroundPicView.backgroundColor = UIColor.clearColor()
        //
        //            let blurEffect = UIBlurEffect(style: .Light)
        //            let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //            //always fill the view
        //            blurEffectView.frame = backgroundPicView.bounds
        //            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        //
        //            backgroundPicView.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        //        }
        //        else {
        //            self.view.backgroundColor = UIColor.blackColor()
        //        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let completedConsent = hasConsented()
        let oneSurveyResponse = atLeastOneSurveyResponseOfType(Globals.surveyIdentifier)
        
        respondButton.enabled = completedConsent
        getInvolvedButton.enabled = completedConsent
        consentButton.enabled = !(completedConsent)
        
        trackResultsButton.enabled = oneSurveyResponse
        
        print("uuid: \(User.sharedInstance.uuid), isConsented: \(User.sharedInstance.isConsented), storedRemotely: \(User.sharedInstance.storedRemotely)")
        
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setButtonColor(button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.borderColor = Globals.appBlueCG
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
    }
    
    func setHelpButtonColor(button:UIButton) {
        button.layer.borderWidth = 1.5
        button.layer.borderColor = Globals.appBlueCG
        
        //        button.frame = CGRectMake(0, 0, button.frame.width, button.frame.width)
        button.layer.cornerRadius = button.frame.width/2.0
    }
    
    @IBOutlet weak var consentButton: UIButton!
    @IBOutlet weak var respondButton: UIButton!
    @IBOutlet weak var getInvolvedButton: UIButton!
    @IBOutlet weak var trackResultsButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var backgroundPicView: UIImageView!
    
    @IBAction func ConsentTapped(sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
    }
    
    
    
    let errorSavingAlert = UIAlertController(
        title: "Error Saving!",
        message: "There has been an error saving your results.",
        preferredStyle: UIAlertControllerStyle.Alert
    )
    
    
    
    @IBAction func RespondTapped(sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: SurveyTask, taskRunUUID: nil)
        taskViewController.delegate = self
        
        if hasAnsweredSurveyWithin(12) {
            
            let answeredRecentlyAlert = UIAlertController(
                title: "Recent Response",
                message: "You've already responded in the last 12 hours. Are you ready to enter another response?",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            answeredRecentlyAlert.addAction(UIAlertAction(
                title: "Yes",
                style: .Default,
                handler: { (action: UIAlertAction!) in
                    self.presentViewController(taskViewController, animated: true, completion: nil)
            }))
            
            answeredRecentlyAlert.addAction(UIAlertAction(
                title: "No",
                style: .Default,
                handler: { (action: UIAlertAction!) in
            }))
            
            presentViewController(answeredRecentlyAlert, animated: true, completion: nil)
        }
        else {
            self.presentViewController(taskViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func GetInvolvedTapped(sender: UIButton) {
        
        if atLeastOneSurveyResponseOfType(Globals.getInvolvedIdentifier) {
            let alreadyCompletedAlert = UIAlertController(
                title: "Thank You!",
                message: "You have already completed this activity. Thank you for providing us with more information about your cancer and other personal characteristics. This helps us to better understand the changes and symptoms you are feeling, and will help clinicians to provide more complete information to patients in the future.",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alreadyCompletedAlert.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: { (action: UIAlertAction!) in
            }))
            
            presentViewController(alreadyCompletedAlert, animated: true, completion: nil)
        }
        else {
            let isSureAlert = UIAlertController(
                title: "Get Involved",
                message: "Would you like to get more involved in helping understand how men with prostate cancer feel?",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            isSureAlert.addAction(UIAlertAction(
                title: "Yes",
                style: .Default,
                handler: { (action: UIAlertAction!) in
                    let taskViewController = ORKTaskViewController(task: GetInvolvedTask, taskRunUUID: nil)
                    taskViewController.delegate = self
                    self.presentViewController(taskViewController, animated: true, completion: nil)
            }))
            
            isSureAlert.addAction(UIAlertAction(
                title: "No",
                style: .Default,
                handler: { (action: UIAlertAction!) in
            }))
            
            presentViewController(isSureAlert, animated: true, completion: nil)
        }
    }
    
    
    
    func hasAnsweredSurveyWithin(hours: Int) -> Bool {
        let surveys = coreDataHandler.fetchCoreDataSurveys()
        let userCalendar = NSCalendar.currentCalendar()
        
        for s in surveys where s.type == Globals.surveyIdentifier {
            let timeDifference = userCalendar.components(
                [.Hour, .Minute],
                fromDate: s.dateTimeCompleted,
                toDate: NSDate(),
                options: [])
            
            if (timeDifference.hour < hours) {
                return true
            }
        }
        return false
    }
    
    func hasConsented() -> Bool {
        if User.sharedInstance.isConsented != nil && User.sharedInstance.isConsented! {
            return true
        }
        return false
    }
    
    func atLeastOneSurveyResponseOfType(type: String) -> Bool {
        let surveys = coreDataHandler.fetchCoreDataSurveys()
        
        //        print("FETCHING CORE ENTITIES")
        for s in surveys where s.type == type {
            //            print("fetched core survey: \(s)")
            return true
        }
        return false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    start editing here. there's repeated code for delete_previous_entries, so I was gonna make it a function.
    
    //    func deletePreviousEntries(managedContext: NSManagedObjectContext, identifier: String) {
    //        // if we are going to save a "GetInvolvedTask" and there are already one or more of them in
    //        // core data, delete them before saving new on
    //        var logItems = [NSManagedObject]()
    //        let fetchRequest = NSFetchRequest(entityName: identifier)
    //
    //        // Create a new predicate that filters out any object that
    //        // doesn't have a title of "GetInvolvedTask" exactly.
    //        let predicate = NSPredicate(format: "identifier == %@", identifier)
    //
    //        // Set the predicate on the fetch request
    //        fetchRequest.predicate = predicate
    //
    //        if let fetchResults = (try? managedContext.executeFetchRequest(fetchRequest)) as? [NSManagedObject] {
    //            logItems = fetchResults
    //        }
    //        for i in logItems {
    //            managedContext.deleteObject(i)
    //        }
    //    }
    
    
    func saveConsent(managedContext: NSManagedObjectContext, results: ORKTaskResult, identifier: String) {
        var firstName = ""
        var lastName = ""
        var isConsented = false
        let consentDocument = ConsentDocument
        
        
        //        get isConsented, firstname, lastname
        for stepResult in results.results! {
            for QuestionResult in (stepResult as! ORKStepResult).results! {
                let signatureResult = QuestionResult as! ORKConsentSignatureResult
                firstName = signatureResult.signature!.givenName ?? ""
                lastName = signatureResult.signature!.familyName ?? ""
                isConsented = signatureResult.consented
                if isConsented {
                    signatureResult.signature!.title = "Participant"
                    consentDocument.signatures?[0] = signatureResult.signature!
                }
            }
        }
        
        //        if hasn't consented, don't save shit.
        if !isConsented {
            return
        }
        
        
        //        create dateTimeAdded, UUID, and user
        let now = NSDate()
        let uuid: CFUUIDRef = CFUUIDCreate(nil)
        let nonce: CFStringRef = CFUUIDCreateString(nil, uuid)
        //        var user = User.sharedInstance
        if user.uuid == nil {
            user = User(uuid: nonce as String, storedRemotely: false, dateTimeAdded: now, firstName: firstName, lastName: lastName, isConsented: isConsented)
        }
        
        //        if there are other positive consents, quit! print ERROR..?
        //        let resultsObjects = fetchCoreDataEntity(Globals.userIdentifier)
        //        for i in resultsObjects {
        //            if !((i.valueForKey("isConsented") as! NSNumber) as Bool) {
        //                managedContext.deleteObject(i)
        //            } else {
        //                print("Could not save. Entity already exists")
        //                return
        //            }
        //        }
        
        
        //        SAVE USER REMOTELY
        CMPersist.sharedInstance.dbPersistUser(user, moc: managedContext)
        ConsentWriter.persistDoc(consentDocument, withMarker: "", andUUID: user.uuid!, andName: user.lastName!)
        
        print("About to save user: \(user.uuid) \(user.storedRemotely) \(user.dateTimeAdded) \(user.firstName) \(user.lastName) \(user.isConsented)")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            errorSavingAlert.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: { (action: UIAlertAction!) in
            }))
            
            presentViewController(errorSavingAlert, animated: true, completion: nil)
            return
        }
        //         sets the new local notification
        coreDataHandler.setLocalNotification()
    }
    
    
    //    SAVE SURVEYS
    func saveSurvey(managedContext: NSManagedObjectContext, results: ORKTaskResult, identifier: String) {
        var surveyAnswers = [AnyObject]()
        
        //        store answers from ORKTastResult!
        for stepResult in results.results! {
            for QuestionResult in (stepResult as! ORKStepResult).results! {
                if let qr = QuestionResult as? ORKChoiceQuestionResult {
                    if let sr = qr.choiceAnswers?.first as? Int {
                        surveyAnswers.append(sr ?? "nil")
                    }
                } else {
                    surveyAnswers.append(((QuestionResult as!ORKQuestionResult).answer as AnyObject?) ?? "nil")
                }
            }
        }
        
        
        let survey = NSEntityDescription.insertNewObjectForEntityForName(Globals.surveyIdentifier, inManagedObjectContext: managedContext) as! Survey
        survey.storedRemotely = false
        survey.dateTimeCompleted = NSDate()
        survey.type = identifier
        survey.answers = surveyAnswers
        print("SURVEY ANS: \(survey.answers)")
        
        
        //        if we are going to save a "GetInvolvedTask" and there are already one or more of them in core
        //        data, quit! print ERROR..?
        //        if (identifier == Globals.getInvolvedIdentifier) {
        //            let fetchRequest = NSFetchRequest(entityName: identifier)
        //            if ((try? managedContext.executeFetchRequest(fetchRequest)) != nil) {
        //                print("Could not save. Entity already exists")
        //                return
        //            }
        //        }
        
        //        Send to Database!
        CMPersist.sharedInstance.dbPersistSurvey(survey, user: user, moc: managedContext)
        print("SURVEY savedRemotely?: \(survey.storedRemotely)")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            errorSavingAlert.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: { (action: UIAlertAction!) in
            }))
            
            presentViewController(errorSavingAlert, animated: true, completion: nil)
        }
        //         sets the new local notification only if was a survey
        if identifier == Globals.surveyIdentifier {
            coreDataHandler.setLocalNotification()
        }
    }
}



extension ViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        //Handle results with taskViewController.result
        
        
        switch (reason) {
        case ORKTaskViewControllerFinishReason.Completed:
            // Archive the result object first
            //            let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(taskViewController.result)
            let results = taskViewController.result
            
            // Save the data to disk with file protection
            let managedContext = Globals.appDelegate!.managedObjectContext!
            
            //        stops sweeping timer, helping prevent race condition
            sweeper.stopSweeping()
            
            if (taskViewController.result.identifier == Globals.consentIdentifier) {
                saveConsent(managedContext, results: results, identifier: taskViewController.result.identifier)
            } else {
                saveSurvey(managedContext, results: results, identifier: taskViewController.result.identifier)
            }
            
            //        restarts timer, hopefully giving enough time to send the request.
            sweeper.beginSweeping()
            
            // or upload to a remote server securely.
            
            
            // If any file results are expected, also zip up the outputDirectory.
            break
        case ORKTaskViewControllerFinishReason.Failed:
            break
        case ORKTaskViewControllerFinishReason.Discarded:
            // Generally, discard the result.
            // Consider clearing the contents of the output directory.
            break
        case ORKTaskViewControllerFinishReason.Saved:
            let data: NSData = taskViewController.restorationData!
            
            // Store the restoration data persistently for later use.
            // Normally, keep the output directory for when you will restore.
            break
        }
        
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
