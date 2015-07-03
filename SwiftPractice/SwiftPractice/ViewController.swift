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
        println("Just code is \(justTheStatusCode)")

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
        
        var a = 0
        let b = ++a
        println("a = \(a) : b = \(b)")
        // a and b are now both equal to 1
        let c = a++
        println("a = \(a) : c = \(c)")

        // Nil Coalescing Operator ??
        let defaultColorName = "red"
        var userDefinedColorName: String?   // defaults to nil
        var colorNameToUse = userDefinedColorName ?? defaultColorName
        println(colorNameToUse)
        userDefinedColorName = "green"
        colorNameToUse = userDefinedColorName ?? defaultColorName
        println(colorNameToUse)
        
        // Closed Range Operator
        for index in 1...5 {
            println("\(index) times 5 is \(index * 5)")
        }
        
        // Half-Open Range Operator
        let names = ["Anna", "Alex", "Brian", "Jack"]
        let length = names.count
        for i in 0..<length {
            println("Person \(i + 1) is called \(names[i])")
        }
        
        var emptyString = ""               // empty string literal
        var anotherEmptyString = String()
        if emptyString.isEmpty {
            println("Nothing to see here")
        }
        
        var variableString = "Horse"
        variableString += " and carriage"
        println(variableString)
        
        for character in "Dog!🐶" {
            println(character)
        }
        
        let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
        var catString = String(catCharacters)
        println("\(catCharacters) : \(catString)")
        
        let dollar: Character = "$"
        catString.append(dollar)
        println(catString)
        
        let multiplier = 3
        let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
        println(message)
        
        let dollarSign = "\u{24}"
        let blackHeart = "\u{2665}"
        let sparklingHeart = "\u{1F496}"
        println("\(dollarSign) : \(blackHeart) : \(sparklingHeart)")
        
        let eAcute: Character = "\u{E9}"
        let combinedEAcute: Character = "\u{65}\u{301}"
        println("\(eAcute) : \(combinedEAcute)")
        
        let precomposed: Character = "\u{D55C}"
        let decomposed: Character = "\u{1112}\u{1161}\u{11AB}"
        println("\(precomposed) : \(decomposed)")
        
        let enclosedEAcute: Character = "\u{E9}\u{20DD}"
        println(enclosedEAcute)
        
        let regionalIndicatorForIndia = "\u{1F1EE}\u{1F1F3}"
        println(regionalIndicatorForIndia)
        
        let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
        println("unusualMenagerie has \(count(unusualMenagerie)) characters")
        
        let greeting = "Guten Tag"
        println("\(greeting.startIndex) : \(greeting.endIndex) : \(greeting[greeting.startIndex])")
        println(greeting[greeting.startIndex.successor()])
        println(greeting[greeting.endIndex.predecessor()])
        let idx = advance(greeting.startIndex, 7)
        println(greeting[idx])
 
        for index in indices(greeting) {
            print("\(greeting[index]) ")
        }
        println("\n")
        
        var welcome = "hello"
        welcome.insert("!", atIndex: welcome.endIndex)
        println(welcome)
        welcome.splice(" there", atIndex: welcome.endIndex.predecessor())
        println(welcome)
        welcome.removeAtIndex(welcome.endIndex.predecessor())
        println(welcome)
        
        let rng = advance(welcome.endIndex, -6)..<welcome.endIndex
        welcome.removeRange(rng)
        println(welcome)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

