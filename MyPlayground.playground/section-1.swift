// Playground - noun: a place where people can play

import UIKit

let i :Double = 10
let j :Double = 20

let p = j / i

let stat = "Value of p is \(p)"

println(stat)

let binary = 0b1010101
let oct = 0o12345
let hex = 0xff

println("Values are \(binary) and \(oct) and \(hex)")


let float = 1.25e5

println("Float is \(float) or we can say \(Int(float))")

let test :UInt16 = 1

typealias YOO = String

let i_am_cool:YOO = "I Am Cool"


println(i_am_cool)


let z = false
if z{
    println("z is true")
}else{
    println("z is false")
}

let y = false

if z || y{
    println("one Of y and z is true")
}else{
    println("Both y and z are false")
}

if z || !y{
    println("Something is true")
}


let mohammad = ("Mohammad", 29, 180)
let someone  = ("SomeOne", 10, 100)


if mohammad.2 > someone.2{
    println("\(mohammad.0) is taller")
}

if mohammad.1 < someone.1{
    println("\(mohammad.0) is younger")
}else{
    println("\(someone.0) is younger")
}


let (name, age, height) = mohammad
println("\(name) and \(age) and \(height)")


let userInfo = (name:"Mohammad", age: 29, height :180, nationality:"Indian", hobby:["work","reading"])

let description = "name is \(userInfo.name), height is \(userInfo.height)cm, nationality is \(userInfo.nationality)"


let value = "123".toInt()
let otherValue = "abc".toInt()

var response :Int?

response = 404;

if response == 404{
    println("Page not found \(response!)")
}

if let code = response {
    println("Page not found \(code)")
}

let someValue:Int? = nil

if let x = someValue {
    println("Unknown response \(x)")
}else{
    println("someValue is nil")
}






