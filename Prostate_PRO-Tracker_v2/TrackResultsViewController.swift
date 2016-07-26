//
//  TrackResultsViewController.swift
//  Prostate Cancer
//
//  Created by Jackson Thea on 9/25/15.
//  Copyright (c) 2015 Jackson Thea. All rights reserved.
//

import UIKit
import ResearchKit
import CoreData
import Charts


class TrackResultsViewController: UIViewController {
    
    var surveyDates = [String]()
    var surveyCategoryResults = [Double]()
    var surveyCategoryOverallResults = [Double]()
    var categoryTitle = ""

    @IBOutlet weak var chartView: CombinedChartView!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        no data settings
        chartView.noDataText = "We can't show you a chart\nwithout any survey results.\n\nBegin by completing 'Respond'\non the home screen."
        chartView.infoTextColor = UIColor.blackColor()
        chartView.infoFont = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        
//        axis labels/grids
        chartView.xAxis.spaceBetweenLabels = 0
        chartView.xAxis.labelPosition = .Bottom
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawLabelsEnabled = true
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawLabelsEnabled = true
        
//        axis and legend font
        chartView.rightAxis.labelFont = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody) , size: 13)
        chartView.leftAxis.labelFont = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody) , size: 13)
        chartView.xAxis.labelFont = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody) , size: 13)
        chartView.legend.font = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody) , size: 13)
        chartView.legend.wordWrapEnabled = true
        
//        integer axis labels
        chartView.leftAxis.valueFormatter = NSNumberFormatter()
        chartView.leftAxis.valueFormatter?.minimumFractionDigits = 0
        chartView.rightAxis.valueFormatter = NSNumberFormatter()
        chartView.rightAxis.valueFormatter?.minimumFractionDigits = 0

//        color preferences
        chartView.backgroundColor = UIColor.whiteColor()
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBarShadowEnabled = false
        
//        set graph boundaries
        chartView.leftAxis.axisMaxValue = 12.5
        chartView.leftAxis.axisMinValue = 0
        chartView.rightAxis.axisMaxValue = 62.0
        chartView.rightAxis.axisMinValue = 0
        
//        working with texts
        chartView.descriptionText = ""
        navTitle.title = categoryTitle
        
//        generate the data
        let data = CombinedChartData(xVals: surveyDates)
        data.barData = generateBarData(surveyDates, values: surveyCategoryResults, title: categoryTitle)
        data.lineData = generateLineData(surveyDates, values: surveyCategoryOverallResults, title: "Overall Score")
        
        if data.xValCount > 0 {
            chartView.data = data
        }
        
        chartView.animate(xAxisDuration: 1.5, yAxisDuration: 2.0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func generateBarData(dataPoints: [String], values: [Double], title: String)->BarChartData {
//        data
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            dataEntries.append(BarChartDataEntry(value: values[i], xIndex: i))
        }
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: title)
        
//        visuals
        chartDataSet.drawValuesEnabled = false
        
//        colors
        chartDataSet.setColor(UIColor(colorLiteralRed: 0/255.0, green: 53/255.0, blue: 107/255.0, alpha: 1.0))
        
        chartDataSet.axisDependency = ChartYAxis.AxisDependency.Left
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        
        return chartData
    }

    
    
    func generateLineData(dataPoints: [String], values: [Double], title: String)->LineChartData {
//        data
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            dataEntries.append(ChartDataEntry(value: values[i], xIndex: i))
        }
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: title)
        
//        visuals
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawCircleHoleEnabled = true
        chartDataSet.circleHoleRadius = 3.0
        chartDataSet.circleRadius = 7.0
        chartDataSet.lineWidth = 5.0
        
//        colors
        let lineColor = UIColor.orangeColor()
        chartDataSet.setCircleColor(lineColor)
        chartDataSet.setColor(lineColor)
        
        chartDataSet.axisDependency = ChartYAxis.AxisDependency.Right
        let chartData = LineChartData(xVals: dataPoints, dataSet: chartDataSet)

        return chartData
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
