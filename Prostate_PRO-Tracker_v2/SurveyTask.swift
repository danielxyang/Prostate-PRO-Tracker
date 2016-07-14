//
//  SurveyTask.swift
//  Prostate Cancer
//
//  Created by Jackson Thea on 9/2/15.
//  Copyright (c) 2015 Jackson Thea. All rights reserved.
//

import Foundation
import ResearchKit

public var SurveyTask: ORKOrderedTask {
    
//    public let numberOfSteps = 16
    
    var steps = [ORKStep]()
    
    //instructions step
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Instructions"
    instructionStep.text = "Please respond to the following survey questions. The questions will take approximately 5 minutes to complete."
    steps += [instructionStep]
    
    //question 1
    var questionStepTitle = "Overall, how much of a problem has your urinary function been for you?"
    var textChoices = [
        ORKTextChoice(text: "0-No Problem", value: 0),
        ORKTextChoice(text: "1-Very small problem", value: 1),
        ORKTextChoice(text: "2-Small problem", value: 2),
        ORKTextChoice(text: "3-Moderate problem", value: 3),
        ORKTextChoice(text: "4-Big problem", value: 4)
    ]
    var answerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    var questionStep = ORKQuestionStep(identifier: "questionStep1", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 2
    questionStepTitle = "Which of the following best describes your urinary control?"
    textChoices = [
        ORKTextChoice(text: "0-Total control", value: 0),
        ORKTextChoice(text: "1-Occasional dribbling", value: 1),
        ORKTextChoice(text: "2-Frequent dribbling", value: 2),
        ORKTextChoice(text: "4-No urinary control", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep2", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    
    //question 3
    questionStepTitle = "How many pads or adult diapers per day have you been using for urinary leakage?"
    textChoices = [
        ORKTextChoice(text: "0-None", value: 0),
        ORKTextChoice(text: "1-One pad per Day", value: 1),
        ORKTextChoice(text: "2-Two pads per Day", value: 2),
        ORKTextChoice(text: "4-Three or more pads", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep3", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    
    //question 4
    questionStepTitle = "How big a problem, if any has urinary dripping or leakage been for you?"
    textChoices = [
        ORKTextChoice(text: "0-No problem", value: 0),
        ORKTextChoice(text: "1-Very small problem", value: 1),
        ORKTextChoice(text: "2-Small problem", value: 2),
        ORKTextChoice(text: "3-Moderate problem", value: 3),
        ORKTextChoice(text: "4-Big problem", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep4", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 5
    questionStepTitle = "How big a problem, if any, has pain or burning with urination been for you?"
    textChoices = [
        ORKTextChoice(text: "0-No problem", value: 0),
        ORKTextChoice(text: "1-Very small problem", value: 1),
        ORKTextChoice(text: "2-Small problem", value: 2),
        ORKTextChoice(text: "3-Moderate problem", value: 3),
        ORKTextChoice(text: "4-Big problem", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep5", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 6
    questionStepTitle = "How big a problem, if any, has weak urine stream/incomplete bladder emptying been for you?"
    textChoices = [
        ORKTextChoice(text: "0-No problem", value: 0),
        ORKTextChoice(text: "1-Very small problem", value: 1),
        ORKTextChoice(text: "2-Small problem", value: 2),
        ORKTextChoice(text: "3-Moderate problem", value: 3),
        ORKTextChoice(text: "4-Big problem", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep6", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 7
    questionStepTitle = "How big a problem, if any, has the need to urinate frequently been for you?"
    textChoices = [
        ORKTextChoice(text: "0-No problem", value: 0),
        ORKTextChoice(text: "1-Very small problem", value: 1),
        ORKTextChoice(text: "2-Small problem", value: 2),
        ORKTextChoice(text: "3-Moderate problem", value: 3),
        ORKTextChoice(text: "4-Big problem", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep7", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 8
    questionStepTitle = "How big a problem, if any, has rectal pain or urgency of bowel movements been for you?"
    textChoices = [
        ORKTextChoice(text: "0-No problem", value: 0),
        ORKTextChoice(text: "1-Very small problem", value: 1),
        ORKTextChoice(text: "2-Small problem", value: 2),
        ORKTextChoice(text: "3-Moderate problem", value: 3),
        ORKTextChoice(text: "4-Big problem", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep8", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 9
    questionStepTitle = "How big a problem, if any, has an increased frequency of your bowel movements been for you?"
    textChoices = [
        ORKTextChoice(text: "0-No problem", value: 0),
        ORKTextChoice(text: "1-Very small problem", value: 1),
        ORKTextChoice(text: "2-Small problem", value: 2),
        ORKTextChoice(text: "3-Moderate problem", value: 3),
        ORKTextChoice(text: "4-Big problem", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep9", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 10
    questionStepTitle = "How big a problem, if any, have overall problems with your bowel movements been for you?"
    textChoices = [
        ORKTextChoice(text: "0-No problem", value: 0),
        ORKTextChoice(text: "1-Very small problem", value: 1),
        ORKTextChoice(text: "2-Small problem", value: 2),
        ORKTextChoice(text: "3-Moderate problem", value: 3),
        ORKTextChoice(text: "4-Big problem", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep10", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 11
    questionStepTitle = "How do you rate your ability to reach orgasm (climax)?"
    textChoices = [
        ORKTextChoice(text: "0-Very Good", value: 0),
        ORKTextChoice(text: "1-Good", value: 1),
        ORKTextChoice(text: "2-Fair", value: 2),
        ORKTextChoice(text: "3-Poor", value: 3),
        ORKTextChoice(text: "4-Very poor to none", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep11", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 12
    questionStepTitle = "How would you describe the usual quality of your erections?"
    textChoices = [
        ORKTextChoice(text: "0-Firm enough for intercourse", value: 0),
        ORKTextChoice(text: "1-firm enough for masturbation and foreplay", value: 1),
        ORKTextChoice(text: "2-Not firm enough for any sexual activity", value: 2),
        ORKTextChoice(text: "4-None at all", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep12", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 13
    questionStepTitle = "Overall, how much of a problem has your sexual function or lack of sexual function been for you?"
    textChoices = [
        ORKTextChoice(text: "0-No problem", value: 0),
        ORKTextChoice(text: "1-Very small problem", value: 1),
        ORKTextChoice(text: "2-Small problem", value: 2),
        ORKTextChoice(text: "3-Moderate problem", value: 3),
        ORKTextChoice(text: "4-Big problem", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep13", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 14
    questionStepTitle = "How big a problem, if any, have hot flashes or breast tenderness/enlargement been for you?"
    textChoices = [
        ORKTextChoice(text: "0-No problem", value: 0),
        ORKTextChoice(text: "1-Very small problem", value: 1),
        ORKTextChoice(text: "2-Small problem", value: 2),
        ORKTextChoice(text: "3-Moderate problem", value: 3),
        ORKTextChoice(text: "4-Big problem", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep14", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 15
    questionStepTitle = "How big a problem, if any, has feeling depressed been for you?"
    textChoices = [
        ORKTextChoice(text: "0-No problem", value: 0),
        ORKTextChoice(text: "1-Very small problem", value: 1),
        ORKTextChoice(text: "2-Small problem", value: 2),
        ORKTextChoice(text: "3-Moderate problem", value: 3),
        ORKTextChoice(text: "4-Big problem", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep15", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //question 16
    questionStepTitle = "How big a problem, if any, has a lack of energy been for you?"
    textChoices = [
        ORKTextChoice(text: "0-No problem", value: 0),
        ORKTextChoice(text: "1-Very small problem", value: 1),
        ORKTextChoice(text: "2-Small problem", value: 2),
        ORKTextChoice(text: "3-Moderate problem", value: 3),
        ORKTextChoice(text: "4-Big problem", value: 4)
    ]
    answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    questionStep = ORKQuestionStep(identifier: "questionStep16", title: questionStepTitle, answer: answerFormat)
    steps += [questionStep]
    
    //summary step
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Right. Off you go!"
    summaryStep.text = "That was easy!"
    steps += [summaryStep]
    
    for i in steps {
        i.optional = false
    }
    
    return ORKOrderedTask(identifier: Globals.surveyIdentifier, steps: steps)
}

//ORKScaleAnswerFormat
