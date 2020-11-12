//
//  MonthView.swift
//  moodTrack
//
//  Created by Alex on 25/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Cocoa
import Charts
import Alamofire

class MonthView: NSViewController {

    
    let urlString = "https://fyk5yhm079.execute-api.us-east-2.amazonaws.com/moodyear"
    
    @IBOutlet weak var combinedChartView: CombinedChartView!
    @IBOutlet weak var nsProgress: NSProgressIndicator!
    
    @IBOutlet weak var comboY: NSComboBox!
    
    let ylabels = ["","","😢","","☹","","😐","","🙂","","😁"]
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "Auguest", "September", "October", "November", "December"]
    var unitsSold = [0.0]
    var count = [0]
    
    var currentY = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 2000..<3000 {
            comboY.addItem(withObjectValue: String(i))
        }
        
        let date = Date()
        let calender = Calendar.current
        let year = calender.component(.year,from: date)
        comboY.selectItem(withObjectValue: String(year))
        currentY = year
    }
    
    func startDraw()
    {
        unitsSold.removeAll()
        count.removeAll()
        
        nsProgress.isHidden = false
        combinedChartView.isHidden = true
        nsProgress.startAnimation(nil)
        
        for _ in 0 ..< months.count {
            //let randV = Double.random(in: 0...10)
            unitsSold.append(0)
            count.append(0)
        }
        
        let parameters: [String: AnyObject] = [
            "email" : useremail as AnyObject,
            "year" : String(currentY) as AnyObject
        ]
        
        var data: Data?
        
        Alamofire.request(urlString, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                data = response.data
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let array = json as? [Any] {
                    for object in array {
                        if let sScore = object as? NSObject {
                            let ss: String = sScore.value(forKey: "score") as! String
                            let indexM: String = sScore.value(forKey: "month") as! String
                            let indexmonth = Int(indexM)! - 1
                            let scoreV = Double(ss)!
                            self.unitsSold[indexmonth] = self.unitsSold[indexmonth] + scoreV
                            self.count[indexmonth] = self.count[indexmonth] + 1
                        }
                    }
                }
                for j in 0 ..< 12 {
                    print(self.unitsSold[j])
                    if(self.count[j] != 0) { self.unitsSold[j] = self.unitsSold[j] / Double(self.count[j]) }
                }
                self.nsProgress.isHidden = true
                self.combinedChartView.isHidden = false
                self.setChart(xValues: self.months, yValuesLineChart:  self.unitsSold, yValuesBarChart: self.unitsSold)
                self.combinedChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
                break
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    @IBAction func onPrev(_ sender: Any) {
        let mY = comboY.stringValue
        var y = Int(mY)
        
        if(y! > 2000) {
            y = y! - 1
        }
        
        comboY.stringValue = String(y!)
        currentY = y!
        startDraw()
    }
    
    @IBAction func onNext(_ sender: Any) {

        let mY = comboY.stringValue
        var y = Int(mY)
        if ( y! < 2999 ) {
            y = y! + 1
        }
        
        comboY.stringValue = String(y!)
        currentY = y!
        startDraw()
    }
    
    @IBAction func onChangeY(_ sender: Any) {
        let mY = comboY.stringValue
        let y = Int(mY)
        if currentY == y { return }
        currentY = y!
        startDraw()
    }
    
    
    func setChart(xValues: [String], yValuesLineChart: [Double], yValuesBarChart: [Double]) {
        combinedChartView.noDataText = "Please provide data for the chart."
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()
        
        for i in 0..<xValues.count {
            
            yVals1.append(ChartDataEntry(x: Double(i), y: yValuesBarChart[i]))
            yVals2.append(BarChartDataEntry(x: Double(i), y: yValuesBarChart[i]))
            
        }
        
        let lineChartSet = LineChartDataSet(values: yVals1, label: "Line")
        let barChartSet: BarChartDataSet = BarChartDataSet(values: yVals2, label: "Month Data")
        
        //barChartSet.barBorderWidth = 0.1
        barChartSet.barBorderColor = NSUIColor.black
        barChartSet.barShadowColor = NSUIColor.black
        barChartSet.colors = [NSColor.hexColor(rgbValue: 0xA2A5CD)]
        
        
        lineChartSet.colors = [NSUIColor.darkGray]
        lineChartSet.circleColors = [NSUIColor.darkGray]
        lineChartSet.circleHoleColor = NSUIColor.orange //NSUIColor(cgColor: CGColor(red: 220, green: 77, blue: 82, alpha: 1.0))
        
        let data: CombinedChartData = CombinedChartData(dataSets: xValues as? [IChartDataSet])
        
        data.barData = BarChartData(dataSets: [barChartSet])
        //data.lineData = LineChartData(dataSets: [lineChartSet])
        combinedChartView.rightAxis.enabled = false
        
        combinedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        combinedChartView.xAxis.drawGridLinesEnabled = false
        combinedChartView.xAxis.labelPosition = .bottom
        combinedChartView.xAxis.labelCount = xValues.count
        combinedChartView.xAxis.granularity = 1
        combinedChartView.xAxis.labelFont = NSFont(name: "Arial",size: 11)!
        combinedChartView.xAxis.granularityEnabled = true
        combinedChartView.leftAxis.valueFormatter = IndexAxisValueFormatter(values: ylabels)
        combinedChartView.leftAxis.labelFont = NSFont(name: "Arial", size: 40)!
        combinedChartView.leftAxis.axisMaximum = 11.0
        combinedChartView.leftAxis.axisMinimum = 0.0
        combinedChartView.xAxis.axisMinimum = -1.0
        combinedChartView.xAxis.axisMaximum = Double(xValues.count)
        combinedChartView.data = data
    }
    
    override func viewWillAppear() {
        startDraw()
    }
}

