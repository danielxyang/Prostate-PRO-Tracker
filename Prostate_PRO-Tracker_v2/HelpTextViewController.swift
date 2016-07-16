//
//  HelpTextViewController.swift
//  Prostate PRO-Tracker
//
//  Created by Jackson Thea on 7/7/16.
//  Copyright © 2016 Jackson Thea. All rights reserved.
//

import UIKit

class HelpTextViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textLabel0: UILabel!
    @IBOutlet weak var textLabel1: UILabel!
    @IBOutlet weak var textLabel2: UILabel!
    @IBOutlet weak var textLabel3: UILabel!
    @IBOutlet weak var textLabel4: UILabel!
    
    @IBOutlet weak var consentLabel: UILabel!
    @IBOutlet weak var respondLabel: UILabel!
    @IBOutlet weak var getInvolvedLabel: UILabel!
    @IBOutlet weak var trackResultsLabel: UILabel!
    
//    Prostate PRO-Tracker (the PRO stands for Patient-Reported Outcomes) to record your prostate cancer symptoms. Your input will help doctors better understand how patients feel during their prostate cancer treatment. Prostate PRO-Tracker is part of a clinical study run by Yale University researchers."
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        set normal and bold font (both have "body" style)
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        let boldFontDescriptor = fontDescriptor.fontDescriptorWithSymbolicTraits(.TraitBold)
        let boldFont = UIFont(descriptor: boldFontDescriptor, size: 20)
        let normalFont = UIFont(descriptor: fontDescriptor, size: 20)
        
        
//        load the text (with bold words and "body" style)
        var attString = NSMutableAttributedString(string: "Thank you for using ", attributes: [NSFontAttributeName : normalFont])
        attString.appendAttributedString(NSMutableAttributedString(string: "Prostate PRO-Tracker", attributes: [NSFontAttributeName : boldFont]))
        attString.appendAttributedString(NSMutableAttributedString(string: " (the PRO stands for Patient-Reported Outcomes) to record your prostate cancer symptoms. Your input will help doctors better understand how patients feel during their prostate cancer treatment. ", attributes: [NSFontAttributeName : normalFont]))
        attString.appendAttributedString(NSMutableAttributedString(string: "Prostate PRO-Tracker", attributes: [NSFontAttributeName : boldFont]))
        attString.appendAttributedString(NSMutableAttributedString(string: " is part of a clinical study run by Yale University researchers.\n\nThe application is easy to use. Simply complete the following steps:", attributes: [NSFontAttributeName : normalFont]))
        textLabel0.attributedText = attString
        
        attString = NSMutableAttributedString(string: "1. Before accessing the rest of the application, you must first consent to be involved in this study. Tap the ", attributes: [NSFontAttributeName : normalFont])
        attString.appendAttributedString(NSMutableAttributedString(string: "Consent", attributes: [NSFontAttributeName : boldFont]))
        attString.appendAttributedString(NSMutableAttributedString(string: " button and follow the instruction on the screen. Please review all information carefully.", attributes: [NSFontAttributeName : normalFont]))
        textLabel1.attributedText = attString
        
        attString = NSMutableAttributedString(string: "2. Tap the ", attributes: [NSFontAttributeName : normalFont])
        attString.appendAttributedString(NSMutableAttributedString(string: "Respond", attributes: [NSFontAttributeName : boldFont]))
        attString.appendAttributedString(NSMutableAttributedString(string: " button to enter your responses to a short clinical survey about your prostate cancer symptoms. You are able to respond as often as you’d like. We encourage you to respond often – even daily! If you have not responded in a week, the app will send you a reminder.", attributes: [NSFontAttributeName : normalFont]))
        textLabel2.attributedText = attString
        
        attString = NSMutableAttributedString(string: "3. Tap the ", attributes: [NSFontAttributeName : normalFont])
        attString.appendAttributedString(NSMutableAttributedString(string: "Get Involved", attributes: [NSFontAttributeName : boldFont]))
        attString.appendAttributedString(NSMutableAttributedString(string: " button to volunteer more information about yourself, such as your age, ethnicity, and type of treatment received for your cancer. You are able skip any questions or say \"I don’t know.\"", attributes: [NSFontAttributeName : normalFont]))
        textLabel3.attributedText = attString
        
        attString = NSMutableAttributedString(string: "4. Tap the ", attributes: [NSFontAttributeName : normalFont])
        attString.appendAttributedString(NSMutableAttributedString(string: "Track Results", attributes: [NSFontAttributeName : boldFont]))
        attString.appendAttributedString(NSMutableAttributedString(string: " button to see graphs of how your responses have changed over time (lower score means fewer symptoms). The green bar indicates your reported symptoms of a specific type/domain, while the orange line indicates the sum total of your responses across all symptoms.\n\n\n\nTo protect your information, we recommend that you use a passcode on your iOS device while this application is installed.\n\nThat’s it! We look forward to your participation!", attributes: [NSFontAttributeName : normalFont]))
        textLabel4.attributedText = attString
        
        
        setLabelColor(consentLabel)
        setLabelColor(respondLabel)
        setLabelColor(getInvolvedLabel)
        setLabelColor(trackResultsLabel)

        // Do any additional setup after loading the view.
    }
    
    func setLabelColor(label: UILabel) {
        label.layer.borderWidth = 1.5
        label.layer.borderColor = Globals.appBlueCG
        label.layer.cornerRadius = 5
//        label.textColor = Globals.appBlueUI
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
