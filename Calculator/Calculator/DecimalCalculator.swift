//
//  DecimalCalculator.swift
//  Calculator
//
//  Created by sookim on 2021/03/26.
//

import Foundation

//: [Previous](@previous)

// MARK: OperatorCase

//let plus: (Double, Double) -> Double = (+)
//let minus: (Double, Double) -> Double = (-)
//let multiple: (Double, Double) -> Double = (*)
//let divide: (Double, Double) -> Double = (/)

enum OperatorCase {
    case plus, minus, multiple, divide
    
    var assignVarOperator: (Double, Double) -> Double {
        switch self {
        case .plus:
            return (+)
        case .minus:
            return (-)
        case .multiple:
            return (*)
        case .divide:
            return (/)
        }
    }
}


// MARK: STACK

class Node<Value> {
    var value: Value
    var next: Node?
    
    init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

struct Stack<Value> {
    var head: Node<Value>?
    var tail: Node<Value>?
    
    var isEmpty: Bool {
        return head == nil
    }
    
    func peek () -> Node<Value>? {
      return head
    }
    
    mutating func push(_ value: Value) {
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }
    
    mutating func append(_ value: Value) {
        guard !isEmpty else {
            push(value)
            return
        }
        tail!.next = Node(value: value)
        tail = tail?.next
    }
    
    mutating func pop() -> Value? {
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }
    
    mutating func removeLast() -> Value? {
        guard let head = head else {
            return nil
        }
        guard head.next != nil else {
            return pop()
        }
        var prev = head
        var current = head
        
        while let next = current.next {
            prev = current
            current = next
        }
        prev.next = nil
        tail = prev
        return current.value
    }
}

// MARK: NODEGROUP

class NodeGroup {
    var previousOperator: OperatorCase
    var number: Double
    
    init(previousOperator: OperatorCase, number: Double) {
        self.previousOperator = previousOperator
        self.number = number
    }
}

// MARK: INPUT
var entireStack = Stack<NodeGroup>()
var base:Double = 3
var operationNode: [NodeGroup] = [
    NodeGroup(previousOperator: .multiple, number: 5),
    NodeGroup(previousOperator: .multiple, number: 5),
    NodeGroup(previousOperator: .plus, number: 5)
]

// MARK: TESTCASE
print("\(base)",terminator: " ")

for i in 0..<operationNode.count {
    switch operationNode[i].previousOperator {
        case .plus:
            print("+ \(operationNode[i].number)", terminator: " ")
        case .minus:
            print("- \(operationNode[i].number)", terminator: " ")
        case .multiple:
            print("* \(operationNode[i].number)", terminator: " ")
        case .divide:
            print("/ \(operationNode[i].number)", terminator: " ")
    }
    
}

// MARK: STACKPUSH
for i in  0..<operationNode.count {
    switch operationNode[i].previousOperator {
    case .plus, .minus:
        entireStack.push(operationNode[i])
    case .multiple, .divide:
        if entireStack.isEmpty {
            let baseNode: Double = operationNode[i].previousOperator.assignVarOperator(base, operationNode[i].number)
            operationNode[i].previousOperator  = .plus
            operationNode[i].number = baseNode
            base = 0
        }
        else {
            let newNode = entireStack.pop()!
            let resultNode: Double = operationNode[i].previousOperator.assignVarOperator(newNode.number, operationNode[i].number)

            operationNode[i].previousOperator = newNode.previousOperator
            operationNode[i].number = resultNode
        }
        entireStack.push(operationNode[i])
    }
}

// MARK: STACKRESULT
var resultNum: Double = 0

while !entireStack.isEmpty {
    let newNode = entireStack.pop()!
    
    if newNode.previousOperator == .plus {
        resultNum += newNode.number
    } else {
        resultNum -= newNode.number
    }
}

print("결과 : \(resultNum  + base)")
