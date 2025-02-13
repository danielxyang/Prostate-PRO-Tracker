//
//  GetInvolvedTask.swift
//  Prostate Cancer
//
//  Created by Jackson Thea on 9/14/15.
//  Copyright (c) 2015 Jackson Thea. All rights reserved.
//

import Foundation
import ResearchKit
//import APCAppCore

public var GetInvolvedTask: ORKNavigableOrderedTask {
    
    var steps = [ORKStep]()
    
    //instructions step
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Instructions"
    instructionStep.text = "The more information you provide, the more we can understand how the changes and symptoms you are feeling are due to your cancer or other personal characteristics, and the more specific information we can give to men in your shoes. If any questions make you uncomfortable or you do not wish to share that information, or if you do not know the answers, leave the answers blank."
    steps += [instructionStep]
    
    //question 1
    var questionStepTitle = "What is your date of birth?"
    var minDateComps = DateComponents()
    let myCal = Calendar.current
    minDateComps.year = 1880
    minDateComps.month = 1
    minDateComps.day = 1
    let minDate = myCal.date(from: minDateComps)!
    let dateAnswerFormat: ORKDateAnswerFormat = ORKDateAnswerFormat(style: .date, defaultDate: nil, minimumDate: minDate, maximumDate: Date(), calendar: nil)
    var questionStep = ORKQuestionStep(identifier: "questionStep1", title: questionStepTitle, answer: dateAnswerFormat)
    steps += [questionStep]
    
    
    
    //question 1
//    var questionStepTitle = "What is your age?"
//    var numericAnswerFormat: ORKNumericAnswerFormat = ORKNumericAnswerFormat(style: .Integer, unit: "Years")
//    numericAnswerFormat.minimum = 0
//    numericAnswerFormat.maximum = 120
//    var questionStep = ORKQuestionStep(identifier: "questionStep1", title: questionStepTitle, answer: numericAnswerFormat)
//    steps += [questionStep]
    
    //question 2
    questionStepTitle = "What do you identify as your race?"
    var textChoices = [
        ORKTextChoice(text: "White", value: NSNumber(value: 0)),
        ORKTextChoice(text: "Black or African-American", value: NSNumber(value: 1)),
        ORKTextChoice(text: "Hispanic", value: NSNumber(value: 2)),
        ORKTextChoice(text: "Asian", value: NSNumber(value: 3)),
        ORKTextChoice(text: "American Indian or Alaska Native", value: NSNumber(value: 4)),
        ORKTextChoice(text: "Native Hawaiian or other Pacific Islander", value: NSNumber(value: 5)),
        ORKTextChoice(text: "Other", value: NSNumber(value: 6))
    ]
    var textChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep2", title: questionStepTitle, answer: textChoiceAnswerFormat)
    steps += [questionStep]
    
    //question 2a
    questionStepTitle = "Define \"Other\""
    var textAnswerFormat: ORKTextAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
    questionStep = ORKQuestionStep(identifier: "questionStep2b", title: questionStepTitle, answer: textAnswerFormat)
    steps += [questionStep]
    
    //question 3
    questionStepTitle = "Do you know the stage of your prostate cancer?"
    textChoices = [
        ORKTextChoice(text: "Stage 0", value: NSNumber(value: 0)),
        ORKTextChoice(text: "Stage I", value: NSNumber(value: 1)),
        ORKTextChoice(text: "Stage II", value: NSNumber(value: 2)),
        ORKTextChoice(text: "Stage III", value: NSNumber(value: 3)),
        ORKTextChoice(text: "Stage IV", value: NSNumber(value: 4)),
        ORKTextChoice(text: "I don't know", value: NSNumber(value: 5))
    ]
    textChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep3", title: questionStepTitle, answer: textChoiceAnswerFormat)
    steps += [questionStep]
    
    //question 4
    questionStepTitle = "What is the T-stage of your cancer?"
    textAnswerFormat = ORKTextAnswerFormat(maximumLength: 10)
    questionStep = ORKQuestionStep(identifier: "questionStep4", title: questionStepTitle, answer: textAnswerFormat)
    steps += [questionStep]
    
    //question 5
    questionStepTitle = "Did/do you have lymph nodes with cancer in them?"
    var booleanAnswerFormat: ORKBooleanAnswerFormat = ORKBooleanAnswerFormat()
    questionStep = ORKQuestionStep(identifier: "questionStep5", title: questionStepTitle, answer: booleanAnswerFormat)
    steps += [questionStep]
    
    //question 6
    questionStepTitle = "What is the gleason score of your prostate cancer?"
    let scaleAnswerFormat: ORKScaleAnswerFormat = ORKScaleAnswerFormat(maximumValue: 10, minimumValue: 6, defaultValue: 6, step: 1)
    questionStep = ORKQuestionStep(identifier: "questionStep6", title: questionStepTitle, answer: scaleAnswerFormat)
    steps += [questionStep]
    
    //question 7
    questionStepTitle = "What is was your PSA (prostate specific antigen) level prior to starting cancer treatment (prior to any hormonal therapy)?"
    let numericAnswerFormat = ORKNumericAnswerFormat(style: .decimal, unit: "ng/mL")
    numericAnswerFormat.minimum = 0
    numericAnswerFormat.maximum = 100
    questionStep = ORKQuestionStep(identifier: "questionStep7", title: questionStepTitle, answer: numericAnswerFormat)
    steps += [questionStep]

    //question 8
    questionStepTitle = "Are you undergoing hormonal therapy (otherwise known as androgen-deprivation therapy or anti-testosterone therapy) to lower or block testosterone in your body?"
    booleanAnswerFormat = ORKBooleanAnswerFormat()
    questionStep = ORKQuestionStep(identifier: "questionStep8", title: questionStepTitle, answer: booleanAnswerFormat)
    steps += [questionStep]
    
    //question 9
    questionStepTitle = "Did you get surgery (removal of the prostate)?"
    booleanAnswerFormat = ORKBooleanAnswerFormat()
    questionStep = ORKQuestionStep(identifier: "questionStep9", title: questionStepTitle, answer: booleanAnswerFormat)
    steps += [questionStep]
    
    //question 10
    questionStepTitle = "Did you undergo a robotic assisted surgery (minimally invasive)?"
    booleanAnswerFormat = ORKBooleanAnswerFormat()
    questionStep = ORKQuestionStep(identifier: "questionStep10", title: questionStepTitle, answer: booleanAnswerFormat)
    steps += [questionStep]
    
    //question 11
    questionStepTitle = "Did you undergo an open surgery (without a robot or laparoscopic assistance)?"
    booleanAnswerFormat = ORKBooleanAnswerFormat()
    questionStep = ORKQuestionStep(identifier: "questionStep11", title: questionStepTitle, answer: booleanAnswerFormat)
    steps += [questionStep]
    
    //question 12
    questionStepTitle = "Did you get radiation treatment?"
    booleanAnswerFormat = ORKBooleanAnswerFormat()
    questionStep = ORKQuestionStep(identifier: "questionStep12", title: questionStepTitle, answer: booleanAnswerFormat)
    steps += [questionStep]
    
    //question 13
    questionStepTitle = "What type of radiation treatment did you get?"
    textChoices = [
        ORKTextChoice(text: "Daily beam radiation - more than 30 treatments", value: NSNumber(value: 0)),
        ORKTextChoice(text: "Cyberknife or other radio surgical treatment - 1-5 treatments", value: NSNumber(value: 1)),
        ORKTextChoice(text: "Permanent radioactive seed implant", value: NSNumber(value: 2)),
        ORKTextChoice(text: "High dose rate brachytherapy", value: NSNumber(value: 3)),
        ORKTextChoice(text: "Combination of external beam and seed implant", value: NSNumber(value: 4)),
        ORKTextChoice(text: "Combination of external beam and cyberkinfe/radiosurgery", value: NSNumber(value: 5)),
        ORKTextChoice(text: "Combination of external beam and high dose rate brachytherapy", value: NSNumber(value: 6))
    ]
    textChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep13", title: questionStepTitle, answer: textChoiceAnswerFormat)
    steps += [questionStep]
    
    //question 14
    questionStepTitle = "Did you get chemotherapy (not just hormonal therapy)?"
    booleanAnswerFormat = ORKBooleanAnswerFormat()
    questionStep = ORKQuestionStep(identifier: "questionStep14", title: questionStepTitle, answer: booleanAnswerFormat)
    steps += [questionStep]



    //summary step
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Right. Off you go!"
    summaryStep.text = "That was easy!"
    steps += [summaryStep]
    
    
    let finalTask = ORKNavigableOrderedTask(identifier: Globals.getInvolvedIdentifier, steps: steps)
    
    
    //    add rule to step 2
    var resultPredicates = [ORKResultPredicate.predicateForChoiceQuestionResult(with: ORKResultSelector(resultIdentifier:"questionStep2"), expectedAnswerValue: NSNumber(value: 6))]
    
    var destinationStepIdentifiers = ["questionStep2b"]
    
    var navigationRule = ORKPredicateStepNavigationRule(resultPredicates: resultPredicates, destinationStepIdentifiers: destinationStepIdentifiers, defaultStepIdentifier: "questionStep3", validateArrays: true)
    
    finalTask.setNavigationRule(navigationRule, forTriggerStepIdentifier: "questionStep2")
    
    
    //    add rule to step 9
    resultPredicates = [ORKResultPredicate.predicateForBooleanQuestionResult(with: ORKResultSelector(resultIdentifier: "questionStep9"), expectedAnswer: false)]
    
    destinationStepIdentifiers = ["questionStep12"]
    
    navigationRule = ORKPredicateStepNavigationRule(resultPredicates: resultPredicates, destinationStepIdentifiers: destinationStepIdentifiers, defaultStepIdentifier: "questionStep10", validateArrays: true)
    
    finalTask.setNavigationRule(navigationRule, forTriggerStepIdentifier: "questionStep9")
    
    
    //    add rule to step 10
    resultPredicates = [ORKResultPredicate.predicateForBooleanQuestionResult(with: ORKResultSelector(resultIdentifier: "questionStep10"), expectedAnswer: true)]
    
    destinationStepIdentifiers = ["questionStep12"]
    
    navigationRule = ORKPredicateStepNavigationRule(resultPredicates: resultPredicates, destinationStepIdentifiers: destinationStepIdentifiers, defaultStepIdentifier: "questionStep11", validateArrays: true)
    
    finalTask.setNavigationRule(navigationRule, forTriggerStepIdentifier: "questionStep10")
    
    
    //    add rule to step 12
    resultPredicates = [ORKResultPredicate.predicateForBooleanQuestionResult(with: ORKResultSelector(resultIdentifier: "questionStep12"), expectedAnswer: false)]
    
    destinationStepIdentifiers = ["questionStep14"]
    
    navigationRule = ORKPredicateStepNavigationRule(resultPredicates: resultPredicates, destinationStepIdentifiers: destinationStepIdentifiers, defaultStepIdentifier: "questionStep13", validateArrays: true)
    
    finalTask.setNavigationRule(navigationRule, forTriggerStepIdentifier: "questionStep12")
    
    
    return finalTask
}
