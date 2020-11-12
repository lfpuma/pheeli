//
//  ViewController.swift
//  moodTrack
//
//  Created by Team on 20/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Cocoa
import Quartz
import SQLite
import Alamofire

enum ServiceError: Error {
    case noViewController
    case incorrectViewControllerClass
}

class ViewController: NSViewController, NSTextFieldDelegate{
    
    let urlString = "https://r1nlejak5c.execute-api.us-east-2.amazonaws.com/insertMood/"
    
    var openController: NSWindowController?
    
    let imageSizeX : CGFloat = 10
    let imageSizeY : CGFloat = 10
    
    @IBOutlet weak var imageHappy: NSImageView!
    @IBOutlet weak var imageNeutral: NSImageView!
    @IBOutlet weak var imageSad: NSImageView!
    @IBOutlet weak var imageAngry: NSImageView!
    @IBOutlet weak var imageCool: NSImageView!
    
    @IBOutlet weak var happyButton: NSTextField!
    @IBOutlet weak var neutralButton: NSTextField!
    @IBOutlet weak var verySadButton: NSTextField!
    @IBOutlet weak var angryButton: NSTextField!
    @IBOutlet weak var coolButton: NSTextField!
    
    @IBOutlet weak var feelFree: NSTextField!
    
    
    var free: String = "none"
    var score: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timer?.invalidate()
        timer = nil
        
        onClear()
        
        
        let gestureHappyN = NSClickGestureRecognizer()
        gestureHappyN.buttonMask = 0x1
        gestureHappyN.numberOfClicksRequired = 1
        gestureHappyN.target = self
        gestureHappyN.action = #selector(onHappy(_:))
        happyButton.addGestureRecognizer(gestureHappyN)
        
        let gestureNeutral = NSClickGestureRecognizer()
        gestureNeutral.buttonMask = 0x1
        gestureNeutral.numberOfClicksRequired = 1
        gestureNeutral.target = self
        gestureNeutral.action = #selector(onNeutral(_:))
        neutralButton.addGestureRecognizer(gestureNeutral)
        
        
        let gestureVerySad = NSClickGestureRecognizer()
        gestureVerySad.buttonMask = 0x1
        gestureVerySad.numberOfClicksRequired = 1
        gestureVerySad.target = self
        gestureVerySad.action = #selector(onVerySad(_:))
        verySadButton.addGestureRecognizer(gestureVerySad)
        
        
        let gestureAngry = NSClickGestureRecognizer()
        gestureAngry.buttonMask = 0x1
        gestureAngry.numberOfClicksRequired = 1
        gestureAngry.target = self
        gestureAngry.action = #selector(onAngry(_:))
        angryButton.addGestureRecognizer(gestureAngry)
        
        let gestureCool = NSClickGestureRecognizer()
        gestureCool.buttonMask = 0x1
        gestureCool.numberOfClicksRequired = 1
        gestureCool.target = self
        gestureCool.action = #selector(onCool(_:))
        coolButton.addGestureRecognizer(gestureCool)
    }
    
    @objc func onHappy(_ sender: NSGestureRecognizer) {
        onClear()
        score = 10.0
        imageHappy.isHidden = false
    }

    @objc func onNeutral(_ sender: NSGestureRecognizer) {
        onClear()
        score = 6.0
        imageNeutral.isHidden = false
    }
    @objc func onVerySad(_ sender: NSGestureRecognizer) {
        onClear()
        score = 4.0
        imageSad.isHidden = false
    }
 
    @objc func onAngry(_ sender: NSGestureRecognizer) {
        onClear()
        score = 2.0
        imageAngry.isHidden = false
    }
    @objc func onCool(_ sender: NSGestureRecognizer) {
        onClear()
        score = 8.0
        imageCool.isHidden = false
    }
    
    func onClear()
    {
        imageHappy.isHidden = true
        imageNeutral.isHidden = true
        imageSad.isHidden = true
        imageAngry.isHidden = true
        imageCool.isHidden = true
    }
    
    func openViewControllerWithLoader(_ loader: DataLoader, sender: NSButton?) throws {
        if(NSApplication.shared.mainWindow != nil) { return }
        for ns in NSApp.windows {
            if (ns.contentViewController as? ViewController) != nil {
                return
            }
        }
        NSApplication.shared.mainWindow?.close()
        if let wc = storyboard?.instantiateController(withIdentifier: "SingleService") as? NSWindowController {
            if let vc = wc.contentViewController as? homePage {
                vc.loader = loader
                wc.showWindow(sender)
                openController = wc
                return
            }
            throw ServiceError.incorrectViewControllerClass
        }
        throw ServiceError.noViewController
    }
    
    
    @IBAction func onSkip(_ sender: Any) {
        NSApplication.shared.mainWindow?.close()
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(cycleTime), target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    
    @IBAction func onOkClick(_ sender: Any) {
        NSApplication.shared.mainWindow?.close()
        
        self.free = feelFree.stringValue
        
        let dateComponent = Calendar.current.dateComponents([.year,.month,.day], from: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let timeStamp = formatter.string(from: Date())
        
        if(self.score != 0)
        {
            if( self.free.isEmpty ) { self.free = "You don't have any notes for this session" }
            let parameters: [String: AnyObject] = [
                "email" : useremail as AnyObject,
                "score" : String(self.score) as AnyObject,
                "free" : self.free as AnyObject,
                "year" : String((dateComponent.year)!) as AnyObject,
                "month" : String((dateComponent.month)!) as AnyObject,
                "day" : String((dateComponent.day)!) as AnyObject,
                "time" : timeStamp as AnyObject
            ]
            
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    print(response)
                    break
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(cycleTime), target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    
    
    @objc dynamic func timerAction() {
        if( Date().isCondition() == true ) { return }
        try! self.openViewController(sender: nil)
    }
    
    func openViewController(sender: NSButton?) throws {
        if(NSApplication.shared.mainWindow != nil) { return }
        for ns in NSApp.windows {
            if (ns.contentViewController as? ViewController) != nil {
                return
            }
        }
        if let wc = storyboard?.instantiateController(withIdentifier: "SingleService") as? NSWindowController {
            if (wc.contentViewController as? ViewController) != nil {
                wc.showWindow(sender)
                return
            }
            throw ServiceError.incorrectViewControllerClass
        }
        throw ServiceError.noViewController
    }
}

