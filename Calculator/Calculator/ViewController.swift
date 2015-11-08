import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!

    var userIsInTheMiddleOfTypingANumber = false

    var brain = CalculatorBrain()

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
                    display.text = String((display.text!).characters.dropFirst())
                } else {
                    display.text = "-" + display.text!
                }
                return
            }
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
            removeTrailingEquals()
            history.text = history.text! + " \(operation) ="
        }
    }

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
            brain.pushOperand(value)
        }
    }

    func removeTrailingEquals() {
        if let equalsRange = history.text!.rangeOfString(" =") {
            history.text!.removeRange(equalsRange)
        }
    }

    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        brain.clear()
        displayValue = nil
        history.text = " "
    }

    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            if display.text!.characters.count > 1 {
                display.text = String((display.text!).characters.dropLast())
            } else if display.text!.characters.count == 1 {
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
