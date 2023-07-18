//
//  main.swift
//  Calculator
//
//  Created by 김도현 on 2023/07/17.
//

import Foundation

//Calculator().run()

class Postfix {
    var result: [String] = []
    var operationStack: [String] = []
    private let operationPriority: [String: Int] = [ "(": 0, "+": 1, "-": 1, "*": 2, "/": 2, ")": 0 ]
    var formula: [String]
    init(formula: [String]) {
        self.formula = formula
        run()
    }
    func run() {
        while !formula.isEmpty {
            var temp = formula.removeFirst()
            if operationPriority.keys.contains(temp) {
                if temp == "(" {
                    operationStack.append(temp)
                } else if temp == ")" {
                    for _ in 0..<operationStack.count {
                        if let last = operationStack.last {
                            if last == "(" {
                                operationStack.removeLast()
                                break
                            }
                            result.append(operationStack.removeLast())
                        }
                    }
                } else if operationStack.isEmpty {
                    operationStack.append(temp)
                } else {
                    while !operationStack.isEmpty {
                        let operation = operationStack.last!
                        if operationPriority[operation]! >= operationPriority[temp]! {
                            result.append(operationStack.removeLast())
                        } else {
                            break
                        }
                    }
                    operationStack.append(temp)
                }
            } else {
                result.append(temp)
            }
        }
        while !operationStack.isEmpty {
            result.append(operationStack.removeLast())
        }
    }
}

let a = "1*(2+3)/2/2"
var b = a.split(separator: "").map{ String($0) }

let stack = Postfix(formula: b)
print(stack.result)
