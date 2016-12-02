import Foundation

class EmanonClass {

    private var expression: Expression!


    var expressionString: String {
        get {
            return expression.toString()
        }
    }


    func createExpression(depth: Int) {
        expression = ExpressionBuilder.generate(depth: depth)
    }


    func evalExpression(x: Double, y: Double) -> Double {
        return expression.eval(args: ["x": x, "y": y])
    }
}


typealias ParameterName = String
typealias OperationName = String
typealias UnaryOperation = (Double) -> Double
typealias BinaryOperation = (Double, Double) -> Double


protocol Expression {

    static var operationNames: [OperationName] {get}

    func eval(args: [ParameterName: Double]) -> Double

    func toString() -> String

}


class ExpressionBuilder {

    static func generate(depth: Int) -> Expression {

        let rnd = drand48()

        if depth == 0 { //|| rnd < 0.1 {
            return Constant(operationName: Constant.operationNames.randomItem())
        }
        else if rnd < 0.5 {
            return UnaryExpression(operationName: UnaryExpression.operationNames.randomItem(),
                                   expr: generate(depth: depth-1))
        }
        else {
            return BinaryExpression(operationName: BinaryExpression.operationNames.randomItem(),
                                    expr1: generate(depth: depth-1),
                                    expr2: generate(depth: depth-1))
        }
    }

}


class Constant: Expression {

    private static let operations: [OperationName] = ["x", "y"]

    static var operationNames: [OperationName] = operations

    //

    var operationName: OperationName

    init(operationName: ParameterName) {
        self.operationName = operationName
    }

    func eval(args: [ParameterName: Double]) -> Double {
        return args[operationName]!
    }

    func toString() -> String {
        return operationName
    }
}


class UnaryExpression: Expression {

    private static let operations: [OperationName: UnaryOperation] = [
        "-": { -$0 },
        "sin": { sin($0) },
        "cos": { cos($0) },
        ]

    internal static var operationNames: [OperationName] = Array(operations.keys)
    
    //

    var operationName: OperationName
    var expr: Expression

    init(operationName: OperationName, expr: Expression) {
        self.operationName = operationName
        self.expr = expr
    }

    func eval(args: [ParameterName: Double]) -> Double {
        let op = UnaryExpression.operations[operationName]!
        return op(expr.eval(args: args))
    }

    func toString() -> String {
        return "(\(operationName) \(expr.toString()))"
    }
}


class BinaryExpression: Expression {

    private static let operations: [OperationName: BinaryOperation] = [
        "+": { $0 + $1 },
        "-": { $0 - $1 },
        "*": { $0 * $1 }
    ]

    internal static var operationNames: [OperationName] = Array(operations.keys)

    //

    var operationName: OperationName
    var expr1: Expression
    var expr2: Expression

    init(operationName: OperationName, expr1: Expression, expr2: Expression) {
        self.operationName = operationName
        self.expr1 = expr1
        self.expr2 = expr2
    }

    func eval(args: [ParameterName: Double]) -> Double {
        let op = BinaryExpression.operations[operationName]!
        return op(expr1.eval(args: args), expr2.eval(args: args))
    }

    func toString() -> String {
        return "(\(operationName) \(expr1.toString()) \(expr2.toString()))"
    }
}
