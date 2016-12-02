import Foundation


class EmanonEnum {

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

            if depth == 0 || rnd < 0.1 {
                return .constant(parameterNames.randomItem())
            }
            else if rnd < 0.6 {
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


func mainEnum() {

    let emanon = EmanonEnum()

    let sizeX = 320
    let sizeY = 320

    for _ in 1...100 {

        emanon.createExpression(depth: 5)

        print(emanon.expressionString)

        var values = [[Double]]()

        var maxValue = DBL_MIN
        var minValue = DBL_MAX


        for x in 0 ..< sizeX {

            var row = [Double]()

            for y in 0 ..< sizeY {

                let value = emanon.evalExpression(x: Double(x), y: Double(y))

                maxValue = max(value, maxValue)
                minValue = min(value, minValue)

                //print("\(value) | \(minValue) ... \(maxValue)")

                row.append(value)
            }

            values.append(row)
        }

        //print("\(minValue) ... \(maxValue)")

        //

        var valuesNormalized = [[Double]]()

        for row in values {
            let rowNormalized = row.map { ($0 - minValue) / (maxValue - minValue)}
            valuesNormalized.append(rowNormalized)
        }
        
        //for rowNormalized in valuesNormalized {
        //    print("\(rowNormalized.min()!) ... \(rowNormalized.max()!)")
        //}
        
        print()
    }
}

