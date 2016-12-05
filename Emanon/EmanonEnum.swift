import Foundation


class EmanonEnum: Emanon {

    private var expression: Expression!


    var expressionString: String {
        get {
            return expression.toString()
        }
    }


    func createExpression(depth: Int) {
        expression = Expression.generate(depth: depth)
    }


    func evalExpression(x: Double, y: Double) -> Double {
        return expression.eval(args: ["x": x, "y": y])
    }


    indirect enum Expression {

        typealias ParameterName = String
        typealias OperationName = String
        typealias UnaryOperation = (Double) -> Double
        typealias BinaryOperation = (Double, Double) -> Double

        
        case constant(ParameterName)
        case unaryExpression(OperationName, Expression)
        case binaryExpression(OperationName, Expression, Expression)


        private static var parameterNames: [ParameterName] {
            get {
                return ["x", "y"]
            }
        }


        private static var unaryOperations: [OperationName: UnaryOperation] {
            get {
                return [
                    "-": { -$0 },
                    "sin": { sin($0) },
                    "cos": { cos($0) },
                ]
            }
        }


        private static var binaryOperations: [OperationName: BinaryOperation] {
            get {
                return [
                    "+": { $0 + $1 },
                    "-": { $0 - $1 },
                    "*": { $0 * $1 }
                ]
            }
        }


        static func generate(depth: Int) -> Expression {

            let rnd = drand48()

            if depth == 0 { //|| rnd < 0.1 {
                return .constant(parameterNames.randomItem())
            }
            else if rnd < 0.5 {
                return .unaryExpression(Array(unaryOperations.keys).randomItem(),
                                        generate(depth: depth-1))
            }
            else {
                return .binaryExpression(Array(binaryOperations.keys).randomItem(),
                                         generate(depth: depth-1),
                                         generate(depth: depth-1))
            }
        }


        func eval(args: [String: Double]) -> Double {

            switch self {

            case let .constant(parameterName):
                return args[parameterName]!

            case let .unaryExpression(operationName, expr):
                let op = Expression.unaryOperations[operationName]!
                return op(expr.eval(args: args))

            case let .binaryExpression(operationName, expr1, expr2):
                let op = Expression.binaryOperations[operationName]!
                return op(expr1.eval(args: args), expr2.eval(args: args))
            }
        }


        func toString() -> String {

            switch self {

            case let .constant(parameterName):
                return parameterName

            case let .unaryExpression(operationName, expr):
                return "(\(operationName) \(expr.toString()))"

            case let .binaryExpression(operationName, expr1, expr2):
                return "(\(operationName) \(expr1.toString()) \(expr2.toString()))"
            }
        }
    }
}
