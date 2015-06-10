//
//  ViewController.swift
//  Text Reflect
//
//  Created by Mohammad Bharmal on 4/12/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet var textField: UITextField!
    @IBOutlet var text: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func buttonTapped(sender: AnyObject) {
        if let textValue = textField.text{
            text.text = textValue
            textField.text = ""
            textField.resignFirstResponder()
        }
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.textField.resignFirstResponder()
    }
}

