//
//  ViewController.swift
//  Calculator
//
//  Created by Alykhan Kanji on 2015-01-31.
//  Copyright (c) 2015 Alykhan Kanji. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if digit == "." && display.text!.rangeOfString(".") != nil {
                return
            }
            display.text = display.text! + digit
        } else {
            display.text = (digit == ".") ? "0." : digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if operation == "ᐩ/-" {
                if display.text?.rangeOfString("-") != nil {
                    display.text = dropFirst(display.text!)
                } else {
                    display.text = "-" + display.text!
                }
                return
            }
            enter()
        }
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": performOperation { M_PI }
        case "ᐩ/-": performOperation { -$0 }
        default: break
        }
        removeTrailingEquals()
        history.text = history.text! + " \(operation) ="
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enterOperation()
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enterOperation()
        }
    }
    
    func performOperation(operation: Void -> Double) {
        displayValue = operation()
        enterOperation()
    }

    var operandStack = [Double]()
    
    @IBAction func enter() {
        removeTrailingEquals()
        if let value = displayValue {
            history.text = history.text! + " \(value)"
        }
        enterOperation()
    }
    
    func enterOperation() {
        userIsInTheMiddleOfTypingANumber = false
        if let value = displayValue {
            operandStack.append(value)
        }
        println("operandStack = \(operandStack)")
    }
    
    func removeTrailingEquals() {
        if let equalsRange = history.text!.rangeOfString(" =") {
            history.text!.removeRange(equalsRange)
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack = []
        displayValue = nil
        history.text = " "
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            if countElements(display.text!) > 1 {
                display.text = dropLast(display.text!)
            } else if countElements(display.text!) == 1 {
                displayValue = nil
            }
        }
    }
    
    var displayValue: Double? {
        get {
            if let value = NSNumberFormatter().numberFromString(display.text!) {
                return value.doubleValue
            } else {
                return nil
            }
        }
        set {
            if let value = newValue {
                display.text = "\(value)"
            } else {
                display.text = "0"
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

