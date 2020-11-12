//
//  AlertWindowController.swift
//  moodTrack
//
//  Created by Team on 23/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Cocoa

class AlertWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.level = .floating
        
        let fullName = username
        var components = fullName?.components(separatedBy: " ")
        window?.title = (components?[0])!
    }
}
