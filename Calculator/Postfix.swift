//
//  Postfix.swift
//  Calculator
//
//  Created by 김도현 on 2023/07/18.
//

import Foundation

class Postfix {
    private var operationStack: [String] = []
    private let operationPriority: [String: Int] = [ "(": 0, ")": 0, "+": 1, "-": 1, "*": 2, "/": 2 ]

    func getPostfix(formula: [String]) -> [String] {
        var formula = formula
        var result: [String] = []
        while !formula.isEmpty {
            let temp = formula.removeFirst()
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
        return result
    }
}
