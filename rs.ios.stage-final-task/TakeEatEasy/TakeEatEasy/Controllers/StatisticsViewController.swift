//
//  StatisticsViewController.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 04.11.2021.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var statisticsChartView: LineChartView!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var moodAfterLabel: UILabel!
    
    private var firstDate: Date?
    private var dataPoints: [String]?
    
    var viewModel: StatisticsViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
        setupChart()
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupChart() {
        guard let meals = viewModel.getMeals() else { return }
        let dates = meals.map { $0.date }
        let datesList = dates.map { $0.weekAndTimetoString() }
        let moods = meals.compactMap { $0.mood?.rawValue }.map{ Double($0) }
        let moodAfter = meals.compactMap { $0.moodAfter?.rawValue }.map{ Double($0) }
        
        dataPoints = datesList
        
        let moodsDataSet = setData(datesList, values: moods)
        moodsDataSet.setColor(UIColor(named: "lineOrange") ?? UIColor.systemOrange)
        moodsDataSet.valueColors = [UIColor(named: "lineOrange") ?? UIColor.systemOrange]
        moodsDataSet.lineWidth = 4.0
        
        let moodAfterDataSet = setData(datesList, values: moodAfter)
        moodAfterDataSet.setColor(UIColor(named: "lineViolet") ?? UIColor.systemPurple)
        moodAfterDataSet.valueColors = [UIColor(named: "lineViolet") ?? UIColor.systemPurple]
        moodAfterDataSet.lineWidth = 3.0
        
        setChart([moodsDataSet, moodAfterDataSet])
    }
    
    private func setData(_ dataPoints: [String], values: [Double]) -> LineChartDataSet {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0 ..< dataPoints.count {
            dataEntries.append(ChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let dataSet = LineChartDataSet(entries: dataEntries, label: nil)
        dataSet.axisDependency = .left
        dataSet.setCircleColor(UIColor.white)
        dataSet.circleRadius = 5.0
        dataSet.fillAlpha = 0.7
        dataSet.mode = .cubicBezier
        dataSet.fillColor = UIColor.white
        dataSet.highlightColor = UIColor.white
        dataSet.drawCircleHoleEnabled = true
        
        return dataSet
    }
    
    private func setChart(_ dataSets: [LineChartDataSet]) {
        
        guard let points = dataPoints else { return }
        
        let lineChartData = LineChartData(dataSets: dataSets)
        lineChartData.setValueTextColor(.defaultSecondaryTextColor)
        lineChartData.setValueFont(UIFont(name: "Lato-Regular", size: 14.0) ?? .systemFont(ofSize: 14.0))
        statisticsChartView.rightAxis.enabled = true
        statisticsChartView.xAxis.drawGridLinesEnabled = false
        statisticsChartView.xAxis.labelPosition = .bottom
        statisticsChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: points)
        statisticsChartView.dragEnabled = true
        
        statisticsChartView.data = lineChartData
        statisticsChartView.animate(xAxisDuration: 1.5)
        
        //statisticsChartView.xAxis.valueFormatter = self
    }
    
    public func updateScreen() {
        //viewModel.start()
        setupChart()
    }
}
