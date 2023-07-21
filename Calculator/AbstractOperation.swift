//
//  Operation.swift
//  Calculator
//
//  Created by 김도현 on 2023/07/17.
//

class AbstractOperation {
    func operation(firstNumber: Double, secondNumber: Double) -> Double {
        return 0.0
    }
}

class AddOperation: AbstractOperation {
    override func operation(firstNumber: Double, secondNumber: Double) -> Double {
        return firstNumber + secondNumber
    }
}

class SubtractOperation: AbstractOperation {
    override func operation(firstNumber: Double, secondNumber: Double) -> Double {
        return firstNumber - secondNumber
    }
}

class MultiplyOperation: AbstractOperation {
    override func operation(firstNumber: Double, secondNumber: Double) -> Double {
        return firstNumber * secondNumber
    }
}

class DivideOperation: AbstractOperation {
    override func operation(firstNumber: Double, secondNumber: Double) -> Double {
        return firstNumber / secondNumber
    }
}
