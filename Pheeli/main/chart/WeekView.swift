//
//  WeekView.swift
//  moodTrack
//
//  Created by Alex on 24/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Cocoa
import Charts
import Alamofire

class WeekView: NSViewController {
    
    let urlString = "https://fyk5yhm079.execute-api.us-east-2.amazonaws.com/moodyear"

    @IBOutlet weak var combinedChartView: CombinedChartView!
    @IBOutlet weak var nsProgress: NSProgressIndicator!
    @IBOutlet weak var comboY: NSComboBox!
    @IBOutlet weak var comboM: NSComboBox!
    
    let ylabels = ["","","😢","","☹","","😐","","🙂","","😁"]
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "Auguest", "September", "October", "November", "December"]
    
    var dayArray = ["0"]
    var unitsSold = [0.0]
    var count = [0]
    
    var currentM = 0
    var currentY = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    func startDraw()
    {
        
        let mS = comboM.stringValue
        let mY = comboY.stringValue
        let m = months.firstIndex(of: mS)
        let y = Int(mY)
        
        let dateComponents = DateComponents(year: y, month: m! + 1, day: 2)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        //let range = calendar.range(of: .day, in: .month, for: date)!
        //let numDays = range.count
        //print(numDays)
        
        var previousMonth = calendar.date(byAdding: .month, value: -1, to: date)?.previous(.sunday)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        dayArray.removeAll()
        unitsSold.removeAll()
        count.removeAll()
        
        nsProgress.isHidden = false
        combinedChartView.isHidden = true
        nsProgress.startAnimation(nil)
        
        for _ in 0 ..< 12 {
            let nDate = previousMonth?.next(.sunday)
            var str = formatter.string(from: previousMonth!)
            str = str + " ~ " + formatter.string(from: nDate!)
            dayArray.append(str)
            unitsSold.append(0)
            count.append(0)
            previousMonth = nDate
        }
        
        let parameters: [String: AnyObject] = [
            "email" : useremail as AnyObject,
            "year" : String(y!) as AnyObject
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
                            let indexD: String = sScore.value(forKey: "day") as! String
                            let indexday = Int(indexD)!
                            let indexM: String = sScore.value(forKey: "month") as! String
                            let indexmonth = Int(indexM)!
                            let indexY: String = sScore.value(forKey: "year") as! String
                            let indexyear = Int(indexY)!
                            let scoreV = Double(ss)!
                            
                            var dateCompo = DateComponents()
                            dateCompo.year = indexyear
                            dateCompo.month = indexmonth
                            dateCompo.day = indexday
                            let CDate = Calendar.current.date(from: dateCompo)
                            
                           
                            
                            previousMonth = calendar.date(byAdding: .month, value: -1, to: date)?.previous(.sunday)
                            
                            
                            
                            for i in 0 ..< 12 {
                                let nDate = previousMonth?.next(.sunday)
                    
                                if(CDate! >= previousMonth! && CDate! < nDate!) {
                                    self.unitsSold[i] = self.unitsSold[i] + scoreV
                                    self.count[i] = self.count[i] + 1
                                }
                                previousMonth = nDate
                            }
                        }
                    }
                }
                
                for j in 0 ..< 12 {
                    print(self.unitsSold[j])
                    if(self.count[j] != 0) { self.unitsSold[j] = self.unitsSold[j] / Double(self.count[j]) }
                }
                
                self.nsProgress.isHidden = true
                self.combinedChartView.isHidden = false
                self.setChart(xValues: self.dayArray, yValuesLineChart:  self.unitsSold, yValuesBarChart: self.unitsSold)
                self.combinedChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
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
        startDraw()
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
        startDraw()
    }
    
    @IBAction func onChangeM(_ sender: Any) {
        let mS = comboM.stringValue
        let m = months.firstIndex(of: mS)
        
        if(currentM == m) { return }
        currentM = m!
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
        let barChartSet: BarChartDataSet = BarChartDataSet(values: yVals2, label: "Week Data")
        
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
        combinedChartView.xAxis.granularity = 2
        combinedChartView.xAxis.labelFont = NSFont(name: "Arial",size: 9)!
        combinedChartView.xAxis.granularityEnabled = true
        combinedChartView.leftAxis.valueFormatter = IndexAxisValueFormatter(values: ylabels)
        combinedChartView.leftAxis.labelFont = NSFont(name: "Arial", size: 40)!
        combinedChartView.leftAxis.axisMaximum = 11.0
        combinedChartView.leftAxis.axisMinimum = 0.0
        combinedChartView.xAxis.axisMinimum = -1.0
        combinedChartView.xAxis.axisMaximum = 12.0
        combinedChartView.data = data
    }
    
    override func viewWillAppear() {
        startDraw()
        combinedChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
}

extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
}
