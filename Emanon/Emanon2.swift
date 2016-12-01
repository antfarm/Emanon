//
//  Emanon2.swift
//  Emanon
//
//  Created by sean on 01/12/2016.
//  Copyright © 2016 antfarm. All rights reserved.
//

import Foundation


class Emanon2 {

    private(set) var expression: Expression!


    func createExpression(depth: Int) {
        expression = Expression.randomExpression(depth: 6)
    }


    func evalExpression(x: Double, y: Double) throws -> Double {
        return try Expression.eval(expression: expression, args: ["x": x, "y": y])
    }


    indirect enum Expression {

        case constant(ParameterName)
        case unaryExpression(UnaryOperation, Expression)
        case binaryExpression(BinaryOperation, Expression, Expression)


        typealias ParameterName = String
        typealias UnaryOperation = (Double) -> Double
        typealias BinaryOperation = (Double, Double) -> Double


        private static var parameterNames: [ParameterName] {
            get {
                return ["x", "y"]
            }
        }


        private static var unaryOperations: [UnaryOperation] {
            get {
                return [{ -$0 }, { sin($0) }, { cos($0) }, { sqrt($0) }]
            }
        }


        private static var binaryOperations: [BinaryOperation] {
            get {
                return [{ $0 + $1 }, { $0 - $1 }, { $0 * $1 }, { $0 / $1 }]
            }
        }


        static func randomExpression(depth: Int) -> Expression {

            let rnd = drand48()

            if depth == 0 || rnd < 0.3 {
                return .constant(parameterNames.randomItem())
            }
            else if rnd < 0.7 {
                return .unaryExpression(unaryOperations.randomItem(), randomExpression(depth: depth-1))
            }
            else {
                return .binaryExpression(binaryOperations.randomItem(), randomExpression(depth: depth-1), randomExpression(depth: depth-1))
            }
        }


        static func eval(expression: Expression, args: [String: Double]) throws -> Double {

            switch expression {

            case let .constant(parameterName):
                return args[parameterName]!

            case let .unaryExpression(op, expr):
                return try op(eval(expression: expr, args: args))

            case let .binaryExpression(op, expr1, expr2):
                return try op(eval(expression: expr1, args: args), eval(expression: expr2, args: args))
            }
        }
    }
}

