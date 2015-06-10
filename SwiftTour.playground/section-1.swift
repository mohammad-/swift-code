// Playground - noun: a place where people can play
//This has more or less all things described here
//https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html#//apple_ref/doc/uid/TP40014097-CH2-ID1


import Cocoa

//Variables
let name = "Mohammad"
var age = 30

//Printing
println("Name is \(name)")
println("Age is \(age)")

//Arrays and dicts

var boys = ["Mohammad", "Piyush", "Bhavesh"]
println("One of the boys is \(boys[0])")

boys[0] = "MD"
println("Mohammad is now \(boys[0])")


var student = [
    "name":"Mohammad",
    "age":"30"
]

let n = student["name"]!

println("Name of student is \(n)")


//Looping
for b in boys{
    println(b)
}

for (key, value) in student{
    println("\(key) is \(value)")
}

var i = 0
for i in 0..<5 {
    println(i)
}

var index = 0
do{
    println(index)
    index++
}while(index < 10)


//functions

func addOneTo(input:Int) -> Int{
    return input + 1
}

println(addOneTo(10))

//Multi Value

func greetings(name: String, day:String) -> String{
    return "Hey \(name), It's \(day)"
}

greetings("Bob", "Monday")

//Callculate
func findMaxMinAndAvg(data :[Int]) -> (max: Int, min: Int, avg: Double){
    var min = data.first!
    var max = data.first!
    var avg = 0
    
    for val in data{
        if val < min{
            min = val
        }
        
        if val > max {
            max = val
        }
        
        avg += val
    }
    
    return (min, max, Double(avg/data.count))
}


findMaxMinAndAvg([1,5,3,2,6,7,8])

//First Class Function
func adder(number: Int) -> (Int -> Int){
    func f(n: Int) -> Int{
        return n + number
    }
    return f
}

var f = adder(10)
println(f(5))


func gt(number:Int) -> (Int -> Bool){
    func c(test:Int) -> Bool{
        return test > number
    }
    return c
}


var cond = gt(10)

cond(15)
cond(5)


var numbers = [10, 20, 40, 50]
numbers.map { (n: Int) -> Int in
    return n*n
}


func mapper(nums: [Int], f: (Int->Int)) -> [Int]{
    var x: [Int] = []
    for n in nums{
        x.append(f(n))
    }
    return x
}

mapper([1,2,3,4,5,6,7,8,9], {(n :Int)-> Int in
    return n*n
})


func operater(n:[String],f:(String -> Void)){
    for v in n{
        f(v)
    }
}

operater(["a","b","c"], {(s:String) in
    println(s + "->")
})

operater(["a","b","c"], { println($0 + "->") })

//Class And Objects

class NamedShape {
    private var name: String?
    private var sides: Int?
    
    init(name :String, sides: Int){
        self.name = name
        self.sides = sides
    }
    
    func nameOfShape()->String{
        return "Shape \(self.name!) has \(sides!)"
    }
}


let shape = NamedShape(name: "Pentagone", sides: 5)

println(shape.nameOfShape())

class Square : NamedShape{
    var sideLength: Int?
    init(sideLength: Int){
        self.sideLength = sideLength
        super.init(name: "Square", sides:4)
    }
    
    override func nameOfShape()->String{
        return super.nameOfShape()+" of length \(sideLength!)"
    }
    
    func area()->Double{
        return Double(self.sideLength! * self.sideLength!)
    }

}


var square = Square(sideLength: 3)
square.nameOfShape()
square.area()


class EquilateralTriangle: NamedShape {
    var sideLength: Double?
    
    var perimeter: Double{
        get{
            return sideLength! * 3
        }
        set{
            sideLength = newValue / 3
        }
    }
    
    init(sideLength: Double){
        self.sideLength = sideLength
        super.init(name: "EquilateralTriangle", sides: 3)
    }
    
    override func nameOfShape() -> String {
        var desc = super.nameOfShape();
        return desc + " and Side Length is \(sideLength!) and perimeter is \(perimeter)"
    }
    
    
}

var t = EquilateralTriangle(sideLength: 5.0)

t.nameOfShape()

t.perimeter = 12.0

t.nameOfShape()



class SqureAndTriangle{
    var square :Square{
        willSet{
            //update side length of Triangle when Square is set
            triangle.sideLength = Double(newValue.sideLength!)
        }
    }
    
    var triangle: EquilateralTriangle{
        willSet{
            //update side length of Square when Triangle is set
            square.sideLength = Int(newValue.sideLength!)
        }
    }
    
    init(sideLength: Int){
        square = Square(sideLength: sideLength)
        triangle = EquilateralTriangle(sideLength: Double(sideLength))
    }
    
    func description() -> String{
        return "Squre with side length \(square.sideLength!) and Triangle with side length \(triangle.sideLength!)"
    }
}

var st = SqureAndTriangle(sideLength: 10)
st.description()

st.square = Square(sideLength: 20)
st.description()

st.triangle = EquilateralTriangle(sideLength: 30.0)
st.description()

