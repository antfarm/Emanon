import Foundation


class EmanonClass2 {

    private var expression: SExpression!


    var expressionString: String {
        get {
            return expression.toString()
        }
    }

    func createExpression(depth: Int) {
        expression = SExpressionBuilder.generate(depth: depth)
    }

    func evalExpression(x: Double, y: Double) -> Double {
        return expression.eval(args: ["x": x, "y": y])
    }
}


typealias ParameterName = String
typealias OperationName = String
typealias Operation = ([Double]) -> Double


class SExpressionBuilder {

    private static let constants: [OperationName] = ["x", "y"]

    private static let unaryOperations: [OperationName: Operation] = [

        "-":   { -$0[0] },
        "sin": { sin($0[0]) },
        "cos": { cos($0[0]) }
    ]

    private static let binaryOperations: [OperationName: Operation] = [
        // https://www.cocoawithlove.com/blog/2016/07/12/type-checker-issues.html

        "+": { $0[0] as Double + $0[1] as Double},
        "-": { $0[0] as Double - $0[1] as Double},
        "*": { $0[0] as Double * $0[1] as Double}
    ]

    static func generate(depth: Int) -> SExpression {

        let rnd = drand48()

        if depth == 0 { //|| rnd < 0.1 {

            return SExpression(operationName: constants.randomItem(),
                               operation: nil,
                               operands: nil)
        }
        else if rnd < 0.5 {

            let operationName = Array(unaryOperations.keys).randomItem()
            return SExpression(operationName: operationName,
                               operation: unaryOperations[operationName]!,
                               operands: [generate(depth: depth-1)])
        }
        else {

            let operationName = Array(binaryOperations.keys).randomItem()
            return SExpression(operationName: operationName,
                               operation: binaryOperations[operationName]!,
                               operands: [generate(depth: depth-1), generate(depth: depth-1)])
        }
    }
}


class SExpression {

    var operationName: OperationName
    var operation: Operation?
    var operands: [SExpression]?


    init(operationName: OperationName, operation: Operation?, operands: [SExpression]?) {

        self.operationName = operationName
        self.operation = operation
        self.operands = operands
    }


    func eval(args: [ParameterName: Double]) -> Double {

        guard let operation = operation, let operands = operands else {
            return args[operationName]!
        }

        // let evaluatedOperands = operands.map { $0.eval(args: args) }

        // var evaluatedOperands = [Double]()
        // for operand in operands {
        //     evaluatedOperands.append(operand.eval(args: args))
        // }

        // return operation(evaluatedOperands)

        if operands.count == 1 {
            return operation([operands[0].eval(args: args)])
        }
        else {
            return operation([operands[0].eval(args: args), operands[1].eval(args: args)])
        }

    }


    func toString() -> String {

        guard let operands = operands else {
            return operationName
        }

        // let stringifiedOperands = operands.map { $0.toString() }

        var stringifiedOperands = [String]()
        for operand in operands {
            stringifiedOperands.append(operand.toString())
        }
        
        return "(\(operationName) \(stringifiedOperands.joined(separator: " ")))"
    }
}
