//
//  AppDelegate.swift
//  moodTrack
//
//  Created by Team on 20/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Cocoa
import p2_OAuth2
import SQLite

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(AppDelegate.handleURLEvent(_:withReply:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )

        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("smallLogo"))
        }

        constructMenu()
        
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Mood History", action: #selector(AppDelegate.printQuoteChat(_:)), keyEquivalent: "c"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Setting", action: #selector(AppDelegate.printQuoteSetting(_:)), keyEquivalent: "s"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Pheeli", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }

    
    @objc func printQuoteChat(_ sender: Any?) {
        
        if isSignIn == false { return }
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        NSApplication.shared.mainWindow?.close()
        selectedItem = 0
        if let wc = storyboard.instantiateController(withIdentifier: "SettingViewController") as? MainWindowController {
            if (wc.contentViewController as? NSSplitViewController) != nil {
                wc.showWindow(sender)
                return
            }
        }
    }
    
    @objc func printQuoteSetting(_ sender: Any?) {
        
        if isSignIn == false { return }
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        NSApplication.shared.mainWindow?.close()
        selectedItem = 1
        if let wc = storyboard.instantiateController(withIdentifier: "SettingViewController") as? MainWindowController {
            if (wc.contentViewController as? NSSplitViewController) != nil {
                wc.showWindow(sender)
                return
            }
        }
    }
   
    @objc func handleURLEvent(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
        if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue {
            if let url = URL(string: urlString), "moodTrack" == url.scheme && "oauth" == url.host {
                NotificationCenter.default.post(name: OAuth2AppDidReceiveCallbackNotification, object: url)
            }
        }
        else {
            NSLog("No valid URL to handle")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }

}

