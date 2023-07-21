//
//  Calculator.swift
//  Calculator
//
//  Created by 김도현 on 2023/07/17.
//

import Foundation
enum Operator: String {
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
    
    func getOperator() -> AbstractOperation {
        switch self {
        case.add: return AddOperation()
        case .subtract: return SubtractOperation()
        case .multiply: return MultiplyOperation()
        case .divide: return DivideOperation()
        }
    }
}

class Calculator {
    private var abstractOpreation = AbstractOperation()
    private var postfix: Postfix = Postfix()

    func calculate(formula: [String]) -> Double? {
        if let lastText = formula.last,
           lastText.isOperator {
            return nil
        }
        var postfixFormula = postfix.getPostfix(formula: formula)
        var stack: [Double] = []
        while !postfixFormula.isEmpty {
            let str = postfixFormula.removeFirst()
            if str.isOperator || str.isBrackets {
                if stack.count >= 2 {
                    let num2 = stack.removeLast()
                    let num1 = stack.removeLast()
                    guard let operate = Operator(rawValue: str) else { return 0 }
                    abstractOpreation = operate.getOperator()
                    stack.append(continueOperation(num1: num1, num2: num2))
                } else if stack.count == 1 && postfixFormula.isEmpty {
                    break
                } else { return nil }
            } else {
                guard let num = Double(str) else { return nil }
                stack.append(num)
            }
        }
        guard let result = stack.first else { return nil }

        return result
    }
    private func continueOperation(num1: Double, num2: Double) -> Double {
        abstractOpreation.operation(firstNumber: num1, secondNumber: num2)
    }
}
