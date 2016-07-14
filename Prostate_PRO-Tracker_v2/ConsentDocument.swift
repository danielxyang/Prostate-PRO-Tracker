//
//  ConsentDocument.swift
//  Prostate Cancer
//
//  Created by Jackson Thea on 9/2/15.
//  Copyright (c) 2015 Jackson Thea. All rights reserved.
//

import Foundation
import ResearchKit

public var ConsentDocument: ORKConsentDocument {
    
    let consentDocument = ORKConsentDocument()
    consentDocument.title = "Compound Authorization and Consent for Participation in a Research Project"

    
    var consentSections = [ORKConsentSection]()
    
    let welcomeSection = ORKConsentSection(type: .Overview)
    welcomeSection.title = "Invitation to Participate"
    welcomeSection.summary = "We invite you to take part in a research study at the Yale School of Medicine to learn about how patients with prostate cancer may be affected by cancer treatment. You are invited because you have been diagnosed with prostate cancer."
    welcomeSection.content = "TITLE:  Tracking your prostate-related symptoms \n\nPrincipal Investigator:\nJames B. Yu, MD \nSmilow Cancer Hospital \nNew Haven, CT 06510 \n\nFunding Source: Department of Therapeutic Radiology, Yale School of Medicine \n\nWe invite you to take part in a research study at the Yale School of Medicine to learn about how patients with prostate cancer may be affected by cancer treatment. You are invited because you have been diagnosed with prostate cancer.\n\nIn order to decide whether or not you wish to be a part of this research study you should know enough about its risks and benefits to make an informed judgment.  This consent form gives you detailed information about the research study, which a member of the research team will discuss with you.  This discussion should go over all aspects of this research: its purpose, the procedures that will be performed, any risks of the procedures, and any possible benefits.  Once you understand the study, you will be asked if you wish to participate; if so, you will be asked to sign this form."
    consentSections.append(welcomeSection)
    
    let procedureSection = ORKConsentSection(type: .DataGathering)
    procedureSection.title = "Procedures"
    procedureSection.summary = "The purpose of this research is to help doctors understand how patients feel after prostate cancer diagnosis and treatment.  This study does not involve giving you any cancer treatment as part of the study.  We will be asking you questions as part of a survey form."
    procedureSection.content = "The purpose of this research is to help doctors understand how patients feel after prostate cancer diagnosis and treatment.  This study does not involve giving you any cancer treatment as part of the study.  We will be asking you questions as part of a survey form.\n\nIf you agree to participate, you will be asked questions that will take approximately 5 to 10 minutes.  You will be asked to complete the questions on your own.\n\nWe will also review any information you volunteer about yourself and about your cancer, the type of treatment you are receiving, and medical conditions. We intend to use the answers the questions to learn how prostate cancer diagnosis and treatment may impact certain aspects of your life.\n\nFinally, you volunteer your contact information, we may contact with you for more information."
    consentSections.append(procedureSection)
    
    let riskSection = ORKConsentSection(type: .StudyTasks)
    riskSection.title = "Risks and Benefits"
    riskSection.summary = "There are minimal physical risks in taking part in this study. Although very unlikely, it is possible that answering some of the questions may cause you to feel upset or worried."
    riskSection.content = "There are minimal physical risks in taking part in this study.  Although very unlikely, it is possible that answering some of the questions may cause you to feel upset or worried.  If this happens, please let the study doctor or research assistant know.  You do not have to answer any question that you don’t want to.  You do not give up any of your legal rights by signing this consent form. \n\nThere is no cost for taking part in this study other than the time you spend completing the assessment. \n\nIt is possible that in the future the results of this research will help doctors and other patients understand how a patient’s quality of life changes after prostate cancer diagnosis and treatment."
    consentSections.append(riskSection)
    
//    let riskSection = ORKConsentSection(type: .OnlyInDocument)
//    riskSection.title = "Risks and Discomforts"
//    riskSection.content = "There are minimal physical risks in taking part in this study.  Although very unlikely, it is possible that answering some of the questions may cause you to feel upset or worried.  If this happens, please let the study doctor or research assistant know.  You do not have to answer any question that you don’t want to.  You do not give up any of your legal rights by signing this consent form."
//    consentSections.append(riskSection)
//    
//    let economicSection = ORKConsentSection(type: .OnlyInDocument)
//    economicSection.title = "Economic Considerations"
//    economicSection.content = "There is no cost for taking part in this study other than the time you spend completing the assessment."
//    consentSections.append(economicSection)
//    
//    let benefitsSection = ORKConsentSection(type: .OnlyInDocument)
//    benefitsSection.title = "Benefits"
//    benefitsSection.content = "It is possible that in the future the results of this research will help doctors and other patients understand how a patient’s quality of life changes after prostate cancer diagnosis and treatment."
//    consentSections.append(benefitsSection)
    
    let privacySection = ORKConsentSection(type: .Privacy)
    privacySection.title = "Consent and Privacy"
    privacySection.summary = "We understand that information about you obtained in connection with your health is personal, and we are committed to protecting the privacy of that information. All identifiable information that is obtained in connection with this study will remain confidential and will be disclosed only with your permission or as required by U.S. or State law."
    privacySection.content = "We understand that information about you obtained in connection with your health is personal, and we are committed to protecting the privacy of that information.  If you decide to be in this study, and if you volunteer your personal information, the researcher will get information that identifies you and your personal health information.  This may include information that might directly identify you, such as your name, address, and telephone number.  This information will be kept indefinitely.  Any information that can identify you will remain confidential.\n\nAll identifiable information that is obtained in connection with this study will remain confidential and will be disclosed only with your permission or as required by U.S. or State law.  Examples of information that we are legally required to disclose include abuse of a child or elderly person, or certain reportable diseases.  We will not put your name on the paper that has information about you and your health.\n\nWe will protect your privacy by using a study number to identify each patient.  That is, we will assign a study number to you, and create a special “key” that has your name and study number.  This key will be kept secure and available only to the PI or selected members of the research team.\n\nWe will not allow people outside the research team to see how you answered the questions or any of your personal medical information.   When the results of the research are published or discussed in conferences, no information will be included that would reveal your identity unless your specific consent for this activity is obtained.\n\nThe information about your health that will be collected in this study includes:\n-Research study records including your responses to written surveys\n-Any medical and laboratory records that you volunteer, concerning your health and treatment while you are enrolled in this Study.\n-Records about phone calls made as part of this research should you be contacted.  You will only be contacted if you volunteer your contact information.\n\nInformation about you and your health which might identify you may be used by or given to:\n-Co-Investigators and other investigators\n-Study Coordinator and Members of the Research Team.\n\nBy signing this form, you authorize the use and/or disclosure of the information described above for this research study.  The purpose for the uses and disclosures you are authorizing is to ensure that the information relating to this research is available to all parties who may need it for research purposes.\n\nAll health care providers subject to HIPAA (Health Insurance Portability and Accountability Act) are required to protect the privacy of your information.  The research staff at the Yale School of Medicine are required to comply with HIPAA and to ensure the confidentiality of your information.  You have the right to review and copy of your health information that you volunteer in accordance with institutional medical records policies."
    consentSections.append(privacySection)
    
    let timeSection = ORKConsentSection(type: .TimeCommitment)
    timeSection.summary = "This study will take about 5 minutes per day."
    timeSection.content = "This study will take about 5 minutes per day."
    consentSections.append(timeSection)
    
    
    let withdrawingSection = ORKConsentSection(type: .Withdrawing)
    withdrawingSection.title = "Voluntary Participation and Withdrawal"
    withdrawingSection.summary = "The choice of whether or not to take part in this study is yours. If you do participate, you are free to withdraw from this study at any time"
    withdrawingSection.content = "The choice of whether or not to take part in this study is yours.  Make your choice based on what we have explained to you and what you have read about the study.  If you do participate, you are free to withdraw from this study at any time. However, any information already collected with your consent will be used when data are analyzed to complete the study. You can stop answering the questions at any time and can skip any questions that you do not want to answer.  To take away, or withdraw your permission to use and disclose your health information that has been collected during this study, you must also follow up your phone call by sending a written notice to the principal investigator (name and address on page 1 of this form). This authorization to use and disclose your health information will never expire unless and until you change your mind and revoke it.  To revoke this authorization, please write to Dr. James Yu, Yale University School of Medicine, HRT 138, New Haven, CT  06520.  If you have any other questions or concerns, please ask a study nurse or your physician.  You do not waive any legal rights by signing this form."
    consentSections.append(withdrawingSection)

    
    consentDocument.sections = consentSections
    
    consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: "Patient", dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))
    
    return consentDocument
}
