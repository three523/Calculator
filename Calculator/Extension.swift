//
//  Extension.swift
//  Calculator
//
//  Created by 김도현 on 2023/07/19.
//

import Foundation

extension String {
    var isOperator: Bool {
        let operators = ["+","-","/","*"]
        return operators.contains(self)
    }
    var isBrackets: Bool {
        let brackets = ["(",")"]
        return brackets.contains(self)
    }
    var isNumber: Bool {
        return Double(self) != nil
    }
}
