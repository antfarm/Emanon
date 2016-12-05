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


//typealias ParameterName = String
//typealias OperationName = String
typealias UnaryOperation = (Double) -> Double
typealias BinaryOperation = (Double, Double) -> Double


protocol Expression {
    func eval(args: [ParameterName: Double]) -> Double
    func toString() -> String
}


class ExpressionBuilder {

    private static let constants: [ParameterName] = ["x", "y"]

    private static let unaryOperations: [OperationName: UnaryOperation] = [

        "-": { -$0 },
        "sin": { sin($0) },
        "cos": { cos($0) },
    ]

    private static let binaryOperations: [OperationName: BinaryOperation] = [

        "+": { $0 + $1 },
        "-": { $0 - $1 },
        "*": { $0 * $1 }
    ]

    static func generate(depth: Int) -> Expression {

        let rnd = drand48()

        if depth == 0 { //|| rnd < 0.1 {
            return Constant(parameterName: constants.randomItem())
        }
        else if rnd < 0.5 {
            let operationName = Array(unaryOperations.keys).randomItem()
            return UnaryExpression(operationName: operationName,
                                   operation: unaryOperations[operationName]!,
                                   expr: generate(depth: depth-1))
        }
        else {
            let operationName = Array(binaryOperations.keys).randomItem()
            return BinaryExpression(operationName: operationName,
                                    operation: binaryOperations[operationName]!,
                                    expr1: generate(depth: depth-1),
                                    expr2: generate(depth: depth-1))
        }
    }

}


class Constant: Expression {

    var parameterName: OperationName

    init(parameterName: ParameterName) {
        self.parameterName = parameterName
    }

    func eval(args: [ParameterName: Double]) -> Double {
        return args[parameterName]!
    }

    func toString() -> String {
        return parameterName
    }
}


class UnaryExpression: Expression {

    var operationName: OperationName
    var operation: UnaryOperation
    var expr: Expression

    init(operationName: OperationName, operation: @escaping UnaryOperation, expr: Expression) {
        self.operationName = operationName
        self.operation = operation
        self.expr = expr
    }

    func eval(args: [ParameterName: Double]) -> Double {
        return operation(expr.eval(args: args))
    }

    func toString() -> String {
        return "(\(operationName) \(expr.toString()))"
    }
}


class BinaryExpression: Expression {

    var operationName: OperationName
    var operation: BinaryOperation
    var expr1: Expression
    var expr2: Expression

    init(operationName: OperationName, operation: @escaping BinaryOperation, expr1: Expression, expr2: Expression) {
        self.operationName = operationName
        self.operation = operation
        self.expr1 = expr1
        self.expr2 = expr2
    }

    func eval(args: [ParameterName: Double]) -> Double {
        return operation(expr1.eval(args: args), expr2.eval(args: args))
    }

    func toString() -> String {
        return "(\(operationName) \(expr1.toString()) \(expr2.toString()))"
    }
}
