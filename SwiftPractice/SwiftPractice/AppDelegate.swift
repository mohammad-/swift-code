//
//  AppDelegate.swift
//  SwiftPractice
//
//  Created by parth on 5/29/15.
//  Copyright (c) 2015 idroid. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        print("Hello, world!")
        
        var myVariable = 42
        myVariable = 50
        let myConstant = 42
        //myConstant = 50
        
        let implicitInteger = 70
        let implicitDouble = 70.0
        let explicitDouble: Double = 70
        println("\n\(explicitDouble)")
        
        let label = "The width is "
        let width = 94
        let widthLabel = label + String(width)
        println(widthLabel)
        
        let apples = 3
        let oranges = 5
        let appleSummary = "I have \(apples) apples."
        let fruitSummary = "I have \(apples + oranges) pieces of fruit."
        println(fruitSummary)
        
        var shoppingList = ["catfish", "water", "tulips", "blue paint"]
        shoppingList[1] = "bottle of water"
        println(shoppingList)
        
        var occupations = [
            "Malcolm": "Captain",
            "Kaylee": "Mechanic",
        ]
        occupations["Jayne"] = "Public Relations"
        println(occupations)
        
        let emptyArray = [String]()
        let emptyDictionary = [String: Float]()
        println(emptyArray, emptyDictionary)
        
        shoppingList = []
        occupations = [:]
        NSLog("\n%@\n%@", shoppingList, occupations)
        
        let individualScores = [75, 43, 103, 87, 12]
        var teamScore = 0
        for score in individualScores {
            if score > 50 {
                teamScore += 3
            } else {
                teamScore += 1
            }
        }
        print(teamScore)
        
        var optionalString: String? = nil
        print("\n\(optionalString == nil)")
        
        var optionalName: String? = "John Appleseed"
        var greeting = "Hello!"
        if let name = optionalName {
            greeting = "Hello, \(name)"
        } else {
            println("\n\(greeting)")
        }
        
        let vegetable = "red pepper"
        switch vegetable {
        case "celery":
            let vegetableComment = "Add some raisins and make ants on a log."
        case "cucumber", "watercress":
            let vegetableComment = "That would make a good tea sandwich."
        case let x where x.hasSuffix("pepper"):
            let vegetableComment = "Is it a spicy \(x)?"
            println("\n\(vegetableComment)")
        default:
            let vegetableComment = "Everything tastes good in soup."
        }
        
        let interestingNumbers = [
            "Prime": [2, 3, 5, 7, 11, 13],
            "Fibonacci": [1, 1, 2, 3, 5, 8],
            "Square": [1, 4, 9, 16, 25],
        ]
        var largest = 0
        var kindOf = ""
        for (kind, numbers) in interestingNumbers {
            for number in numbers {
                if number > largest {
                    largest = number
                    kindOf = kind
                }
            }
        }
        println("\(largest) \(kindOf)")
        
        var n = 2
        while n < 100 {
            n = n * 2
        }
        println(n)
        
        var m = 2
        do {
            m *= 2
        } while m < 2
        println(m)
        
        var firstForLoop = 0
        for i in 0..<4 {
            firstForLoop += i
        }
        println(firstForLoop)
        
        var secondForLoop = 0
        for var i = 0; i < 4; ++i {
            secondForLoop += i
        }
        println(secondForLoop)
        
        var returnVal = self.greet("Method", day: "Splendid")
        println(returnVal)
        returnVal = greetF("Function", "Splendid")
        println(returnVal)
        
        println(self.sumOf(), self.sumOf(42, 597, 12))
        returnVal = String(format: "%.0lf", self.factorial(11.0))
        println(returnVal)
        println(self.returnFifteen())
        
        var increment = self.makeIncrementer()
        println("Here 'increment' is a function = \(increment(8))")

        var numbers = [20, 19, 7, 12]
        println("A function as arguments of another function = \(self.hasAnyMatches(numbers, condition: lessThanTen))")
        
        var resultOfClosure = numbers.map({
            (number: Int) -> Int in
            let result = 3 * number
            return result
        })
        println("Closure Result: \(resultOfClosure)")
        
        let mappedNumbers = numbers.map({ number in 5 * number })
        println("Single statement closures without types: \(mappedNumbers)")

        let sortedNumbers = sorted(numbers) { $0 > $1 }
        println("ClosureSortedNumber: \(sortedNumbers)")
        
        var shape = Shape()
        shape.numberOfSides = 7
        var shapeDescription = shape.simpleDescription()
        println(shapeDescription)
        
        let test = Square(sideLength: 5.2, name: "my test square")
        println("\(test.simpleDescription()) Area is .:\(test.area())")
        
        var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
        println(triangle.perimeter)
        triangle.perimeter = 9.9
        println("\(triangle.sideLength) \(triangle.perimeter)")
        
        var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
        println(triangleAndSquare.square.sideLength)
        println(triangleAndSquare.triangle.sideLength)
        triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
        println(triangleAndSquare.triangle.sideLength)
        
        var counter = Counter()
        counter.incrementBy(2, numberOfTimes: 7)
        
        let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
        let sideLength = optionalSquare?.sideLength
        println(sideLength)
        
        let svn = Rank.Seven
        let svnRawValue = svn.rawValue
        println("\(svn) \(svnRawValue)")
        
        if let convertedRank = Rank(rawValue: 11) {
            let threeDescription = convertedRank.simpleDescription()
            println(threeDescription)
        }

        let hearts = Suit.Hearts
        let heartsDescription = hearts.simpleDescription()
        println(heartsDescription)
        
        let threeOfSpades = Card(rank: .King, suit: .Diamonds)
        let threeOfSpadesDescription = threeOfSpades.simpleDescription()
        println(threeOfSpades, threeOfSpadesDescription)
        
        let success = ServerResponse.Result("6:00 am", "8:09 pm")
        let failure = ServerResponse.Error("Out of cheese.")
        
        switch success {
        case let .Result(sunrise, sunset):
            let serverResponse = "Sunrise is at \(sunrise) and sunset is at \(sunset)."
            println(serverResponse)
        case let .Error(error):
            let serverResponse = "Failure...  \(error)"
            println(serverResponse)
        default:
            let serverResponse = "Nothing"
            println(serverResponse)
        }
        
        var a = SimpleClass()
        a.adjust()
        let aDescription = a.simpleDescription
        
        var b = SimpleStructure()
        b.adjust()
        let bDescription = b.simpleDescription
        
        println(aDescription)
        println(bDescription)
        
        println(7.simpleDescription)
        var int: Int = 7
        int.adjust()
        println(int.simpleDescription)
        
        let protocolValue: ExampleProtocol = a
        println(protocolValue.simpleDescription)
        // println(protocolValue.anotherProperty)  // Uncomment to see the error
        
        println(repeat("knock", 5))
        println(repeat(protocolValue, 3))
        println(repeat(9, 9))
        
        var possibleInteger: OptionalValue<Int> = .None
        possibleInteger = .Some(100)
        
        var possibleString: OptionalValue<String>
        possibleString = .Some("KKK")

        println(anyCommonElements([1, 2, 3, 4, 5], [10, 11, 12]))
        println(anyCommonElements(["ABC", "IJK", "XYZ", "PQR"], ["xYz", "PQR", "IJK"]))
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func greet(name: String, day: String) -> String {
        self.window!.backgroundColor = self.randomColor()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.window!.frame.origin.x = self.window!.frame.width/4.0
            self.window!.frame.origin.y = self.window!.frame.height/4.0
            self.window!.frame.size.width = self.window!.frame.size.width/2.0
            self.window!.frame.size.height = self.window!.frame.size.height/2.0
            
            self.window!.backgroundColor = self.randomColor()
        }) { (Bool) -> Void in
            if Bool {
                let statistics = AppDelegate.calculateStatistics([5, 3, 100, 3, 9])
                //println(); println(); println()
                //println(statistics.min, statistics.max, statistics.sum)
            }
        }

        return "Hello \(name), today is \(day)."
    }

    class func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var win: UIWindow! = appDelegate.window!
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            win.frame = UIScreen.mainScreen().bounds
            win.backgroundColor = self.randomColor(appDelegate)()
        }) { (Bool) -> Void in
            if Bool {
                self.greet(appDelegate)("Method", day: "Splendid")
                //println(self.sumOf(appDelegate)(), self.sumOf(appDelegate)(42, 597, 12))
            }
        }

        var min = scores[0]
        var max = scores[0]
        var sum = 0
        
        for score in scores {
            if score > max {
                max = score
            } else if score < min {
                min = score
            }
            sum += score
        }
        
        return (min, max, sum)
    }

    func randomColor() -> UIColor {
        return UIColor(red: (CGFloat(random()%255)/255.0)*2.55,
                        green: (CGFloat(random()%252)/255.0)*2.55,
                        blue: (CGFloat(random()%225)/255.0)*2.55,
                        alpha: 1.0)
    }
    
    func sumOf(numbers: Int...) -> Int {
        var sum = 0
        for number in numbers {
            sum += number
        }
        return sum
    }
    
    func factorial(n: Double) -> Double {
        if n != 1 {
            var ans: Double = n * self.factorial(n-1)
            println("\(n) \t \(ans)")
            return ans
        }

        println(1.0)
        return 1.0
    }
    
    func returnFifteen() -> Int {
        var y = 10
        
        func add() {
            y += 5
        }
        
        add()
        return y
    }
    
    func makeIncrementer() -> (Int -> Int) {
        func addOne(number: Int) -> Int {
            return 1 + number
        }
        return addOne
    }
    
    func hasAnyMatches(list: [Int], condition: Int -> Bool) -> Bool {
        for item in list {
            if condition(item) {
                return true
            }
        }
        return false
    }

    func lessThanTen(number: Int) -> Bool {
        return number < 10
    }
    
}

