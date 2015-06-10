//
//  ViewController.swift
//  Hello World
//
//  Created by Mohammad Bharmal on 4/12/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var helloWorld: UILabel!
    
    let helloW = "Hello World!!"
    let thereYouG = "There you go..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helloWorld.text = helloW        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func changeText(sender: AnyObject) {
        if let button = sender as? UIButton {
            if button.tag == 1{
                helloWorld.text = thereYouG
                button.setTitle("Change Back To \"\(helloW)\"", forState: UIControlState.Normal)
                button.tag = 2
            }else{
                helloWorld.text = helloW
                button.setTitle("Change Back To \"\(thereYouG)\"", forState: UIControlState.Normal)
                button.tag = 1
            }
        }
    }
}

