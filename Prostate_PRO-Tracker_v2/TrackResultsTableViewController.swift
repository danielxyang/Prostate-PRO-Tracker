//
//  TrackResultsTableViewController.swift
//  Prostate Cancer
//
//  Created by Jackson Thea on 10/17/15.
//  Copyright © 2015 Jackson Thea. All rights reserved.
//

import UIKit
import ResearchKit
import CoreData

class TrackResultsTableViewController: UITableViewController {
    
    var dateTimeAdded = [Date]()
    var surveyDates = [String]()
    var surveyTaskResults = [[Int?]]()
    var titles = ["Urinary Incontinence", "Urinary Irritation/Obstruction", "Bowel", "Sexual", "Vitality/Hormonal", "Overall"]
    var surveyTaskResultsByTask = [[Double]]()
    var surveyCategoryResults = [[Double](), [Double](), [Double](), [Double](), [Double](), [Double]()]
//    should have 6 elts eventually:
//      urinary incontinence, Urinary Irritation/Obstruction, Bowel, Sexual, Vitality/Hormonal, overall
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        let surveys = CoreDataHandler.sharedInstance.fetchCoreDataSurveys()
        
//        get answers and dates from core data
        for s in surveys {
            var surveyAnswers = [Int?]()
            if (s.type == Globals.surveyIdentifier) {
                let NSAnswers = s.answers
                for i in NSAnswers {
                    surveyAnswers.append(i as? Int)
                }
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                surveyDates.append(formatter.string(from: s.dateTimeCompleted as Date))
            }
            if (!surveyAnswers.isEmpty) {
                surveyTaskResults.append(surveyAnswers)
            }
        }
        
        if surveyTaskResults.count < 1 {
            print("returning: too few surveys")
            return
        }
        
        
        for (i, _) in surveyTaskResults.first!.enumerated() {
            var thisArray = [Double]()
            for (j, _) in surveyTaskResults.enumerated() {
                let result = Double(surveyTaskResults[j][i] ?? 0)
                thisArray.append(result)
            }
            surveyTaskResultsByTask.append(thisArray)
        }
        
        
        for j in 0...surveyTaskResultsByTask[0].count - 1 {
            for i in 0...surveyCategoryResults.count - 1 {
                surveyCategoryResults[i].append(0)
            }
            for i in 1...15 {
                surveyCategoryResults[(i-1)/3][j] += surveyTaskResultsByTask[i][j]
                surveyCategoryResults[5][j] += surveyTaskResultsByTask[i][j]
            }
        }

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return titles.count - 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyQuestion", for: indexPath) as! TrackResultsTableViewCell

        // Configure the cell...
        cell.index = indexPath.section
        cell.title = titles[indexPath.section] + " Symptoms"
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator

        return cell
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destination = segue.destination
        
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController!
        }
        
        if let trvc = destination as? TrackResultsViewController {
            if let surveyCell = sender as? TrackResultsTableViewCell {
                trvc.surveyDates = surveyDates
                trvc.surveyCategoryResults = surveyCategoryResults[surveyCell.index]
                trvc.surveyCategoryOverallResults = surveyCategoryResults[titles.count - 1]
//                trvc.isOverallScore = (surveyCell.index == 5)
                trvc.categoryTitle = surveyCell.title!
            }
        }
    }
    
    


    
    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }


    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
