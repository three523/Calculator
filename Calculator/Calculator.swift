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
}

class Calculator {
    private let abstractOpreation = AbstractOperation()
    private var postfix: Postfix = Postfix()
    private var result: Double = 0.0
    private var formula: [String] = []
    private var exit: Bool = false

    func run() {
        while !exit {
            input()
        }
        print("종료되었습니다.")
    }
    private func input() {
        print("계산할 식을 입력해주세요(ex: 12+8*2, +12-12*2)")
        print("이전 노드 지우기:b 완전히 지우기:c 종료:x")
        let stringFormula = formula.joined()
        print("현재 계산된 식: \(stringFormula.isEmpty ? "0" : stringFormula)")
        print("현재 결과값: \(result)")
        if let input = readLine()  {
            read(input: input)
            return
        }
    }
    private func validation(input: String) -> Bool {
        let reg: String = "^[0-9+/*().-]{1,}$"
        let reg2: String = "[+/*%.-]{2,}"
        let reg3: String = "\\(\\)"
        let validation1 = input.range(of: reg, options: .regularExpression) != nil // 0-9+/*().- 이 글자들로만 구성이 되어있는지 확인
        let validation2 = input.range(of: reg2, options: .regularExpression) == nil // +/*%.- 이 연산자가 두번 연속으로 나오지 않는지 확인
        let validation3 = input.range(of: reg3, options: .regularExpression) == nil // 빈 괄호() 가 나오지 않는지 확인
        return validation1 && validation2 && validation3
    }
    private func read(input: String) {
        let removeSpaceInput = input.components(separatedBy: .whitespaces).joined()
        if removeSpaceInput == "x" || removeSpaceInput == "X" {
            exit = true
            return
        } else if removeSpaceInput == "c" || removeSpaceInput == "C" {
            clear()
            return
        } else if removeSpaceInput == "b" || removeSpaceInput == "B" {
            backspace()
            return
        }
        guard validation(input: removeSpaceInput) else {
            print("잘못된 입력입니다.")
            return
        }
        let inputFormula = inputSplit(input: removeSpaceInput)
        let newFormula = formulaAppend(newFormula: inputFormula)
        calculate(formula: newFormula)
    }
    private func formulaAppend(newFormula: [String]) -> [String] {
        var newFormula = newFormula
        var oldFormula = formula
        var result = [String]()
        if !oldFormula.isEmpty {
            result.append(oldFormula.popLast()!)
        }
        
        while !newFormula.isEmpty {
            var temp = newFormula.removeFirst()
            if result.isEmpty {
                result.append(temp)
            } else if let resultLastStr = result.last,
                      resultLastStr == ")" && (temp.isNumber || temp == "(") {
                result.append("*")
                result.append(temp)
            } else if let resultLastStr = result.last,
                      resultLastStr.isNumber && temp == "(" {
                result.append("*")
                result.append(temp)
            } else {
                result.append(temp)
            }
        }
        var tempFormula = oldFormula + result
        if let newFirstFormula = newFormula.first,
           let oldLastFormula = tempFormula.last,
           newFirstFormula.isNumber && oldLastFormula.isNumber && !tempFormula.isEmpty {
            guard let lastNum = tempFormula.popLast() else { return formula }
            newFormula.removeFirst()
            tempFormula.append(lastNum + newFirstFormula)
        } else if let newFirstFormula = newFormula.first,
                  let oldLastFormula = tempFormula.last,
                  newFirstFormula.isBrackets && oldLastFormula.isNumber {
            newFormula.insert("*", at: 0)
        } else if let newFirstFormula = newFormula.first,
                  let oldLastFormula = tempFormula.last,
                  newFirstFormula.isNumber && oldLastFormula.isBrackets {
            newFormula.insert("*", at: 0)
        } else if let newFirstFormula = newFormula.first,
                  let oldLastFormula = tempFormula.last,
                  newFirstFormula.isBrackets && oldLastFormula.isBrackets {
            newFormula.insert("*", at: 0)
        }
        tempFormula.append(contentsOf: newFormula)
        guard validation(input: tempFormula.joined()) else {
            print("입력값이 잘못되었습니다.")
            return formula
        }
        return tempFormula
    }
    private func test(newFormula: [String]) -> Bool {
        guard let newFirstFormula = newFormula.first,
              let oldLastFormula = formula.last else { return false }
        let inputErrorCase1 = oldLastFormula.isNumber && newFirstFormula.isBrackets // ex: 2+2(2+2)
        let inputErrorCase2 = oldLastFormula.isBrackets && newFirstFormula.isNumber // ex: (2+2)2+3
        let inputErrorCase3 = oldLastFormula.isBrackets && newFirstFormula.isBrackets // ex: 2+2()
        return inputErrorCase1 || inputErrorCase2 || inputErrorCase3
    }
    private func calculate(formula: [String]) {
        if let lastText = formula.last,
           lastText.isOperator {
            self.result = 0
            self.formula = formula
            print("결과: \(result)\n")
            return
        }
        var postfixFormula = postfix.getPostfix(formula: formula)
        var stack: [Double] = []
        while !postfixFormula.isEmpty {
            let str = postfixFormula.removeFirst()
            if str.isOperator || str.isBrackets {
                if stack.count >= 2 {
                    let num2 = stack.removeLast()
                    let num1 = stack.removeLast()
                    guard let operate = Operator(rawValue: str) else {
                        print("입력값이 잘못되었습니다.")
                        return
                    }
                    stack.append(continueOperation(num1: num1, num2: num2, operation: operate))
                } else if stack.count == 1 && postfixFormula.isEmpty {
                    break
                } else {
                    print("입력값이 잘못되었습니다.")
                    return
                }
            } else {
                guard let num = Double(str) else {
                    print("double로 변환이 불가능합니다.")
                    return
                }
                stack.append(num)
            }
        }
        guard let result = stack.first else {
            print("계산이 잘못되었습니다.")
            return
        }
        self.result = result
        self.formula = formula
        print("결과: \(result)\n")
    }
    private func inputSplit(input: String) -> [String] {
        var numJoinInput = [String]()
        var inputArray = input.map{ String($0) }
        if let str = inputArray.first,
           str.isOperator && formula.isEmpty {
            inputArray.insert("0", at: 0)
        }
        var temp = [String]()
        inputArray.forEach { str in
            if str.isNumber {
                temp.append(str)
            } else {
                if !temp.isEmpty { numJoinInput.append(temp.joined()) }
                numJoinInput.append(str)
                temp.removeAll()
            }
        }
        if !temp.isEmpty { numJoinInput.append(temp.joined()) }
        return numJoinInput
    }
    private func clear() {
        formula.removeAll()
        result = 0
    }
    private func backspace() {
        formula.popLast()
        calculate(formula: formula)
    }
    private func continueOperation(num1: Double, num2: Double, operation: Operator) -> Double {
        switch operation {
        case .add:
            return abstractOpreation.addOperation(num1, num2)
        case .subtract:
            return abstractOpreation.subtractOperation(num1, num2)
        case .multiply:
            return abstractOpreation.MultiplyOperation(num1, num2)
        case .divide:
            return abstractOpreation.DivideOperation(num1, num2)
        }
    }
}
