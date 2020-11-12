


import Cocoa
import Quartz

var imageURL: String? = nil
var username : String? = nil
var useremail : String? = nil

class mainContent: NSViewController{
    
    var selectedNav: Int = 1

    var currentViewController: SettingView?
    var currentViewControllerC: ChatView?
    @IBOutlet weak var containView: NSView!
    
    @IBOutlet weak var ingView: NSImageView!
    @IBOutlet weak var userName: NSTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingView.wantsLayer = true
        ingView.layer?.borderWidth = 0
        ingView.layer?.masksToBounds = false
        ingView.layer?.cornerRadius = ingView.frame.height/2
        ingView.layer?.masksToBounds = true
        
        if imageURL != nil {
            let url = URL(string: imageURL!)
            let data = try? Data(contentsOf: url!)
            if(data != nil){
                ingView.image = NSImage(data: data!)
            }
        }
        if username != nil {
            userName.stringValue = username!
        }
        selectedNav = selectedItem
        updateUI()
        
    }
    
    override func viewWillAppear() {
        onStartAlert()
    }
    
    @IBAction func onOkButton(_ sender: Any) {
        
        if(currentViewController != nil)
        {
            cycleH = (currentViewController?.sliderH.integerValue)!
            cycleM = (currentViewController?.sliderM.integerValue)!
            cycleS = (currentViewController?.sliderS.integerValue)!
            cycleTime = cycleH * 3600 + cycleM * 60 + cycleS
            
            if(currentViewController?.isTime1.state == .on) { isOnTimes[0] = true }
            else { isOnTimes[0] = false }
            if(currentViewController?.isTime2.state == .on) { isOnTimes[1] = true }
            else { isOnTimes[1] = false }
            if(currentViewController?.isTime3.state == .on) { isOnTimes[2] = true }
            else { isOnTimes[2] = false }
            if(currentViewController?.isTime4.state == .on) { isOnTimes[3] = true }
            else { isOnTimes[3] = false }
            if(currentViewController?.isTime5.state == .on) { isOnTimes[4] = true }
            else { isOnTimes[4] = false }
            
            onTimes[0] = (currentViewController?.time1.dateValue)!
            onTimes[1] = (currentViewController?.time2.dateValue)!
            onTimes[2] = (currentViewController?.time3.dateValue)!
            onTimes[3] = (currentViewController?.time4.dateValue)!
            onTimes[4] = (currentViewController?.time5.dateValue)!
            
            if(currentViewController?.checkEveryday.state == .on) { isPicklist = 0 }
            else if( currentViewController?.checkEveryWeekday.state == .on ) { isPicklist = 1 }
            else if( currentViewController?.checkEveryweekend.state == .on ) { isPicklist = 2 }
            else { isPicklist = -1 }
        }
        
        onStartAlert()
        NSApplication.shared.mainWindow?.close()
    }
    
    
    
    @objc dynamic func timerAction() {
        if( Date().isCondition() == true ) { return }
        try! self.openViewControllerWithLoader(sender: nil)
    }
    
    func openViewControllerWithLoader(sender: NSButton?) throws {
        //NSApplication.shared.mainWindow?.close()
        if(NSApplication.shared.mainWindow != nil) {
            return
        }
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
    
    func updateUI()
    {
      
        for v in containView.subviews{
            v.removeFromSuperview()
        }
        if selectedNav == 0 {
            showChat()
        }
        else { showSelect() }
    }
    func onStartAlert()
    {
        if (NSApplication.shared.mainWindow?.contentViewController as? ViewController) != nil
        {
            NSApplication.shared.mainWindow?.close()
        }

        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(cycleTime), target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    func showChat()
    {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateController(withIdentifier: "ComponentChat") as? ChatView
        currentViewControllerC = controller
        controller?.view.translatesAutoresizingMaskIntoConstraints = false
        containView.addSubview(controller!.view)
        let views = ["targetView": controller?.view]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[targetView]|",
                                                                   options: [], metrics: nil, views: views as [String : Any])
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[targetView]|",
                                                                 options: [], metrics: nil, views: views as [String : Any])
        NSLayoutConstraint.activate(horizontalConstraints)
        NSLayoutConstraint.activate(verticalConstraints)
    }
    
    func showSelect() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateController(withIdentifier: "ComponentSetting") as? SettingView
        currentViewController = controller
        controller?.view.translatesAutoresizingMaskIntoConstraints = false
        containView.addSubview(controller!.view)
        let views = ["targetView": controller?.view]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[targetView]|",
                                                                   options: [], metrics: nil, views: views as [String : Any])
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[targetView]|",
                                                                 options: [], metrics: nil, views: views as [String : Any])
        NSLayoutConstraint.activate(horizontalConstraints)
        NSLayoutConstraint.activate(verticalConstraints)
    }
}

extension Date {
    func isCondition() -> Bool {
        
        if(isPicklist == 1) {
            let weekday = Calendar.current.component(.weekday, from: Date())
            if(weekday == 1) { return false }
            if(weekday == 6 || weekday == 7 ) { return false }
        }
        if( isPicklist == 2) {
            let weekend = Calendar.current.component(.weekday, from: Date())
            if(weekend > 1 && weekend < 6) { return false }
        }
        
        
        for i in 0 ..< 5 {
            if(isOnTimes[i] == true)
            {
                if(onChecks[i] == false)
                {
                    let ldatecomponent = Calendar.current.dateComponents([.hour,.minute], from: onTimes[i])
                    let cdatecomponent = Calendar.current.dateComponents([.hour,.minute], from: self)
                    if((cdatecomponent.hour)! * 60 + (cdatecomponent.minute)! == (ldatecomponent.hour)! * 60 + (ldatecomponent.minute)!) {
                        for j in 0 ..< 5 {
                            let rdatecomponent = Calendar.current.dateComponents([.hour,.minute], from: onTimes[j])
                            if((ldatecomponent.hour)! * 60 + (ldatecomponent.minute)! == (rdatecomponent.hour)! * 60 + (rdatecomponent.minute)!) {
                                onChecks[j] = true
                            }
                        }
                        return true
                    }
                }
            }
        }
        return false
    }
    func isToday()
    {
        let ldatecomponent = Calendar.current.dateComponents([.year,.month,.day], from: prevDate)
        let cdatecomponent = Calendar.current.dateComponents([.year,.month,.day], from: self)
        if(ldatecomponent.year == cdatecomponent.year && ldatecomponent.month == cdatecomponent.month && ldatecomponent.day == cdatecomponent.day) {
            return
        }
        for i in 0 ..< 5 {
            onChecks[i] = false
        }
        prevDate = Date()
    }
}
