//
//  Calculator.swift
//  Calculator
//
//  Created by 김도현 on 2023/07/17.
//

import Foundation
enum Operation: String {
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
}

class Calculator {
    private let abstractOpreation = AbstractOperation()
    private var postfix: Postfix = Postfix()
    private let operates: [Character] = ["+","-","/","*","(",")"]
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
        let reg: String = "^[0-9+/*()-.]{1,}$"
        let reg2: String = "[+/*%-.]{2,}"
        let validation1 = input.range(of: reg, options: .regularExpression) != nil
        let validation2 = input.range(of: reg2, options: .regularExpression) == nil
        return validation1 && validation2
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
        formulaAppend(newFormula: inputFormula)
        calculate()
    }
    private func formulaAppend(newFormula: [String]) {
        var newFormula = newFormula
        if let newFirstNum = newFormula.first,
           !operates.contains(newFirstNum) && !formula.isEmpty  {
            guard let lastNum = formula.popLast() else { return }
            newFormula.removeFirst()
            formula.append(lastNum + newFirstNum)
            formula.append(contentsOf: newFormula)
        } else {
            formula.append(contentsOf: newFormula)
        }
    }
    private func calculate() {
        var postfixFormula = postfix.getPostfix(formula: formula)
        var stack: [Double] = []
        while !postfixFormula.isEmpty {
            let str = postfixFormula.removeFirst()
            if operates.contains(str) {
                let num2 = stack.removeLast()
                let num1 = stack.removeLast()
                guard let operate = Operation(rawValue: str) else {
                    print("입력값이 잘못되었습니다.")
                    return
                }
                stack.append(continueOperation(num1: num1, num2: num2, operation: operate))
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
        print("결과: \(result)\n")
    }
    private func inputSplit(input: String) -> [String] {
        var numJoinInput = [String]()
        var inputArray = input.map{ String($0) }
        if let str = inputArray.first,
           operates.contains(str) && str != ")" && str != ")" && formula.isEmpty {
            inputArray.insert("0", at: 0)
        }
        var temp = [String]()
        inputArray.forEach { str in
            if !operates.contains(str) {
                temp.append(str)
            } else {
                if !temp.isEmpty { numJoinInput.append(temp.joined()) }
                numJoinInput.append(str)
                temp.removeAll()
            }
        }
        numJoinInput.append(temp.joined())
        return numJoinInput
    }
    private func clear() {
        formula.removeAll()
        result = 0
    }
    func backspace() {
        formula.popLast()
    }
    private func continueOperation(num1: Double, num2: Double, operation: Operation) -> Double {
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
