//
//  DayView.swift
//  moodTrack
//
//  Created by Alex on 24/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Cocoa
import Charts
import Alamofire

class DayView: NSViewController{
    
    @IBOutlet weak var tableView: NSTableView!
    

    let urlString = "https://lcy823l0aa.execute-api.us-east-2.amazonaws.com/moodRead/"
    
    //var combinedChartView: CombinedChartView!
    @IBOutlet weak var nsProgress: NSProgressIndicator!
    
    @IBOutlet weak var comboY: NSComboBox!
    @IBOutlet weak var comboM: NSComboBox!
    
    
    
    let ylabels =  ["","","😢","","☹","","😐","","🙂","","😁"]
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "Auguest", "September", "October", "November", "December"]
    var dayArray = ["0"]
    
    var allemojis = ["😁"]
    var allnotes = ["notes"]
    var alltimes = ["2019-3-3 3:2"]
    
    var unitsSold = [0.0]
    var count = [0]
    
    var currentM = 0
    var currentY = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        for i in 2000..<3000 {
            comboY.addItem(withObjectValue: String(i))
        }

        let date = Date()
        let calender = Calendar.current
        let year = calender.component(.year,from: date)
        let month = calender.component(.month, from: date)
        comboY.selectItem(withObjectValue: String(year))
        comboM.selectItem(withObjectValue: months[month - 1])
        currentM = month - 1
        currentY = year
        
        LoadData()
        
    }
    
    func startDraw(combinedChartView: CombinedChartView)
    {
        self.nsProgress.isHidden = true
        combinedChartView.isHidden = false
        self.setChart(combinedChartView: combinedChartView, xValues: self.dayArray, yValuesLineChart:  self.unitsSold, yValuesBarChart: self.unitsSold)
        combinedChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
    
    func LoadData()
    {
        let mS = comboM.stringValue
        let mY = comboY.stringValue
        let m = months.firstIndex(of: mS)
        let y = Int(mY)
        
        let dateComponents = DateComponents(year: y, month: m! + 1)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        dayArray.removeAll()
        unitsSold.removeAll()
        count.removeAll()
        
        allemojis.removeAll()
        alltimes.removeAll()
        allnotes.removeAll()
        
        nsProgress.isHidden = false
        nsProgress.startAnimation(nil)
        
        for i in 0 ..< numDays {
            dayArray.append(String(i + 1))
            unitsSold.append(0.0)
            count.append(0)
        }
        
        let parameters: [String: AnyObject] = [
            "email" : useremail as AnyObject,
            "year" : String(y!) as AnyObject,
            "month" : String(m! + 1) as AnyObject
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
                        //print(object)
                        if let sScore = object as? NSObject {
                            let ss: String = sScore.value(forKey: "score") as! String
                            let indexV: String = sScore.value(forKey: "day") as! String
                            let indexI = Int(indexV)! - 1
                            let scoreV = Double(ss)!
                            self.unitsSold[indexI] = self.unitsSold[indexI] + scoreV
                            self.count[indexI] = self.count[indexI] + 1
                            
                            if(ss == "10.0") { self.allemojis.append("😁") }
                            if(ss == "8.0") { self.allemojis.append("🙂") }
                            if(ss == "6.0") { self.allemojis.append("😐") }
                            if(ss == "4.0" ) { self.allemojis.append("☹") }
                            if(ss == "2.0" ){ self.allemojis.append("😢") }
                            
                            self.alltimes.append(sScore.value(forKey: "time") as! String)
                            self.allnotes.append(sScore.value(forKey: "free") as! String)
                        }
                    }
                }
                for j in 0 ..< numDays {
                    print(self.unitsSold[j])
                    if(self.count[j] != 0) { self.unitsSold[j] = self.unitsSold[j] / Double(self.count[j]) }
                }
                self.tableView.reloadData()
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func onPrev(_ sender: Any) {
        let mS = comboM.stringValue
        let mY = comboY.stringValue
        var m = months.firstIndex(of: mS)
        var y = Int(mY)
        
        if m! > 0 {
            m = m! - 1
        }
        else {
            if ( y! > 2000 ) {
                y = y! - 1
                m = 11
            }
        }
        
        comboM.stringValue = months[m!]
        comboY.stringValue = String(y!)
        currentM = m!
        currentY = y!
        LoadData()
    }
    
    @IBAction func onNext(_ sender: Any) {
        
        let mS = comboM.stringValue
        let mY = comboY.stringValue
        var m = months.firstIndex(of: mS)
        var y = Int(mY)
        
        if m! < 11 {
            m = m! + 1
        }
        else {
            if ( y! < 2999 ) {
                y = y! + 1
                m = 0
            }
        }
        
        comboM.stringValue = months[m!]
        comboY.stringValue = String(y!)
        currentM = m!
        currentY = y!
        LoadData()
    }
    
    @IBAction func onChangeM(_ sender: Any) {
        let mS = comboM.stringValue
        let m = months.firstIndex(of: mS)
        
        if(currentM == m) { return }
        currentM = m!
        LoadData()
    }
    
    @IBAction func onChangeY(_ sender: Any) {
        let mY = comboY.stringValue
        let y = Int(mY)
        if currentY == y { return }
        currentY = y!
        LoadData()
    }
    
    
    func setChart(combinedChartView: CombinedChartView, xValues: [String], yValuesLineChart: [Double], yValuesBarChart: [Double]) {
        combinedChartView.noDataText = ""
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()
        
        for i in 0..<xValues.count {
            
            yVals1.append(ChartDataEntry(x: Double(i), y: yValuesBarChart[i]))
            yVals2.append(BarChartDataEntry(x: Double(i), y: yValuesBarChart[i]))
            
        }
        
        let lineChartSet = LineChartDataSet(values: yVals1, label: "Line")
        let barChartSet: BarChartDataSet = BarChartDataSet(values: yVals2, label: "Day Data")
        
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
    }
}

public extension NSColor {
    public class func hexColor(rgbValue: Int, alpha: CGFloat = 1.0) -> NSColor {
        
        return NSColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue:((CGFloat)(rgbValue & 0xFF))/255.0, alpha:alpha)
        
    }
    
}


extension DayView:NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 2 + allemojis.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        
        if row == 0 {
            //Header Row
            let result = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "headerDayCell"), owner: self) as! HeaderDay
            startDraw(combinedChartView: result.combinedChartView)
            return result
        }
        else if (row == 1) {
            let result = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "titleDayCell"), owner: self) as! TitleDay
            return result
        }
        else if (row >= 2) {
            
            if(allemojis.isEmpty ) { return nil }
            if(alltimes.isEmpty ) { return nil }
            if(allnotes.isEmpty ) { return nil }
            
            let result = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "contentDayCell"), owner: self) as! ContentDay
            result.number.stringValue = String(row - 1)
            result.emoji.stringValue = allemojis[row - 2]
            result.notes.stringValue = allnotes[row - 2]
            result.time.stringValue = alltimes[row-2]
            return result
        }
        return nil
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if row == 0 {
            return 430.0
        }
        else if(row == 1) {
            return 35.0
        }
        else { return 50.0 }
    }
}
