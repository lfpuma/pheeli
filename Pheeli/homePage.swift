//
//  homePage.swift
//  moodTrack
//
//  Created by Team on 21/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//
import Cocoa
import Quartz
import p2_OAuth2


let OAuth2AppDidReceiveCallbackNotification = NSNotification.Name(rawValue: "OAuth2AppDidReceiveCallback")

var timer: Timer? = nil
var timerAlways :Timer? = nil
var prevDate = Date()

class homePage: NSViewController {
    
    var loader: DataLoader!
    var openController: NSWindowController?
    @IBOutlet weak var signInButton: NSButton!
    @IBOutlet weak var checkBox: NSButton!
    @IBOutlet weak var tVagree: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let pstyle = NSMutableParagraphStyle()
        //pstyle.alignment = .center
        
//        if let mutableAttributedTitle = signInButton.attributedTitle.mutableCopy() as? NSMutableAttributedString {
//            mutableAttributedTitle.addAttribute(.foregroundColor, value: NSColor.hexColor(rgbValue: 0x292E3E), range: NSRange(location: 0, length: mutableAttributedTitle.length))
//            signInButton.attributedTitle = mutableAttributedTitle
//        }
        
        signInButton.layer?.cornerRadius = 10
        signInButton.layer?.masksToBounds = true
        
        //self.view.wantsLayer = true;
        //self.view.layer?.backgroundColor = NSColor.white.cgColor
        
    }
    
    @IBAction func onChangeCB(_ sender: Any) {
        if checkBox.state == .on {
            self.tVagree.isHidden = true
        }
    }
    
    
    @IBAction func onTerms(_ sender: Any) {
        if let url = NSURL(string: "https://google.com") {
            NSWorkspace.shared.open(url as URL)
        }
    }
    
    @IBAction func onPrivacy(_ sender: Any) {
        if let url = NSURL(string: "https://google.com") {
            NSWorkspace.shared.open(url as URL)
        }
    }
    
    
    var nextActionForgetsTokens = false
    @objc func handleRedirect(_ notification: Notification) {
        if let url = notification.object as? URL {
            
            do {
                try loader.oauth2.handleRedirectURL(url)
            }
            catch let error {
                show(error)
            }
        }
        else {
            show(NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid notification: did not contain a URL"]))
        }
    }
    
    @IBAction func onSignin(_ sender: NSButton) {
        
        if(checkBox.state == .off) {
            tVagree.isHidden = false
            return
        }
        
        loader = GoogleLoader()
        
        loader.oauth2.forgetTokens()
        NotificationCenter.default.removeObserver(self, name: OAuth2AppDidReceiveCallbackNotification, object: nil)
        
        loader.oauth2.authConfig.authorizeContext = view.window
        NotificationCenter.default.addObserver(self, selector: #selector(homePage.handleRedirect(_:)), name: OAuth2AppDidReceiveCallbackNotification, object: nil)
        
        loader.requestUserdata() { dict, error in
            if let error = error {
                switch error {
                case OAuth2Error.requestCancelled: break
                  
                default:
                    self.show(error)
                }
            }
            else {
                NSApplication.shared.mainWindow?.close()
                
                imageURL = dict?["avatar_url"] as? String
                username = dict?["name"] as? String
                
                
                if let wc = self.storyboard?.instantiateController(withIdentifier: "SettingViewController") as? MainWindowController {
                    if (wc.contentViewController as? NSSplitViewController) != nil {
                        wc.showWindow(sender)
                        return
                    }
                }
            }
        }
    }
    
    func show(_ error: Error) {
        if let error = error as? OAuth2Error {
            let err = NSError(domain: "OAuth2ErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: error.description])
            display(err)
        }
        else {
            display(error as NSError)
        }
    }
    
    func display(_ error: NSError) {
        if let window = self.view.window {
            NSAlert(error: error).beginSheetModal(for: window, completionHandler: nil)
        }
        else {
            NSLog("Error authorizing: \(error.description)")
        }
    }
    
}

