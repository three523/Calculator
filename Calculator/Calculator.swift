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
    private var previousNum: Double = 0
    private var result: Double = 0
    private var nextNum: Double? = nil
    private var operations: [Operation] = []
    private var num: [Double] = []
    private var formula: [String] = []
    private var formulaString: String {
        formula.joined()
    }
    private let reg: String = "^[0-9+/*-]{1,}$"
    private let reg2: String = "[+/*%-]{2,}"
    private let operationPriority: [String: Int] = [ "+": 0, "-": 0, "*": 1, "/": 1 ]

    private let numbers: [Character] = Array(0...9).compactMap { Character(String($0)) }
    private var exit: Bool = false
    private var stack: [String] = []
    
    func run() {
        while !exit {
            input()
        }
        print("종료되었습니다.")
    }
    private func input() {
        print("계산할 식을 입력해주세요(ex: 12+8*2, +12-12*2)")
        print("이전 노드 지우기:b 완전히 지우기:c 종료:x")
        print("현재 상태: \(formulaString.isEmpty ? "0" : formulaString)")
        if let input = readLine()  {
            read(input: input)
            return
        }
    }
    private func validation(input: String) -> Bool {
        let validation1 = input.range(of: reg, options: .regularExpression) != nil
        let validation2 = input.range(of: reg2, options: .regularExpression) == nil
        print(validation1)
        print(validation2)
        return validation1 && validation2
    }
    private func read(input: String) {
        let removeSpaceInput = input.components(separatedBy: .whitespaces).joined()
        if input == "x" {
            exit = true
            return
        } else if input == "c" {
            clear()
            return
        } else if input == "b" {
            backspace()
            return
        }
        var test: [String] = input.filter{ $0 != " " }.map{ String($0) }
        let opreate: [Character] = ["+","-","/","*"]
        var temp = [String]()
        var results = [String]()
        test.forEach { str in
            if !opreate.contains(str) {
                temp.append(str)
            } else {
                results.append(temp.joined())
                results.append(str)
                temp.removeAll()
            }
        }
        results.append(temp.joined())
        inputSplit(input: removeSpaceInput)
    }
    private func calculate() {  }
    private func inputSplit(input: String) {
        let inputNumbers = input.components(separatedBy: ["+","-","/","*"]).compactMap{ Double($0) }
        let opreate: [Character] = ["+","-","/","*"]
        let test = input.components(separatedBy: ["0","1","2","3","4","5","6","7","8","9"])
        let inputOperations = input.filter{ opreate.contains($0) }.compactMap{
            Operation(rawValue: String($0))
        }
        guard validation(input: input) else {
            print("잘못 입력하였습니다.")
            return
        }
        
        print(num, operations)
        num = inputNumbers
        operations.append(contentsOf: inputOperations)
        if num.count - 1 == operations.count {
            result = num.removeFirst()
        } else if num.count == operations.count {
            if formula.isEmpty { formula.insert("0", at: 0) }
        } else {
            print("입력이 잘못되었습니다.")
            return
        }
        operations.forEach { opreation in
            continueOperation(num1: result, num2: num.removeFirst(), operation: opreation)
        }
        print(result)
        
        formula.append(contentsOf: input.map{ String($0) })
        print(formula)
        operations.removeAll()
    }
    private func clear() {
        num.removeAll()
        operations.removeAll()
        formula.removeAll()
        result = 0
    }
    func backspace() {}
    private func continueOperation(num1: Double, num2: Double, operation: Operation) {
        previousNum = result
        switch operation {
        case .add:
            result = abstractOpreation.addOperation(num1, num2)
        case .subtract:
           result = abstractOpreation.subtractOperation(num1, num2)
        case .multiply:
            result = abstractOpreation.MultiplyOperation(num1, num2)
        case .divide:
            result = abstractOpreation.DivideOperation(num1, num2)
        }
    }
}
