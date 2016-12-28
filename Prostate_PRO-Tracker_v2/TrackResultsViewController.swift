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
        chartView.noDataTextColor = UIColor.black
        chartView.noDataFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
//        chartView.infoTextColor = UIColor.black
//        chartView.infoFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        
//        axis labels/grids
//        chartView.xAxis.spaceBetweenLabels = 0
//        chartView.xAxis.spaceBetweenLabels = 0
        chartView.xAxis.labelPosition = .bottom
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawLabelsEnabled = true
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawLabelsEnabled = true
        
//        axis and legend font
        chartView.rightAxis.labelFont = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body) , size: 13)
        chartView.leftAxis.labelFont = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body) , size: 13)
        chartView.xAxis.labelFont = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body) , size: 13)
        chartView.legend.font = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body) , size: 13)
        chartView.legend.wordWrapEnabled = true
        
//        integer axis labels
        chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: NumberFormatter())
//        chartView.leftAxis.valueFormatter?.minimumFractionDigits = 0
        chartView.rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: NumberFormatter())
//        chartView.rightAxis.valueFormatter?.minimumFractionDigits = 0

//        color preferences
        chartView.backgroundColor = UIColor.white
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBarShadowEnabled = false
        
//        set graph boundaries
        chartView.leftAxis.axisMaximum = 12.5
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.axisMaximum = 62.0
        chartView.rightAxis.axisMinimum = 0
        
//        working with texts
        chartView.chartDescription?.text = ""
        navTitle.title = categoryTitle
        
//        generate the data
        var dataSetDates = [IChartDataSet]()
        dataSetDates.append(surveyDates as! IChartDataSet)
        let data = CombinedChartData(dataSets: dataSetDates)
        data.barData = generateBarData(surveyDates, values: surveyCategoryResults, title: categoryTitle)
        data.lineData = generateLineData(surveyDates, values: surveyCategoryOverallResults, title: "Overall Score")
        
        if data.entryCount > 0 {
            chartView.data = data
        }
        
        chartView.animate(xAxisDuration: 1.5, yAxisDuration: 2.0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func generateBarData(_ dataPoints: [String], values: [Double], title: String)->BarChartData {
//        data
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: values[i]))
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: title)
        
//        visuals
        chartDataSet.drawValuesEnabled = false
        
//        colors
        chartDataSet.setColor(UIColor(colorLiteralRed: 0/255.0, green: 53/255.0, blue: 107/255.0, alpha: 1.0))
        
        chartDataSet.axisDependency = YAxis.AxisDependency.left
        let chartData = BarChartData(dataSet: chartDataSet)
        
        return chartData
    }

    
    
    func generateLineData(_ dataPoints: [String], values: [Double], title: String)->LineChartData {
//        data
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            dataEntries.append(ChartDataEntry(x: Double(i), y: values[i]))
        }
        let chartDataSet = LineChartDataSet(values: dataEntries, label: title)
        
//        visuals
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawCircleHoleEnabled = true
        chartDataSet.circleHoleRadius = 3.0
        chartDataSet.circleRadius = 7.0
        chartDataSet.lineWidth = 5.0
        
//        colors
//        let lineColor = UIColor.orangeColor() //219, 33, 93
        let lineColor = UIColor(colorLiteralRed: 219/255.0, green: 33/255.0, blue: 93/255.0, alpha: 1.0)
        chartDataSet.setCircleColor(lineColor)
        chartDataSet.setColor(lineColor)
        
        chartDataSet.axisDependency = YAxis.AxisDependency.right
        let chartData = LineChartData(dataSet: chartDataSet)

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