/*
Methods on classes have one important difference from functions. Parameter names in functions are used only
within the function, but parameters names in methods are also used when you call the method (except for the first 
parameter). By default, a method has the same name for its parameters when you call it and within the method 
itself. You can specify a second name, which is used inside the method.
*/


class Counter{
    private var counter = 0;
    
    func increment(amount :Int, forTimes times:Int){
        counter += (amount * times)
    }
    
    func description() -> NSString{
        return "Counter is now \(counter)"
    }
}

let counter = Counter()

counter.description()

counter.increment(10, forTimes: 15)

counter.description()


var secCou:Counter? = nil

secCou?.description()

secCou = Counter()

(secCou?.increment(2, forTimes: 3))!
(secCou?.description())!

//Enum and Structures

enum Rank:Int{
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    
    func simpleDescription() -> String{
        switch self{
        case .Ace:
            return "Ace"
        case .Jack:
            return "Jack"
        case .King:
            return "King"
        case .Queen:
            return "Queen"
        default:
            return String(self.rawValue)
        }
    }
    
    func isLessThen(otherValue :Rank) -> Bool{
        if self == Rank.Ace {
            return false
        }else if otherValue == Rank.Ace{
            return true
        }else{
            return self.rawValue < otherValue.rawValue
        }
    }
}

enum Color: String{
    case Black = "Black", Red = "Red"
}

enum Suit{
    case Spades, Heart, Dimond, Club
    
    func simpleDescription() -> String{
        switch self{
        case .Spades:
            return "Spades"
        case .Heart:
            return "Heart"
        case .Dimond:
            return "Dimond"
        case .Club:
            return "Club"
        default:
            return "";
        }
    }
    
    func color() -> Color?{
        switch self{
        case .Heart:
            return Color.Red
        case .Dimond:
            return Color.Red
        case .Spades:
            return Color.Red
        case .Club:
            return Color.Black
        default:
            return nil;
        }
    }
}

let ace = Rank.Ace
ace.simpleDescription()

let two = Rank.Two
two.simpleDescription()

let king = Rank.King
king.simpleDescription()


ace.isLessThen(king)

king.isLessThen(ace)

two.isLessThen(king)

Rank.Queen.isLessThen(Rank.Jack)


Suit.Club.simpleDescription()
(Suit.Dimond.color()?.rawValue)!


struct Card{
    var rank : Rank
    var suit : Suit
    
    func simpleDescription() -> String{
        return "This is \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
    
    func deck() -> [Card]{
        var allCards:[Card] = []
        for i in 1...13 {
            var rank = Rank(rawValue: i)!
            allCards.append(Card(rank: rank, suit: Suit.Club))
            allCards.append(Card(rank: rank, suit: Suit.Dimond))
            allCards.append(Card(rank: rank, suit: Suit.Spades))
            allCards.append(Card(rank: rank, suit: Suit.Heart))
        }
        return allCards
    }
}


let card = Card(rank: Rank.Three, suit: Suit.Club)
card.simpleDescription()

for c in card.deck(){
    println(c.simpleDescription())
}


protocol Stringify{
    func toString() -> String
    mutating func adjust()
}


class ValueClass : Stringify{
    var val:Int
    
    init(val:Int){
        self.val = val
    }
    
    func toString() -> String {
        return "Value is \(val)"
    }
    
    func adjust() {
        val = val - val % 10
    }
}

let valC = ValueClass(val: 11)
valC.toString()
valC.adjust()
valC.toString()

struct SimpleStruct: Stringify{
    var val = 100
    
    func toString() -> String {
        return "This is \(val)"
    }
    
    mutating func adjust() {
        val = val * 2
    }
    
}

var s = SimpleStruct()
s.toString()
s.adjust()
s.toString()


extension Int : Stringify{
    
    func toString() -> String {
        return "this is \(self)"
    }
    
    mutating func adjust() {
        if(self % 10 >= 5){
            self -= ((self + 10) % 10)
        }else{
            self -= (self % 10)
        }
        
    }
}


var num = 17
num.toString()
num.adjust()
println(num)


func repete<Item>(item: Item, times: Int) -> [Item]{
    var array :[Item] = []
    for i in 0..<times {
        array.append(item)
    }
    return array
}

repete("test", 5)
repete(5, 5)


class Printer<T>{
    var value:T
    init(value:T){
        self.value = value
    }
    
    func toString() -> String{
        return "The value is \(value)"
    }
}

var x:Printer<Int> = Printer(value: 10)
x.toString()

var y:Printer<String> = Printer(value: "There you go")
y.toString()


enum Opt<T>{
    
    case None
    case Some(T)

}

var nothing: Opt<Int> = Opt.None
nothing = Opt.Some(10)

func hasAny<T, U where T: SequenceType, U:SequenceType, T.Generator.Element: Equatable, U.Generator.Element: Equatable, T.Generator.Element == U.Generator.Element>(one: T, two: U) -> Bool{
    for x in one {
        for y in two {
            if x == y{
                return true
            }
        }
    }
    return false
}


hasAny([1,2,3,4,5], [5])

hasAny([5], [1,2,3,4,5])

hasAny([1,2,3,4,5,6],[7,8,9,0])