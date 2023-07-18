import Cocoa

class Stack {
    var result: [String] = []
    var operationStack: [String] = []
    private let operationPriority: [String: Int] = [ "+": 0, "-": 0, "*": 1, "/": 1 ]
    var formula: [String]
    init(formula: [String]) {
        self.formula = formula
        run()
    }
    func run() {
        while formula.isEmpty {
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
                    for index in 0..<operationStack.count {
                        let operation = operationStack[index]
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
    }
    func push() { }
    func pop() { }
}

let a = "1*2+3/2/2"
var b = a.split(separator: "").map{ String($0) }

let stack = Stack(formula: b)
print(stack.result)
