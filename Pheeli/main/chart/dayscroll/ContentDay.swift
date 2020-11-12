//
//  ContentDay.swift
//  Pheeli
//
//  Created by Alex on 3/3/19.
//  Copyright © 2019 Team. All rights reserved.
//

import Cocoa

class ContentDay: NSTableCellView {

    @IBOutlet weak var number: NSTextField!
    @IBOutlet weak var emoji: NSTextField!
    @IBOutlet weak var time: NSTextField!
    @IBOutlet weak var notes: NSTextField!
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
