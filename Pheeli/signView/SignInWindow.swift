//
//  SignInWindow.swift
//  moodTrack
//
//  Created by Team on 22/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Cocoa

var cycleH: Int = 24
var cycleM: Int = 0
var cycleS: Int = 0
var cycleTime: Int = 24 * 60 * 60

class SignInWindow: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        if let window = window, let _ = window.screen {
            let screenW = NSScreen.main?.frame.width
            let screenH = NSScreen.main?.frame.height
            let frame = NSRect(x: ( screenW! - window.frame.width ) / 2, y: (screenH! - 200) / 2, width: window.frame.width, height: window.frame.height)
            self.window!.setFrame(frame, display: true)
        }
        
        //window?.titlebarAppearsTransparent = true
        
        //window?.backgroundColor = NSColor.white
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        for _ in 0..<5 {
            isOnTimes.append(false)
            onChecks.append(false)
            dateComponents.hour = (dateComponents.hour)! + 3
            onTimes.append(Calendar.current.date(from: dateComponents)!)
        }
        prevDate = Date()
        timerAlways = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    
    @objc dynamic func timerAction() {
        if (isSignIn == false) { return }
        if( isPicklist == -1 ) { return }
        Date().isToday()
        if( Date().isCondition() == false ) { return }
        try! self.openViewControllerWithLoader(sender: nil)
    }
    
    func openViewControllerWithLoader(sender: NSButton?) throws {
        print("current windows count:")
        print(NSApp.windows.count)
        if(NSApplication.shared.mainWindow != nil) { return }
        for ns in NSApp.windows {
            if (ns.contentViewController as? ViewController) != nil {
                return
            }
        }
        if let wc = storyboard?.instantiateController(withIdentifier: "SingleService") as? AlertWindowController {
            if (wc.contentViewController as? ViewController) != nil {
                wc.showWindow(sender)
                return
            }
            throw ServiceError.incorrectViewControllerClass
        }
        throw ServiceError.noViewController
    }
}
