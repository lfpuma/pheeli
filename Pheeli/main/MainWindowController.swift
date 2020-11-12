//
//  MainWindowController.swift
//  moodTrack
//
//  Created by Team on 22/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Cocoa

var isSignIn = false

class MainWindowController: NSWindowController{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        shouldCascadeWindows = true
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.level = .floating
        isSignIn = true
        if let window = window, let _ = window.screen {
            let screenW = NSScreen.main?.frame.width
            let screenH = NSScreen.main?.frame.height
            let frame = NSRect(x: ( screenW! - 1180 ) / 2, y: (screenH! - 700) / 2, width: 1180, height: 700)
            self.window?.minSize = NSSize(width: 1100, height: 700)
            self.window!.setFrame(frame, display: true)
        }
    }
}