// Functions
func greetF(name: String, day: String) -> String {
    return "Hello \(name), today is \(day)."
}

// Another classes
class Shape {
    var numberOfSides = 0
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

class NamedShape {
    var numberOfSides: Int = 0
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

class Square: NamedShape {
    var sideLength: Double
    
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }
    
    func area() ->  Double {
        return sideLength * sideLength
    }
    
    override func simpleDescription() -> String {
        println(super.simpleDescription())
        return "A square with sides of length \(sideLength)."
    }
}

class EquilateralTriangle: NamedShape {
    var sideLength: Double = 0.0
    
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }
    
    var perimeter: Double {
        get {
            return 3.0 * sideLength
        }
        set {
            sideLength = newValue / 3.0
        }
    }
    
    override func simpleDescription() -> String {
        println(super.simpleDescription())
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}

class TriangleAndSquare {
    var triangle: EquilateralTriangle {
        willSet {
            square.sideLength = newValue.sideLength
        }
    }
    var square: Square {
        willSet {
            triangle.sideLength = newValue.sideLength
        }
    }
    init(size: Double, name: String) {
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}

class Counter {
    var count: Int = 0
    func incrementBy(amount: Int, numberOfTimes times: Int) {
        count += amount * times
    }
}

// Enums
enum Rank: Int {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    func simpleDescription() -> String {
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

enum Suit {
    case Spades, Hearts, Diamonds, Clubs
    func simpleDescription() -> String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    }
}

// Structs
struct Card {
    var rank: Rank
    var suit: Suit
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}

enum ServerResponse {
    case Result(String, String)
    case Error(String)
}

// Protocols
protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    func adjust() {
        simpleDescription += "  Now 100% adjusted."
    }
}

struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    mutating func adjust() {
        simpleDescription += " (adjusted)"
    }
}

// Extensions
extension Int: ExampleProtocol {
    var simpleDescription: String {
        get {
            return "The number \(self)"
        } set {
            newValue
        }
    }
    
    mutating func adjust() {
        self.simpleDescription = String(self *= self)
    }
}

// Generics
func repeat<Item>(item: Item, times: Int) -> [Item] {
    var result = [Item]()
    for i in 0..<times {
        result.append(item)
    }
    return result
}

enum OptionalValue<T> {
    case None
    case Some(T)
}

func anyCommonElements <T, U
    where
    T: SequenceType,
    U: SequenceType,
    T.Generator.Element: Equatable,
    T.Generator.Element == U.Generator.Element>
    (lhs: T, rhs: U) -> Bool {
        println()
        var found:Bool = false
        var msg:String = "NotFound anything"

        for lhsItem in lhs {
            for rhsItem in rhs {
                if lhsItem == rhsItem {
                    print(" \(rhsItem)")
                    if found == false {
                        found = true
                        msg = "found"
                    }
                }
            }
        }
        
        print(" \(msg) from \(lhs) ")
        return found
}
