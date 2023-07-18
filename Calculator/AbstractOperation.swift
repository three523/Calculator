//
//  Operation.swift
//  Calculator
//
//  Created by 김도현 on 2023/07/17.
//

class AbstractOperation {
    func addOperation(_ num1: Double, _ num2: Double) -> Double {
        return num1 + num2
    }
    
    func subtractOperation(_ num1: Double, _ num2: Double) -> Double {
        return num1 - num2
    }
    
    func MultiplyOperation(_ num1: Double, _ num2: Double) -> Double {
        return num1 * num2
    }
    
    func DivideOperation(_ num1: Double, _ num2: Double) -> Double {
        return num1 / num2
    }
}
