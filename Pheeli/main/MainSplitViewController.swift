//
//  MainSplitViewController.swift
//  moodTrack
//
//  Created by Team on 22/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Cocoa

var selectedItem: Int = 1

class MainSplitViewController: NSSplitViewController {
    
    var leftPane: SidebarViewController?
    var contentView: mainContent?

    override func viewDidLoad() {
        super.viewDidLoad()
        let story = self.storyboard
        
        leftPane = story?.instantiateController(withIdentifier: "Sidebar") as! SidebarViewController?
        contentView = story?.instantiateController(withIdentifier: "Maincontent") as! mainContent?
        self.addChild(leftPane!)
        self.addChild(contentView!)
    }
}
