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
    private var result: Double = 0.0
    private var formula: [String] = []
    private var exit: Bool = false

    func run() {
        print("*** 주의사항: 입력할떄 괄호()를 꼭 직접 입력하여 닫아주셔야 합니다. 자동완성으로 괄호가 닫히는 경우 입력이 제대로 되지 않습니다.***")
        while !exit {
            input()
        }
        print("종료되었습니다.")
    }
    private func input() {
        formula.isEmpty ? print("계산할 식을 입력해주세요(ex: +3, 12+3*3, 2+2(3+4)2+3/3)") :
                           print("계산할 식을 추가로 입력해주세요 (ex: +, 2, +2, (2.2+2), +3(2+3))")
        print("한글자 지우기:b 모두 지우기:c 종료:x")
        let stringFormula = formula.joined()
        print("현재 계산된 식: \(stringFormula.isEmpty ? "0" : stringFormula)")
        print("현재 결과값: \(result)")
        if let input = readLine()  {
            read(input: input)
            return
        }
    }
    private func validation(input: String) -> Bool {
        var input = input
        if let oldLastStr = formula.last,
           !oldLastStr.isBrackets {
            input.insert(contentsOf: oldLastStr, at: input.startIndex)
        }
        let reg: String = "^[0-9+/*().-]{1,}$"
        let reg2: String = "[+/*%.-]{2,}"
        let reg3: String = "\\(\\)"
        let reg4: String = "\\([+/*%.-]|[+/*%.-]\\)"
        let validation1 = input.range(of: reg, options: .regularExpression) != nil // 0-9+/*().- 이 글자들로만 구성이 되어있는지 확인
        let validation2 = input.range(of: reg2, options: .regularExpression) == nil // +/*%.- 이 연산자가 두번 연속으로 나오지 않는지 확인
        let validation3 = input.range(of: reg3, options: .regularExpression) == nil // 빈 괄호() 가 나오지 않는지 확인
        let validation4 = input.range(of: reg4, options: .regularExpression) == nil // (+2), (2-) 같은 입력이 나오지 않는지 확인
        
        let reg5 = "\\("
        let reg6 = "\\)"
        do {
            let regex1 = try NSRegularExpression(pattern: reg5)
            let regex2 = try NSRegularExpression(pattern: reg6)
            let results1 = regex1.matches(in: input,
                                          range: NSRange(input.startIndex..., in: input)).count
            let results2 = regex2.matches(in: input,
                                          range: NSRange(input.startIndex..., in: input)).count
            return validation1 && validation2 && validation3 && validation4  && results1 == results2
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
        }
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
            result = 0
            return
        }
        let newFormula = formulaAppend(appendFormula: removeSpaceInput.map{ String($0) })
        calculate(formula: newFormula)
    }
    private func formulaAppend(appendFormula: [String]) -> [String] {
        var appendFormula = appendFormula
        var oldFormula = formula
        if let str = appendFormula.first,
           str.isOperator && oldFormula.isEmpty {
            appendFormula.insert("0", at: 0)
        }
        var result = [String]()
        if !oldFormula.isEmpty {
            result.append(oldFormula.popLast()!)
        }
        while !appendFormula.isEmpty {
            let temp = appendFormula.removeFirst()
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
            } else if let lastStr = result.last,
                      lastStr.isNumber && temp.isNumber {
                result.removeLast()
                result.append(lastStr + temp)
            } else if let lastStr = result.last,
                      let lastChar = lastStr.last,
                      lastChar == "." && temp.isNumber {
                result.removeLast()
                result.append(lastStr + temp)
            } else if let lastStr = result.last,
                      lastStr.isNumber && temp == "." {
                result.removeLast()
                result.append(lastStr + temp)
            } else {
                result.append(temp)
            }
        }
        var tempFormula = oldFormula + result
        tempFormula.append(contentsOf: appendFormula)
        return tempFormula
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
                        result = 0
                        return
                    }
                    abstractOpreation = operate.getOperator()
                    stack.append(continueOperation(num1: num1, num2: num2))
                } else if stack.count == 1 && postfixFormula.isEmpty {
                    break
                } else {
                    result = 0
                    return
                }
            } else {
                guard let num = Double(str) else {
                    print("double로 변환이 불가능합니다.")
                    result = 0
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
    private func clear() {
        formula.removeAll()
        result = 0
    }
    private func backspace() {
        formula.popLast()
        calculate(formula: formula)
    }
    private func continueOperation(num1: Double, num2: Double) -> Double {
        abstractOpreation.operation(firstNumber: num1, secondNumber: num2)
    }
}
