//
//  ViewController.swift
//  SwiftPractice
//
//  Created by parth on 5/29/15.
//  Copyright (c) 2015 idroid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.clearColor()
        
        println(UInt8.min) // minValue is equal to 0, and is of type UInt8
        println(UInt8.max) // maxValue is equal to 255, and is of type UInt8
        
        let decimalInteger = 17
        let binaryInteger = 0b10001       // 17 in binary notation
        let octalInteger = 0o21           // 17 in octal notation
        let hexadecimalInteger = 0x11     // 17 in hexadecimal notation
        println("\(decimalInteger) : \(binaryInteger) : \(octalInteger) : \(hexadecimalInteger)")
        
        let paddedDouble = 000123.456
        let oneMillion = 1_000_000
        let justOverOneMillion = 1_000_000.000_000_1
        println("\(paddedDouble) : \(oneMillion) : \(justOverOneMillion)")
        
        //Tuples Value
        var tupleValue: (Double, String, UIWindow?) = (11.11, "Tuple Value",
            UIApplication.sharedApplication().delegate?.window!)
        println("\(tupleValue.0) : \(tupleValue.1) : \(tupleValue.2)")
        
        let http404Error = (404, "Not Found")
        let (statusCode, statusMessage) = http404Error
        println("The status code is \(statusCode)")
        println("The status message is \(statusMessage)")
        
        let (justTheStatusCode, _) = http404Error
        println("Jusy code is \(justTheStatusCode)")

        let http200Status = (statusCode: 200, description: "OK")
        println("The status code is \(http200Status.statusCode)")
        println("The status message is \(http200Status.description)")

        let possibleNumber = "123"
        let convertedNumber = possibleNumber.toInt()
        println(convertedNumber)
        
        if let actualNumber = possibleNumber.toInt() {
            println("\'\(possibleNumber)\' has an integer value of \(actualNumber)")
        } else {
            println("\'\(possibleNumber)\' could not be converted to an integer")
        }
        
        if let var1 = possibleNumber.toInt(), let var2 = tupleValue.2 {
            println("Multiple optional value assignment to constatns in single if condition seperated by comma")
        }
        
        let possibleString: String? = "An optional string."
        let forcedString: String = possibleString! // requires an exclamation mark
        
        let assumedString: String! = "An implicitly unwrapped optional string."
        let implicitString: String = assumedString // no need for an exclamation mark
        
        let age = 3 // < 0 value cause Assertions to stop execution of app.
        assert(age >= 0, "A person's age cannot be less than zero")
        // this causes the assertion to trigger, because age is not >= 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

