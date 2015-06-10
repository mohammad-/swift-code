//
//  ViewController.swift
//  Stop Watch
//
//  Created by Mohammad Bharmal on 4/12/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

import UIKit
enum TimerStat{
    case Stopped, Paused, Running
}
class ViewController: UIViewController {
    
    var timer = NSTimer()
    var counter = 0
    var stat: TimerStat = TimerStat.Stopped
    
    @IBOutlet weak var timeElapsed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func timerCancled(sender: AnyObject) {
        stat = TimerStat.Stopped
        timer.invalidate()
        counter = 0
        settime(counter)
    }
    
    @IBAction func start(sender: AnyObject) {
        if stat != TimerStat.Running{
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "tick", userInfo: nil, repeats: true)
            stat = TimerStat.Running
        }
    }

    @IBAction func stop(sender: AnyObject) {
        timer.invalidate()
        stat = TimerStat.Stopped
    }
    
    func tick(){
        counter++;
        settime(counter)
    }

    func settime(counter:Int){
        var minute = Int(counter / 60)
        var seconds = Int(counter - (minute * 60))

        var formatedMin = String(format: "%02d", minute)
        var formatedSec = String(format: "%02d", seconds)
        timeElapsed.text = "\(formatedMin) : \(formatedSec)"

    }
}

