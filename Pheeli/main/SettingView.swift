//
//  SettingView.swift
//  moodTrack
//
//  Created by Team on 22/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Cocoa

var isOnTimes: [Bool] = []
var onTimes: [Date] = []
var onChecks: [Bool] = []
var isPicklist = -1

class SettingView: NSViewController{

    @IBOutlet weak var sliderH: NSSlider!
    @IBOutlet weak var sliderM: NSSlider!
    @IBOutlet weak var sliderS: NSSlider!
    
    @IBOutlet weak var labelH: NSTextField!
    @IBOutlet weak var labelM: NSTextField!
    @IBOutlet weak var labelS: NSTextField!
    
    
    @IBOutlet weak var isTime1: NSButton!
    @IBOutlet weak var isTime2: NSButton!
    @IBOutlet weak var isTime3: NSButton!
    @IBOutlet weak var isTime4: NSButton!
    @IBOutlet weak var isTime5: NSButton!
    
    @IBOutlet weak var time1: NSDatePicker!
    @IBOutlet weak var time2: NSDatePicker!
    @IBOutlet weak var time3: NSDatePicker!
    @IBOutlet weak var time4: NSDatePicker!
    @IBOutlet weak var time5: NSDatePicker!
    
    @IBOutlet weak var checkEveryday: NSButton!
    @IBOutlet weak var checkEveryWeekday: NSButton!
    @IBOutlet weak var checkEveryweekend: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderH.integerValue = cycleH
        sliderM.integerValue = cycleM
        sliderS.integerValue = cycleS
        
        labelH.stringValue = "Every [\(cycleH)] Hour(s)"
        labelM.stringValue = "Every [\(cycleM)] Minute(s)"
        labelS.stringValue = "Every [\(cycleS)] Second(s)"
        
        if(isOnTimes[0] == true) { self.isTime1.state = .on }
        else { self.isTime1.state = .off }
        if(isOnTimes[1] == true) { self.isTime2.state = .on }
        else { self.isTime2.state = .off }
        if(isOnTimes[2] == true) { self.isTime3.state = .on }
        else { self.isTime3.state = .off }
        if(isOnTimes[3] == true) { self.isTime4.state = .on }
        else { self.isTime4.state = .off }
        if(isOnTimes[4] == true) { self.isTime5.state = .on }
        else { self.isTime5.state = .off }
        
        time1.dateValue = onTimes[0]
        time2.dateValue = onTimes[1]
        time3.dateValue = onTimes[2]
        time4.dateValue = onTimes[3]
        time5.dateValue = onTimes[4]
    
        for i in 0 ..< 5 {
            onChecks[i] = false
        }
        
        if (isPicklist == 0) { checkEveryday.state = .on}
        if (isPicklist == 1 ) { checkEveryWeekday.state = .on }
        if( isPicklist == 2 ) { checkEveryweekend.state = .on }
    }
    
    @IBAction func onCheckDay(_ sender: Any) {
        checkEveryweekend.state = .off
        checkEveryWeekday.state = .off
    }
    
    @IBAction func onCheckWeekDay(_ sender: Any) {
        checkEveryweekend.state = .off
        checkEveryday.state = .off
    }
    
    @IBAction func onCheckWeekend(_ sender: Any) {
        checkEveryday.state = .off
        checkEveryWeekday.state = .off
    }
    
    
    @IBAction func onChangeH(_ sender: Any) {
        let h = sliderH.integerValue
        labelH.stringValue = "Every [\(h)] Hour(s)"
    }
    
    @IBAction func onChangeM(_ sender: Any) {
        let m = sliderM.integerValue
        labelM.stringValue = "Every [\(m)] Minute(s)"
    }
    
    @IBAction func onChangeS(_ sender: Any) {
        let s = sliderS.integerValue
        labelS.stringValue = "Every [\(s)] Second(s)"
    }
}

