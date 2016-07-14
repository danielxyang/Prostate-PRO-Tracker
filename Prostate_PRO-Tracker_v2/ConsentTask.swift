//
//  ConsentTask.swift
//  Prostate Cancer
//
//  Created by Jackson Thea on 9/2/15.
//  Copyright (c) 2015 Jackson Thea. All rights reserved.
//

import Foundation
import ResearchKit

public var ConsentTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    //Add VisualConsentStep
    
    let consentDocument = ConsentDocument
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
    steps += [visualConsentStep]
    
    //Add ConsentReviewStep
    let signature = consentDocument.signatures!.first!
    
    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, inDocument: consentDocument)
    
    reviewConsentStep.text = "Review Consent!"
    reviewConsentStep.reasonForConsent = "Consent to join study"
    
    steps += [reviewConsentStep]
    
    return ORKOrderedTask(identifier: Globals.consentIdentifier, steps: steps)
}